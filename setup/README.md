# Setup

**Start here: [`getting-started.md`](getting-started.md).** It is the
only file in this folder you have to read. Everything else here is
machinery, and the guide tells you when to use it.

You are setting up exactly one thing: an **Ubuntu 24.04** environment
with the course's tools already in it. There is a doorway for whatever
machine you own, and they all open onto the same room:

- **Windows** (Home editions included) → WSL2, built into Windows
- **macOS** → a small Ubuntu VM, via Multipass
- **Linux** → your own package manager; no VM needed
- **Chromebook, a machine you don't have admin rights on, or anything
  that defeated the three above** → GitHub Codespaces, in the browser

Budget about **15 minutes** the first time, most of it download. If
setup fights you, that is an ordinary event with a known fix — the
Troubleshooting section at the end of `getting-started.md` is arranged
by symptom for exactly that reason.

## The other files, and when you touch them

| File | When you use it |
|---|---|
| `getting-started.md` | Week 1, once. Start here. |
| `wsl.user-data` | Windows only. You copy it into place in step A.2; Ubuntu reads it on first boot and builds your toolchain with no prompts. The guide gives the command. |
| `cloud-init.yaml` | macOS only. You name it in the `multipass launch` line in step B.2. Same tool list as `wsl.user-data`. |
| `wsl2-setup.sh` | Windows repair only. Run it if the first-boot setup didn't finish. Safe to run again. |

The browser path needs nothing from this folder — it is driven by
`../.devcontainer/`.

You never have to edit any of these files to take the course. Open them
if you're curious what your environment is actually made of: they are
mostly plain lists of packages, and by week 4 you will recognize a good
number of the names.

## Why these doors and not others

Why WSL2 on Windows rather than a VM, Docker, or a department server —
and why macOS keeps the VM — is answered in the FAQ at the bottom of
`getting-started.md`.
