#!/usr/bin/env bash
# COMP-3100 -- provision a WSL2 Ubuntu 24.04 with the full course toolchain.
#
# This provisions the course's primary Windows environment. On Windows the
# course runs on WSL2 (see setup/getting-started.md, "Path A -- Windows: WSL2").
# Path A normally provisions itself automatically from setup/wsl.user-data on
# first boot; run this script when you want to (re)install the toolchain by
# hand -- the documented repair path if that first-boot setup didn't finish.
#
# It installs the same tools the macOS Multipass VM's cloud-init.yaml installs,
# so a WSL2 student and a Mac student get the same environment (as closely as
# WSL2 allows).
#
# Run it from INSIDE your WSL2 Ubuntu shell, from the repo root:
#
#     bash setup/wsl2-setup.sh
#
# It uses sudo; you will be asked for your WSL password once. Re-running it
# is safe.
#
# ONE KNOWN LIMIT: perf hardware counters (cycles, instructions,
# cache-misses) do not work under WSL2 -- the WSL kernel exposes no CPU PMU.
# Everything else in the course works. See the note printed at the end.

set -uo pipefail

if [ ! -r /etc/os-release ] || ! grep -qi ubuntu /etc/os-release; then
  echo "This script expects an Ubuntu WSL2 distro. Aborting." >&2
  exit 1
fi

# Warn (don't abort) if this isn't the course's pinned Ubuntu release --
# the floating "Ubuntu" WSL alias can hand out a newer LTS.
. /etc/os-release
if [ "${VERSION_ID:-}" != "24.04" ]; then
  echo "WARNING: this distro is Ubuntu ${VERSION_ID:-unknown}, not the course's" >&2
  echo "         pinned 24.04. Tools will still install, but output may differ" >&2
  echo "         from the class. To match: see Path A in" >&2
  echo "         setup/getting-started.md (wsl --unregister, then Ubuntu-24.04)." >&2
fi

# Do the privileged work with sudo, but own the work dir as the human user.
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
[ -n "$TARGET_HOME" ] || TARGET_HOME="$HOME"

echo "== COMP-3100 WSL2 provisioning (user: $TARGET_USER) =="

# apt is told noninteractive per-command below: sudo's default env_reset drops
# an exported DEBIAN_FRONTEND, so we set it on each sudo apt-get line instead.

# universe + multiverse -- manpages-posix lives in multiverse. (Ubuntu's WSL
# image usually has both enabled already; this is belt-and-braces.)
if command -v add-apt-repository >/dev/null 2>&1; then
  sudo add-apt-repository -y universe   >/dev/null 2>&1 || true
  sudo add-apt-repository -y multiverse >/dev/null 2>&1 || true
fi

echo "== apt update =="
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y

# Core toolchain -- the exact package set from setup/cloud-init.yaml so a
# WSL2 student and a Multipass student have the same tools.
#
# `cron` is already installed on a stock Ubuntu 24.04, so naming it here is
# normally a no-op; it is named so this list is complete and self-documenting.
# `man 1 crontab` (Week 1's third seal) and the `crontab` tool (Week 4) both
# come from that package. Starting the cron *service*, which WSL does not do
# on its own, is Week 4's business -- its work order covers it.
echo "== installing the course toolchain (the slow part) =="
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  strace lsof psmisc procps htop sysstat time \
  build-essential gdb valgrind pkg-config \
  man-db manpages manpages-dev \
  vim nano tmux tree file less curl git unzip \
  e2fsprogs util-linux cron

# POSIX man pages (multiverse) -- Work Order 01, Task 3 runs `whatis write` and
# expects four rows; write(1posix) and write(3posix) come from this package.
# Section 2 comes from manpages-dev above. Without this package nothing errors
# -- `whatis write` simply lists two rows instead of four, and the task's "one
# name shelved four ways" collapses into two. The tool check below verifies
# the 1posix page directly.
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y manpages-posix manpages-posix-dev \
  || echo "WARNING: manpages-posix unavailable (needs multiverse) -- Work Order 01, Task 3 will show 2 rows, not 4."

# perf / linux-tools: install what apt has. Under WSL2 it will not match the
# running kernel, so the 'perf' command still won't run (see the note at the
# end) -- best effort, never fatal.
KREL="$(uname -r)"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "linux-tools-$KREL" linux-tools-common 2>/dev/null \
  || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y linux-tools-generic linux-tools-common 2>/dev/null \
  || true

# runcmd equivalents from cloud-init.yaml
sudo mandb -q || true
echo 'kernel.perf_event_paranoid = 1' | sudo tee /etc/sysctl.d/99-perf.conf >/dev/null
sudo sysctl --system >/dev/null 2>&1 || true
sudo install -d -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/comp3100"

# write_files equivalent from cloud-init.yaml: the course login banner. A
# first-boot cloud-init failure is the reason you are running this script, and
# it takes the banner down with it ("I never saw the course banner" in the
# guide's troubleshooting). Rewriting it here leaves a repaired environment
# identical to a cleanly provisioned one. Overwrite, so re-running is a no-op.
sudo tee /etc/motd >/dev/null <<'MOTD'

============================================================
  HONOURABLE GUILD OF ENGINEWRIGHTS — BRASSBRIDGE STATION
                      Ex Vapore, Ordo
============================================================
  Report for duty: see this week's work order.

  man -k <topic>      search the manual
  cat /proc/cpuinfo   the kernel's view of the CPU
  strace -c ls        count this command's system calls
------------------------------------------------------------
Lab notes:   ~/comp3100-student    (clone the repo here)
Submit to:   Canvas — logbook.md + case-notes.md
============================================================
MOTD

# Turn on systemd so services, journalctl, and cgroups behave like a normal
# machine (the labs assume this).
SYSTEMD_NOTE=0
if [ ! -f /etc/wsl.conf ]; then
  printf '[boot]\nsystemd=true\n' | sudo tee /etc/wsl.conf >/dev/null
  SYSTEMD_NOTE=1
elif ! grep -qE '^[[:space:]]*systemd[[:space:]]*=[[:space:]]*true' /etc/wsl.conf; then
  # A wsl.conf already exists without systemd enabled -- don't risk mangling
  # it by appending a second [boot] section; tell the student what to add.
  echo "NOTE: /etc/wsl.conf exists but does not enable systemd. Add these two"
  echo "      lines to it (needs sudo), then run 'wsl --shutdown' from Windows:"
  echo "        [boot]"
  echo "        systemd=true"
fi

echo
echo "== done -- tool check =="
miss=0
for t in gcc g++ make gdb strace valgrind pkg-config mkfs.ext4 debugfs man; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '  ok   %s\n' "$t"
  else
    printf '  MISS %s\n' "$t"; miss=1
  fi
done

# GNU time, not the bash keyword -- installed for parity with
# setup/cloud-init.yaml and .devcontainer/provision.sh; no Wave-1 work order
# uses `/usr/bin/time -v` yet.
if [ -x /usr/bin/time ]; then
  printf '  ok   /usr/bin/time\n'
else
  printf '  MISS /usr/bin/time -- install the "time" package\n'; miss=1
fi

# Work Order 01, Task 3 needs the POSIX pages specifically: it runs
# `whatis write` and expects four rows, and write(1posix) and write(3posix)
# come only from manpages-posix.
if man -w 1posix write >/dev/null 2>&1; then
  printf '  ok   POSIX pages present -- whatis write shows all four rows (Work Order 01, Task 3)\n'
else
  printf '  MISS write(1posix) -- install manpages-posix (multiverse)\n'; miss=1
fi

echo
echo "perf note: the bare 'perf' command can't find a build matching the WSL"
echo "  kernel, but perf SOFTWARE events still work -- invoke the installed"
echo "  build directly, e.g.:  /usr/lib/linux-tools/*/perf stat -e page-faults ls"
echo "  Hardware counters (cycles, instructions, cache-misses) print"
echo "  '<not supported>' under WSL2 (no CPU PMU); no lab depends on them."

if [ "$SYSTEMD_NOTE" = 1 ]; then
  echo
  echo "systemd was just enabled. From Windows PowerShell run:  wsl --shutdown"
  echo "then reopen Ubuntu so it starts under systemd."
fi

if [ "$miss" = 0 ]; then
  echo
  echo "All core tools present. You're set."
else
  echo
  echo "Some tools are missing above -- re-run after checking your network."
fi
