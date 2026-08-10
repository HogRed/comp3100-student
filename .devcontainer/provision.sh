#!/usr/bin/env bash
# COMP-3100 -- provision the Codespaces / devcontainer environment (Path D).
#
# This is the browser-only escape hatch described in setup/getting-started.md,
# "Path D -- Codespaces". It installs the same toolchain the WSL2 and Multipass
# paths get (setup/wsl2-setup.sh, setup/cloud-init.yaml), minus the pieces a
# container cannot have (perf and the kernel-matched linux-tools; the affected
# labs carry Codespaces alternates in their work orders).
#
# It runs automatically as the devcontainer's postCreateCommand. Students run
# it by hand only as the documented repair route:
#
#     sudo bash .devcontainer/provision.sh
#
# Re-running it is safe: every step is idempotent, and the expensive man-page
# repair is skipped once `man 2 read` resolves.
#
# THE ONE NON-OBVIOUS PART -- the man-page repair. The base image is a
# *minimized* Ubuntu: /etc/dpkg/dpkg.cfg.d/excludes tells dpkg to discard
# /usr/share/man/* as packages unpack. Installing manpages-dev under that
# config installs nothing you can read -- `man 2 read` still reports "No manual
# entry", and Work Order 01 leans on section 2 from the first hour. The fix is
# two moves in this order: unminimize (drops the exclude rules), THEN reinstall
# the man-page packages so their pages actually land on disk. Skipping the
# second move is the mistake that cost a round of debugging in v1; hence the
# "round-2 man-page fix" note in the guide's instructor header. unminimize is
# thorough and therefore slow -- it lays down every package that shipped
# documentation -- but it runs only on a first build, and only when section 2
# is genuinely missing.
#
# Ends with the guide's four-command smoke test. Failures there are reported
# loudly but never abort the build -- a codespace you can open and fix beats a
# codespace that refuses to start.

set -uo pipefail

export DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------------------------------
# Preconditions
# --------------------------------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    # No -E: the re-executed script sets everything it needs itself, and -E is
    # refused outright under some sudoers policies.
    exec sudo bash "$0" "$@"
  fi
  echo "This script installs packages and must run as root:" >&2
  echo "    sudo bash .devcontainer/provision.sh" >&2
  exit 1
fi

if [ ! -r /etc/os-release ] || ! grep -qi ubuntu /etc/os-release; then
  echo "This script expects the Ubuntu 24.04 devcontainer base image. Aborting." >&2
  exit 1
fi

# Warn (don't abort) if the image drifted off the course's pinned release.
. /etc/os-release
if [ "${VERSION_ID:-}" != "24.04" ]; then
  echo "WARNING: this image is Ubuntu ${VERSION_ID:-unknown}, not the course's" >&2
  echo "         pinned 24.04. Tools will still install, but output may differ" >&2
  echo "         from the class. Check .devcontainer/devcontainer.json's image." >&2
fi

echo
echo "============================================================"
echo "  HONOURABLE GUILD OF ENGINEWRIGHTS — BRASSBRIDGE STATION"
echo "                      Ex Vapore, Ordo"
echo "============================================================"
echo "  Fitting out your bench. This takes a few minutes the first"
echo "  time and seconds on a rebuild."
echo

# --------------------------------------------------------------------------
# Packages
# --------------------------------------------------------------------------

# universe + multiverse -- manpages-posix lives in multiverse. The base image
# normally enables all four components already; this is belt-and-braces, and
# add-apt-repository may not even be installed.
if command -v add-apt-repository >/dev/null 2>&1; then
  add-apt-repository -y universe   >/dev/null 2>&1 || true
  add-apt-repository -y multiverse >/dev/null 2>&1 || true
fi

echo "== apt update =="
apt-get update -y

# Core toolchain -- the patch-in-place list from setup/getting-started.md, which
# is the same set setup/cloud-init.yaml and setup/wsl2-setup.sh install.
#
# All four lists name `cron`, but only here does it do any work: stock Ubuntu
# 24.04 ships cron already, so the entry is a no-op on the WSL2, Multipass and
# native-Linux paths, while this base image is minimized and genuinely lacks
# it. `man 1 crontab` (Week 1's third seal) and the `crontab` tool (Week 4)
# both come from that package.
echo "== installing the course toolchain (the slow part) =="
apt-get install -y \
  strace lsof psmisc procps htop sysstat \
  build-essential gdb valgrind pkg-config \
  man-db manpages manpages-dev \
  vim nano tmux tree file less curl git unzip \
  e2fsprogs util-linux cron
CORE_RC=$?

# GNU time, not the bash keyword -- installed for parity with
# setup/wsl2-setup.sh and setup/cloud-init.yaml; no Wave-1 work order uses
# `/usr/bin/time -v` yet.
apt-get install -y time \
  || echo "WARNING: the 'time' package did not install -- /usr/bin/time -v will be unavailable."

# POSIX man pages (multiverse) -- Work Order 01, Task 3 runs `whatis write` and
# expects four rows; write(1posix) and write(3posix) come from this package.
# Section 2 comes from manpages-dev above. Without this package nothing errors
# -- `whatis write` simply lists two rows instead of four, and the task's
# "one name shelved four ways" collapses into two.
POSIX_MAN=1
apt-get install -y manpages-posix manpages-posix-dev \
  || { POSIX_MAN=0; echo "WARNING: manpages-posix unavailable (needs multiverse) -- Work Order 01, Task 3 will show 2 rows, not 4."; }

# --------------------------------------------------------------------------
# The round-2 man-page fix (see the header)
# --------------------------------------------------------------------------

echo "== manual pages =="
if man -w 2 read >/dev/null 2>&1; then
  echo "   man 2 read already resolves -- nothing to repair."
else
  echo "   section-2 pages missing: this image is minimized. Repairing."

  # Move 1: drop dpkg's man-page exclusions. Ubuntu 24.04 ships the script in
  # its own 'unminimize' package rather than in base-files.
  if ! command -v unminimize >/dev/null 2>&1; then
    apt-get install -y unminimize >/dev/null 2>&1 || true
  fi
  if command -v unminimize >/dev/null 2>&1; then
    yes | unminimize || true
  else
    # No script available: retire the exclude rules by hand, which is the only
    # part of unminimize this course actually needs. unminimize deletes these
    # files outright; do the same, but keep a copy outside the config directory
    # (dpkg reads every fragment inside dpkg.cfg.d, so a backup cannot live
    # there). Retiring the whole file also clears the groff-data exclusion some
    # minimized images carry -- without groff's macros, man has pages it cannot
    # format.
    echo "   no unminimize script; retiring dpkg's man-page exclusions."
    for f in /etc/dpkg/dpkg.cfg.d/*; do
      [ -f "$f" ] || continue
      grep -q '^path-exclude.*share/man' "$f" || continue
      mv "$f" "/etc/dpkg/$(basename "$f").disabled-by-comp3100" || true
    done
  fi

  # Move 2 -- the one that is easy to forget. The pages excluded on the first
  # unpack do not reappear on their own; the packages have to be laid down
  # again now that dpkg will keep their files. groff-base is in the list
  # because it was unpacked under the same exclusions and man cannot format a
  # page without its macros.
  echo "   reinstalling the man-page packages so their pages land on disk."
  apt-get install -y --reinstall man-db manpages manpages-dev groff-base \
    || echo "WARNING: man-page reinstall failed -- see the smoke test below."
  if [ "$POSIX_MAN" = 1 ]; then
    apt-get install -y --reinstall manpages-posix manpages-posix-dev >/dev/null 2>&1 \
      || echo "WARNING: manpages-posix reinstall failed -- Work Order 01, Task 3 may show 2 rows, not 4."
  fi
fi

# Refresh the man-page database so `man -k` / apropos work immediately.
mandb -q || true

# --------------------------------------------------------------------------
# Smoke test -- the four commands from setup/getting-started.md
# --------------------------------------------------------------------------

# Run the checks as the human who will actually use this shell, not as root:
# ptrace and man both behave differently for root, and a check that only passes
# as root is not a check.
SMOKE_USER="${SUDO_USER:-}"
run_as() {
  if [ -n "$SMOKE_USER" ] && [ "$SMOKE_USER" != "root" ] && command -v runuser >/dev/null 2>&1; then
    runuser -u "$SMOKE_USER" -- "$@"
  else
    "$@"
  fi
}

echo
echo "== smoke test (the four commands from setup/getting-started.md) =="
FAILED=""

check() {                       # check <label> <command...>
  local label="$1"; shift
  if run_as "$@" >/dev/null 2>&1; then
    printf '  ok    %s\n' "$label"
  else
    printf '  FAIL  %s\n' "$label"
    FAILED="${FAILED}${FAILED:+, }${label}"
  fi
}

check 'uname -a'      uname -a
check 'strace -c ls'  strace -c ls
check 'gcc --version' gcc --version
check 'man 2 read'    env MANPAGER=cat MANWIDTH=80 man 2 read

# One extra check, beyond the guide's four. Work Order 01, Task 3 needs the
# POSIX pages specifically: it runs `whatis write` and expects four rows, and
# write(1posix) and write(3posix) come only from this package. It reports as a
# WARNING and deliberately never enters $FAILED: the guide promises "All four
# pass? You're done", so the loud block below stays synchronized with exactly
# those four commands. A container without multiverse is a working container
# with one work-order task to repair.
POSIX_WARN=0
if run_as man -w 1posix write >/dev/null 2>&1; then
  printf '  ok    POSIX pages present -- whatis write shows all four rows (Work Order 01, Task 3)\n'
else
  POSIX_WARN=1
  printf '  WARN  POSIX pages absent -- whatis write will show 2 rows, not the 4 Work Order 01 Task 3 expects (not one of the four checks)\n'
fi

echo
if [ -n "$FAILED" ]; then
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!  PROVISIONING FINISHED WITH FAILED CHECKS:"
  echo "!!    $FAILED"
  echo "!!"
  echo "!!  Your codespace still opened -- but the labs need these."
  echo "!!  Try once more (it is safe to re-run):"
  echo "!!      sudo bash .devcontainer/provision.sh"
  echo "!!  If a check still fails, tell your instructor which one and"
  echo "!!  paste the last twenty lines above."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
elif [ "${CORE_RC:-0}" -ne 0 ]; then
  echo "NOTE: the toolchain install reported an error earlier, but all four"
  echo "      checks pass. Re-run this script if a tool turns up missing later."
else
  echo "All four checks pass. Your bench is fitted out."
  echo "Report for duty: see this week's work order."
fi

# Warning, not failure: none of the guide's four commands depend on this.
if [ "$POSIX_WARN" = 1 ]; then
  echo
  echo "WARNING: the POSIX manual pages are missing. Everything the guide"
  echo "  promises still works; Work Order 01, Task 3's 'whatis write' will simply"
  echo "  show two rows instead of four. One line fixes it:"
  echo "      sudo apt-get install -y manpages-posix manpages-posix-dev"
  echo "  (they live in multiverse; enable it if apt cannot find them.)"
fi

echo
echo "Container note: perf and the kernel-matched linux-tools are deliberately"
echo "  absent -- a container cannot use them. The labs that need them list"
echo "  their Codespaces alternate steps in the work order."

# Never fail the build: a codespace you can open and repair beats one that
# refuses to start.
exit 0
