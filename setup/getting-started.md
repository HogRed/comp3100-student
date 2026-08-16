# Getting Started — Setting Up Your COMP-3100 Linux Environment

> *Door Notice, punched and posted by **Porter Brassfeather**, Keeper of
> the Enginehouse Doors — a clockwork penguin of the old Order, waist-high,
> and helpful to precisely the extent the charter requires.*
>
> *The Guild does not ask you to abandon your own machine. It does not
> ask you to install three things and keep whichever survives the night.
> You are issued **one environment** and the doorway proper to the
> machine you already own. Apprentices on Windows are admitted through a
> door Microsoft built into Windows itself. Apprentices on a Mac are
> issued a small engine of their own. Apprentices already on Linux are,
> in a sense, home. Should your machine refuse all three, present
> yourself to the Porter and say so early — the charter obliges him to
> find you a bench, and it obliges him to do it before the work is due.*
>
> *Whichever door admits you, the room beyond is the same:
> **Ubuntu 24.04**, the same tools, the same bench as the apprentice two
> seats over.*
>
> *Read once. Run once. Then return to your bench.*
>
> `ADMITTANCE: PENDING. FOUR CHECKS BELOW. DELAY: DISAPPROVED OF.`

---

## What you'll have at the end of this guide

There is a door here for whatever machine you already own — and if every
one of them defeats yours, come to your instructor and you will be sorted
out with something that works. Ask early rather than the night a work
order is due. A setup that fights you is a normal event with a known
fix, not a verdict on whether you belong in this room; the
Troubleshooting section at the bottom is arranged by symptom for exactly
that reason.

- A **Ubuntu 24.04 LTS** Linux environment with every tool the course's
  labs use, pre-installed: `strace`, `gcc`, `gdb`, `valgrind`, `lsof`,
  `htop`, `pstree`, full manual pages, and more.
- A single command that drops you into a Linux shell.
- A near-identical environment to every other student in the class.
  (Apple Silicon Macs differ only in CPU architecture; see the note
  under macOS.)

Total time, first setup: **~15 minutes**, most of it download.

## Pick your path

Find the machine you actually have in front of you and take that row.
You need one path, not three.

| Your machine | Your path |
|---|---|
| **Windows 10 or 11** — any edition, Home included | **Path A — WSL2** (below) |
| **macOS 13.3+** — Intel or Apple Silicon | **Path B — Multipass** |
| **Linux** | **Path C — native packages** (or Multipass) |

**None of these three fits the machine you own?** If you are on a
Chromebook or a tablet, or on a machine you don't have administrator
rights to, come and see your instructor in the first week. There is a
way to get you a working bench, and finding it is a five-minute
conversation rather than a lost evening. Nobody here is stopped by
hardware they cannot do anything about — but you have to say so, and
early beats the night a work order is due.

Everyone starts with Step 0.

---

## Step 0 — Get the course materials (all paths)

The course's public materials repo holds the config files that build
your environment, plus the lab files you'll use all semester. Clone it:

```sh
git clone https://github.com/HogRed/comp3100-student.git
cd comp3100-student
```

(If `git` isn't installed on your host yet: on the repo's GitHub page
click the green **Code** button → **Download ZIP**, unzip it, then `cd`
into the unzipped folder. If all you see inside is a single folder named
`comp3100-student-main`, `cd` into that — Windows' *Extract All* often
nests it one level deeper.)

You should now be in a folder that contains `setup/`. Verify:

```sh
ls setup
```

---

## Path A — Windows: WSL2

WSL2 (Windows Subsystem for Linux) is built into Windows 10 and 11,
**including Home editions**. It runs a real Linux kernel — not an
emulation — and it is the *most* reliable path on modern Windows, not a
compromise: the security features that Windows 11 turns on by default
are exactly what WSL2 is designed to work with.

You'll need: **administrator rights** on the machine (once), **~10 GB
free disk**, and a reboot if WSL has never been enabled before.

### A.1 — Update WSL first (do not skip)

In **PowerShell** (Start menu → type "PowerShell"):

```powershell
wsl --update
```

This is not optional polish. Old WSL versions have a subtle
memory-accounting difference that makes one of the later labs *silently
misbehave* — no error, just wrong results. Thirty seconds now saves you
a very confusing afternoon late in the semester.

If `wsl --update` says WSL isn't installed at all, run
`wsl --install --no-distribution`, reboot when asked, then run
`wsl --update` again.

### A.2 — Put the course's config file where WSL looks for it

From the repo folder you cloned in Step 0, in PowerShell:

```powershell
mkdir "$env:USERPROFILE\.cloud-init" -Force
copy setup\wsl.user-data "$env:USERPROFILE\.cloud-init\Ubuntu-24.04.user-data"
```

That file is the course environment's *description* — the tool list,
the settings, your default user. Ubuntu reads it automatically on first
boot and builds everything for you. (It's the same tool list the Mac
students' VMs are built from, adapted to this doorway.)

### A.3 — Install Ubuntu 24.04

```powershell
wsl --install Ubuntu-24.04 --no-launch
```

Reboot if it asks. Then start the first boot and watch the setup run —
this takes **3–8 minutes** (it's installing the whole toolchain):

```powershell
wsl -d Ubuntu-24.04 -u root -- cloud-init status --wait
```

Dots will crawl across the screen; that's normal. When it prints
`status: done`, your environment is built. No username prompts, no
package commands — the config file did all of it.

### A.4 — Enter your environment

```powershell
wsl -d Ubuntu-24.04
```

You should see the COMP-3100 message of the day, then a prompt like:

```
ubuntu@YOURPC:~$
```

Run the **smoke test** (bottom of this guide). Then, to save typing for
the rest of the semester, make this your default distribution — from
PowerShell:

```powershell
wsl --set-default Ubuntu-24.04
```

From now on, plain `wsl` from any terminal drops you in.

### A.5 — Where your files live

- Your Linux home is `~` and there's a ready-made `~/comp3100` folder
  for lab work. This is the fast, native place to work.
- Everything on your Windows drive is reachable at `/mnt/c/...` — e.g.
  the repo you cloned in Step 0 is at
  `/mnt/c/Users/<you>/comp3100-student`. Clone it again *inside* WSL if
  you prefer (fast, native filesystem), or just work against `/mnt/c`.
- **VS Code users:** install the *WSL* extension, then `code .` inside
  WSL opens your Linux files in your Windows editor. Best of both.

### A.6 — Daily workflow (Path A)

| What you want | Command (any Windows terminal) |
|---|---|
| Drop into the Linux shell | `wsl` (after A.4's set-default) |
| A second terminal into the same environment | open another terminal tab, `wsl` again |
| Restart Linux cleanly (rarely needed) | `wsl --shutdown`, then `wsl` |
| Remove everything at semester's end | `wsl --unregister Ubuntu-24.04` |

Closing the terminal is fine; WSL idles in the background and wakes
instantly.

---

## Path B — macOS: Multipass

Multipass is made by Canonical (the company behind Ubuntu). It is free,
open-source, and gives you a small Ubuntu virtual machine. Requires
**macOS 13.3 (Ventura) or later**, Intel or Apple Silicon. (Older
macOS — e.g. 12 Monterey, the ceiling for many 2015–2017 Intel
MacBooks — can't run Multipass; see *UTM* under Troubleshooting, and
tell your instructor if it fights you.)

### B.1 — Install Multipass

1. Download the macOS installer — a single universal `.pkg` for both
   Intel and Apple Silicon — from <https://multipass.run/install>.
2. Open the `.pkg` and follow the prompts.
3. Open **Terminal** (`⌘-Space`, type "Terminal") and verify **both the
   install and the version**:

   ```sh
   multipass version
   ```

   You need **1.16.2 or newer** (1.16.3 at time of writing). Versions
   before 1.16.2 have a macOS 26 (Tahoe) networking bug that makes
   launches time out. If you see something older, re-download the
   installer — don't fight the bug, it's already fixed.

> **Optional, for Homebrew users:** `brew install --cask multipass`
> installs the same app. The cask is community-maintained; if you hit
> trouble, use the `.pkg`.

> **No Rosetta required on Apple Silicon.** Multipass on M-series Macs
> runs Ubuntu *natively* on Arm — fast as a native install.

> **Architecture note — Apple Silicon students, read this.** Your VM is
> `arm64` (aarch64); Windows and Intel machines run `x86_64`. For an OS
> course that is not cosmetic: `uname -m` prints `aarch64` vs `x86_64`,
> `/proc/cpuinfo` looks different, and raw **system-call numbers and
> CPU register names differ** (e.g. `write` is syscall 1 on x86_64 but
> 64 on aarch64). Almost everything in the labs is identical; where a
> lab gives an exact syscall number or x86 register, treat it as the
> `x86_64` value and check your own architecture with `uname -m`.

### B.2 — Launch your VM

From the repo root (Step 0):

```sh
multipass launch --name comp3100 --cpus 2 --memory 2G --disk 10G --cloud-init setup/cloud-init.yaml 24.04
```

That's **one line** — paste it as-is.

- `--cloud-init setup/cloud-init.yaml` — the same tool list the Windows
  students get builds your VM's toolchain on first boot.
- `24.04` — pin the exact Ubuntu LTS the course is tested against
  (don't substitute the `lts` alias; it floats to newer releases).

**Disk space:** have roughly **15 GB free** before you launch.
**This takes 3–8 minutes the first time.** When it finishes:
`Launched: comp3100`.

### B.3 — Enter the VM

```sh
multipass shell comp3100
```

You should see the COMP-3100 message of the day and a prompt like
`ubuntu@comp3100:~$`. Run the **smoke test** (bottom of this guide).
`exit` returns you to macOS; the VM keeps running.

### B.4 — Share files between your Mac and the VM (optional but useful)

From your host shell, **inside the repo folder from Step 0**:

```sh
multipass mount "$PWD" comp3100:/home/ubuntu/comp3100
```

Now you can edit lab reports on the Mac with your favorite editor and
run code against the same files inside the VM. To unmount:
`multipass unmount comp3100:/home/ubuntu/comp3100`.

> **Full Disk Access:** macOS sandboxes `~/Documents`, `~/Desktop`, and
> `~/Downloads`. Simplest fix: keep your clone directly in your home
> folder (`~/comp3100-student`). If a mounted folder shows up empty or
> "permission denied" inside the VM, grant **Full Disk Access** to
> `multipassd` in System Settings → Privacy & Security, then re-mount.

### B.5 — Daily workflow (Path B)

| What you want | Command (run on the Mac) |
|---|---|
| Start the VM (after a reboot) | `multipass start comp3100` |
| Drop into the Linux shell | `multipass shell comp3100` |
| Stop the VM (save battery) | `multipass stop comp3100` |
| Check what VMs you have | `multipass list` |
| See the VM's current resource use | `multipass info comp3100` |
| Remove everything at semester's end | `multipass delete comp3100 && multipass purge` |

You don't have to stop the VM between sessions; closing the laptop lid
suspends it cleanly.

---

## Path C — Linux

You already live in the building. Install the tools with your distro's
package manager and skip the VM:

- **Debian/Ubuntu:** `sudo apt install strace lsof psmisc procps htop
  sysstat build-essential gdb valgrind pkg-config man-db manpages
  manpages-dev manpages-posix manpages-posix-dev tmux tree e2fsprogs
  util-linux cron` (that's the same core tool set
  `setup/cloud-init.yaml` installs; `manpages-posix*` live in
  multiverse, enabled by default on desktop installs). For `perf`,
  later in the course: Ubuntu's package is `linux-tools-$(uname -r)`;
  Debian's is `linux-perf`.
- **Fedora:** `sudo dnf install strace lsof psmisc htop sysstat gcc
  gcc-c++ make gdb valgrind pkgconf-pkg-config perf man-db man-pages
  e2fsprogs util-linux cronie tmux tree` (POSIX man pages:
  `man-pages-posix` from RPM Fusion nonfree, or read them online).
- **Arch:** `sudo pacman -S strace lsof psmisc htop sysstat base-devel
  gdb valgrind perf man-db man-pages cronie tmux tree`.

(`cron` — `cronie` on Fedora and Arch — is what puts `crontab` and its
manual page on your machine. Debian and Ubuntu install it for you; the
other two often don't, and a later week wants it.)

Make sure you can run `strace ls` without `sudo`. (Attaching to an
*already-running* process — `strace -p <pid>` — is a separate
permission, blocked when `kernel.yama.ptrace_scope=1`, the default on
Ubuntu and Arch. No work order asks for it, but it is a natural thing
to try. Check with `sysctl kernel.yama.ptrace_scope`; relax it for the
current boot with `sudo sysctl kernel.yama.ptrace_scope=0`.)

Prefer a VM that exactly matches the class? Multipass works on Linux
too (`sudo snap install multipass`, needs `/dev/kvm`) — follow Path B
from B.2. (The snap can only mount folders under your home directory;
for a removable drive, `sudo snap connect multipass:removable-media`.)

---

## The smoke test (every path)

Whatever door you came through, prove the room works. In your Linux
shell — the **speaking-tube console** (the shell), as the course
materials call it — run:

```sh
uname -a
strace -c ls
gcc --version
man 2 read
```

- `uname -a` — prints the kernel banner (WSL2 students will see
  `-microsoft-standard-WSL2`; that's correct).
- `strace -c ls` — runs `ls` and prints a table counting its system
  calls. If you get a syscall table, the single most important lab tool
  works.
- `gcc --version` — the C compiler.
- `man 2 read` — opens the *system call* manual page for `read` (press
  `q` to leave). If it opens, the syscall manual pages the labs lean
  on are installed.

That is the whole apparatus this course runs on: the kernel answers, the
tracer traces, the compiler compiles, and the manual is on the shelf.
Everything the rest of the semester asks of you happens in this room —
one command, or one browser tab, away.

All four pass? **You're done. Go back to the lab.** Any of them fail?
Find your symptom under Troubleshooting.

---

## Troubleshooting

This section is arranged by symptom rather than by cause, because when a
setup breaks, what you actually have is a screen full of red text and no
theory about it. Find the bold line that sounds like yours. None of
these mean you are doing it wrong — they are the ordinary ways laptops
differ from one another, and every one of them has a known way through.

### Path A (WSL2)

**`wsl --install` fails with `0x80370102`, or WSL says virtualization
is not enabled.** Hardware virtualization (VT-x / AMD-V) is switched
off in your machine's BIOS/UEFI firmware; some laptops ship that way.
Task Manager → Performance → CPU will show "Virtualization: Disabled".
Reboot into firmware setup (Settings → System → Recovery → Advanced
startup → UEFI Firmware Settings) and enable the setting named "Intel
Virtualization Technology", "VT-x", "SVM Mode", or "AMD-V". This is a
one-time, reversible firmware toggle — annoying, not dangerous.

**The Ubuntu download hangs or the Microsoft Store is blocked.**
Sidestep the Store entirely:

```powershell
wsl --install Ubuntu-24.04 --no-launch --web-download
```

**`Invalid distribution name: Ubuntu-24.04`.** Your WSL is out of
date — you skipped A.1. Run `wsl --update`, then retry.

**No administrator rights on this machine** (school- or
parent-managed). You genuinely cannot install WSL, and no amount of
persistence will change that. Come and see your instructor in the first
week — this is a solvable problem, but not one you can solve alone at
11pm.

**`cloud-init status` reported `error` instead of `done`.** Usually a
network hiccup during the package install. See exactly what failed with
`wsl -d Ubuntu-24.04 -u root -- cloud-init status --long`. Cleanest
fix: `wsl --unregister Ubuntu-24.04` and redo A.2–A.3 on a more
reliable network (home wifi instead of campus wifi). Or patch in
place — inside WSL, run the apt line under *"a tool is missing"* below.

**It installed, but I never saw the course banner and my username is
wrong.** The config file wasn't in place before the first boot — A.2
after A.3 doesn't work (first boot already happened without it).
`wsl --unregister Ubuntu-24.04`, then redo A.2 → A.3 in order.

**Disk space.** The Ubuntu environment wants ~10 GB. WSL disks grow on
demand, so a nearly-full laptop can fail now or weeks from now, and the
error rarely says "disk." Keep ~10 GB free on `C:`.

**`perf` says it can't find a build for your kernel.** Expected under
WSL2 — the `perf` wrapper looks for a build matching Microsoft's kernel,
and there isn't one. Invoke the installed build directly:

```sh
/usr/lib/linux-tools/*/perf stat -e page-faults ls
```

Software events count fine this way; hardware counters (`cycles`,
`instructions`) print `<not supported>` on WSL2, and no lab needs them.

### Path B (Multipass on macOS)

**`multipass launch` times out, or the VM has no IP.** First check
`multipass version` — anything below **1.16.2** has a known macOS 26
bug with exactly this symptom; upgrade and relaunch. Otherwise, clear
the wreckage (`multipass delete comp3100 && multipass purge`) and retry
on a different network (captive portals and strict campus wifi can
stall the image download).

**macOS older than 13.3.** Multipass won't install. Use a local VM
instead: **UTM** (<https://mac.getutm.app/>) with the
Ubuntu Server 24.04 ISO — on Apple Silicon the **arm64** ISO from
<https://cdimage.ubuntu.com/releases/24.04/release/> (use *Virtualize*,
never *Emulate*); on Intel the amd64 ISO from
<https://releases.ubuntu.com/24.04/>. (Don't use ubuntu.com's main
download page — it tracks a newer LTS than the course targets.)

**Mounted folder is empty / permission denied.** See B.4's Full Disk
Access note.

**Daemon or socket errors (`cannot connect to the multipass socket`).**
Wait a minute (the daemon may still be starting), then restart it:
`sudo launchctl kickstart -k system/com.canonical.multipassd` and retry.

**`multipass shell` returns instantly with no prompt.** The VM is still
booting (the first-boot setup is still running). Try again in 30
seconds; watch progress with `multipass info comp3100`.

**The VM is slow / runs out of memory.** Stop it, give it more, restart:

```sh
multipass stop comp3100
multipass set local.comp3100.memory=4G
multipass set local.comp3100.cpus=4
multipass start comp3100
```

**`launch failed: instance "comp3100" already exists`.** A failed or
interrupted launch left a half-built VM behind. Remove it, then
relaunch: `multipass delete comp3100 && multipass purge`.

### Every path

**A tool is missing** (`strace: command not found`, or any other).

- **Paths A and B:** the first-boot setup didn't finish. Check it —
  inside your Linux shell:

  ```sh
  cloud-init status --wait
  ```

  If it ends `done`, re-run the smoke test. If it reports `error`,
  patch in place with the package list below (Path A students can
  equivalently re-run `bash setup/wsl2-setup.sh` from the repo — it's
  idempotent).
- **Path C:** re-run your distro's install line from the Path C list.

The patch-in-place package list (Paths A/B) — the same set the config
installs:

```sh
sudo apt update && sudo apt install -y strace lsof psmisc procps htop sysstat time build-essential gdb valgrind pkg-config man-db manpages manpages-dev manpages-posix manpages-posix-dev vim nano tmux tree file less curl git unzip e2fsprogs util-linux cron
sudo apt install -y "linux-tools-$(uname -r)" linux-tools-common || sudo apt install -y linux-tools-generic linux-tools-common
```

(Don't install just the one missing tool, or a later lab hits the next
gap.)

**`command not found` for the launcher itself** (`wsl`, `multipass`)
right after installing. Open a *new* terminal — your shell needs to
re-read `PATH`. Still nothing? Reboot.

---

## A short FAQ

**Q. Windows students used to get a Multipass VM. Why WSL2 now?**
**A.** Because of a hardware tug-of-war you shouldn't have to referee.
A VirtualBox-based VM needs the CPU's virtualization hardware *to
itself*, and modern Windows 11 — with Memory Integrity on by default —
already gave it to Windows' own hypervisor. WSL2 *is built on* that
hypervisor, so the very machines where the old path failed are the
machines where WSL2 just works. Same Ubuntu, same tools, same config
file — sturdier doorway.

**Q. Is WSL2 "real Linux"?**
**A.** It's a real Linux kernel running in a lightweight VM Microsoft
maintains, with real `systemd` as PID 1, real `/proc`, real everything
the labs touch. The one exception in this course: CPU *hardware
performance counters* aren't exposed — and the labs are designed so
nothing depends on them. (Software event counting works; see Path A
Troubleshooting for the one quirk in how you invoke `perf`.)

**Q. Why not Docker?**
**A.** Docker is great for application development. For an OS course,
its containerized `/proc` view, its own PID 1, and the capability flags
needed just to run `strace` get in the way of the very things you're
learning about. WSL2 and the VM are unmuddied, and that is worth more
here than the convenience a container would buy you.

**Q. Why not just SSH into a department server?**
**A.** Some semesters there is one and you can. Your own environment
also works offline, off-campus, and when the server is down — and
being root on your own kernel is half the point of the back half of
the course.

**Q. Will I be allowed to use my environment during exams?**
**A.** Assume not. Exams are individual and closed-resource unless your
instructor says otherwise *in writing*, and no AI use during an exam.
The full wording is in the syllabus, under *Academic integrity* and
*Use of AI tools* — read it once now rather than the night before.
