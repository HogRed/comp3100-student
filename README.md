# COMP 3100 — Operating Systems
### *The Case Files of the Grand Analytical Engine*

**Harding University · Fall 2026**

```
=================================================================
  PUNCHED CHIT No. 1 -- issued at the Enginehouse door
  by PORTER BRASSFEATHER, Keeper of the Doors, of the old Order
=================================================================
  ADMITTANCE . . . . . . PENDING
  BENCH  . . . . . . . . UNCLAIMED
  LOGBOOK  . . . . . . . NOT YET OPENED
  TRACK GREASE . . . . . DISAPPROVED OF

  The charter obliges the Porter to tell you what follows.
  The charter does not oblige the Porter to be pleasant about it.
=================================================================
```

Welcome to the Enginehouse. This repository is your bench: every work
order, every starter file, and every configuration the course needs
lives here, and it is yours to clone, break, and keep.

The city of Brassbridge runs on the Grand Analytical Engine, and in
sixteen weeks the Great Exhibition opens with Old Brass at its centre.
The Guild has taken on an apprentice cohort to see it certified. That
is the fiction. The course underneath it is Linux, C, processes,
memory, files, and concurrency — **nothing you are ever asked to do
requires story knowledge.** The commands are the course; the brass is
set dressing you are welcome to enjoy.

---

## Step 0 — build your Linux environment

Do this first, before the first work order.

> **→ [`setup/getting-started.md`](setup/getting-started.md)**

It picks the right doorway for the machine you already own — Windows
(WSL2), macOS (Multipass), native Linux, or a browser (GitHub
Codespaces) — and lands every one of them in the same Ubuntu 24.04 room
with the same tools. About 15 minutes, most of it download. Finish with
the smoke test at the bottom of that page; if all four checks pass, you
are admitted.

## What's in here

| Folder | What it holds |
|---|---|
| `setup/` | Step 0: the environment guide plus the config files it uses. |
| `syllabus/` | `syllabus.md` (policies, grading) and `schedule.md` — **the authoritative list of dates.** |
| `labs/week-NN/` | That week's `work-order.md`, its `report-for-duty.sh` bench-setup script, any `starter/` code, and `check/` (the wax-seal checkpoints). |
| `labs/templates/` | `logbook-template.md` and `case-notes-template.md` — copy these once, keep them all semester. |
| `labs/appendix-c-refresher.md` | The C refresher, for when a work order asks for C and it has been a while. |
| `commissions/` | The Guild Commissions — the department's five programming projects, submitted in zyBooks. Each cover page lands here as it is assigned. |
| `.devcontainer/` | Powers the browser/Codespaces path. You never edit it. |

## How a week runs

1. **Monday** — the episode deck in class: the story beat, the concept
   lecture, then the briefing for the week's work order.
2. **Wednesday & Friday** — studio. You work the work order at your own
   bench while the instructor circulates.
3. **Friday, 11:59 pm** — your `logbook.md` and your running
   `case-notes.md` are due on Canvas.

Each work order starts the same way — from the week's folder:

```sh
bash report-for-duty.sh
```

That stages your bench (safe to re-run; `--reset` undoes it). As you
finish each milestone, `make -C check mN` checks your work and prints a
**wax seal** — a short code you paste into your logbook as proof that
milestone passed. A seal is a completion marker, not a signature: it
proves a check passed, not who ran it. That is why most of a work
order's grade is your own writing.

Exact dates, weightings, and the late policy live in
[`syllabus/schedule.md`](syllabus/schedule.md) and
[`syllabus/syllabus.md`](syllabus/syllabus.md). If a date anywhere else
disagrees with the schedule, the schedule wins.

## Keeping your own work, and getting each new week

Clone this repository **once**, at Step 0, and work inside that clone all
semester. Commit your `logbook.md` and `case-notes.md` as you go — `git
commit` is local, it never sends anything anywhere, and it costs you
nothing to do often.

**Keep a copy somewhere that is not your machine.** A laptop can die the
week a work order is due, and on the Codespaces path an idle codespace is
eventually deleted along with every commit inside it. Two ways to be
safe, and you only need one:

- **Your weekly Canvas upload already is one.** Turn in `logbook.md` and
  `case-notes.md` every Friday and the worst a dead machine costs you is
  the current week.
- **Or keep your own backup repository on GitHub** — see below. This is
  entirely optional.

Each week's work order lands here on the Monday it is assigned, and
corrections land whenever they are found. So this repository will look
thin in week one and fill up as the semester goes — that is expected,
not a missing download. Before starting a week:

```sh
git pull
```

Your own files come along untouched — the course never writes to your
`logbook.md`, your `case-notes.md`, or anything under a name it does not
ship.

The one way to make that painful is to **edit a course file you were not
asked to edit**. Work orders can change under you; if you have edited
one, `git pull` stops and asks you to resolve a conflict. Avoid it by
copying before you edit:

```sh
cp labs/week-01/work-order.md my-notes-week-01.md
```

**The `starter/` files are the exception** — Weeks 2 and 3 ask you to
repair `starter/hello-brassbridge.c` and `starter/pantograph.c` *in
place*, because that is exactly what `make -C check m1` compiles. Edit
those where they sit; `git checkout -- <file>` puts the original back if
you need it.

If a pull does stop on a conflict, `git merge --abort` puts you back
exactly where you were — nothing is lost. Bring it to studio; it is a
two-minute fix and a good thing to have seen once.

Do **not** re-clone to get a new week. A second clone leaves your
logbook behind in the first one.

## Your own copy on GitHub — optional, and never graded

You do not need a GitHub account for this course. Cloning and pulling
works exactly as described above with no account at all, and **nothing
here is graded** — your Canvas upload is the submission, always. This
section is for students who would rather their work lived somewhere
other than one laptop.

**Make your own repository, and keep it private.** On GitHub, create a
new **private** repository — call it `comp3100-work` or anything you
like — and create it *empty*: no README, no .gitignore, no licence.
Then, from inside the clone you already have:

```sh
git remote add backup https://github.com/YOUR-USERNAME/comp3100-work.git
git push -u backup main
```

That is the whole setup. From then on your week is two commands:

```sh
git pull                 # the course -- new work order, corrections
git push backup main     # you -- your logbook and case notes, saved
```

`origin` still means this course repository and `backup` means yours, so
pulling each new week works exactly as it always did.

**Private matters, and not for etiquette.** Your `case-notes.md` is your
running theory of the season's case and your `logbook.md` holds your
reflection answers. A public repository hands both to the rest of the
cohort, which is a collaboration-policy problem for you rather than for
them. Keep it private and it is simply your own safe copy.

**Do not fork this repository to do it.** Forking is the obvious move and
it is the wrong one here: GitHub does not let you make a fork of a public
repository private, so a forked course repo publishes your answers to
everyone, permanently. A separate private repository, as above, is the
version that keeps your work yours.

The first `git push` will ask who you are. GitHub's own instructions for
that are better and fresher than anything printed here — see
<https://docs.github.com/get-started/git-basics/caching-your-github-credentials-in-git>.
On the Codespaces path you are already signed in and it will simply work.
If it fights you, bring it to studio; it is not worth an evening alone.

```
=================================================================
  ADMITTANCE: GRANTED, PROVISIONALLY, PENDING STEP 0.
  Ex Vapore, Ordo.
=================================================================
```
