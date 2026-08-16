# WORK ORDER No. 1851-01 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 17 August 1851 — sixteen weeks to the Exhibition |
| **Due** | **Friday, August 21, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

Brassbridge runs on the Grand Analytical Engine — forty feet of figure
wheels, drive shafts under every street, answers by pneumatic capsule
four minutes after the question. In sixteen weeks the Great Exhibition
opens *here*, and Old Brass is to be its centrepiece, certified and
demonstrated before the crowned heads and engineering societies of the
world.

Which is why the Guild has taken you on.

This morning you were issued a bench-console, a brass key, and a
logbook, and told the two rules of the house: *write down what you
did*, and *never trust a figure you have not checked*. The Engine, I am
pleased to report, is in fine fettle. Nothing is wrong. Officially.

Your induction is threefold: prove your bench-console answers when
spoken to; learn your way around the rooms of your bench; and learn to
read the Engine's manuals — every mechanism in this house has one, and
an enginewright who will not read the manual is an enginewright who
guesses. The Guild does not employ guessers.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Here is what I actually care about this week. The fiction is set
dressing; the commands are the course, and **no task ever requires
story knowledge.** But underneath the brass, you are learning the thing
every program on every machine you will ever use depends on: how a
program asks the machine for help. Start there and a great deal stops
being mysterious.

By Friday you will be able to:

1. **Describe what an operating system does** for the programs it runs
   — *zyBooks 1.1*.
2. **Navigate a Linux system with the shell** — `pwd`, `cd`, `ls`,
   `cat`, and friends — *zyBooks 1.2*.
3. **Read manual pages**, including choosing between numbered sections.
4. **Run the course smoke test** and show your environment is ready for
   the whole semester.

## Provisions

**P1 — A working Linux environment.** Follow
[`setup/getting-started.md`](../../setup/getting-started.md) (about 15
minutes, most of it download). Every path — Windows/WSL2,
macOS/Multipass, native Linux — lands in the same Ubuntu 24.04 room
with the same tools.

**P2 — This folder, open in your Linux shell.** Everything below runs
from the `labs/week-01` folder of the course repo. Open your Linux
shell and go there — pick the line that matches where Getting Started
Step 0 left your clone.

If you cloned the repo inside Linux:

```sh
cd ~/comp3100-student/labs/week-01
```

If you're on Windows/WSL2 with the repo cloned on the Windows side —
replace `<YourWindowsName>`, and let the Tab key finish the path:

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-01
```

If you're on macOS/Multipass and mounted your Mac's clone into the VM
(Getting Started, B.4):

```sh
cd ~/comp3100/labs/week-01
```

**P3 — Report for duty.** One command stages your bench for the week:

```sh
bash report-for-duty.sh
```

Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-01 :: bench staged and verified
  ------------------------------------------------------------------
   Bench:     ~/enginehouse   (inbox, ledgers, spool, machinery)
   Inbox:     2 items await your attention
   Greeting:  added to ~/.bashrc -- appears on NEW terminals only
              (this terminal was already open; the next one salutes)

   Apprentice enrolled. The Chief expects your logbook Friday.
  ------------------------------------------------------------------
```

Safe to re-run any time — it re-stages the same bench and never
duplicates anything. (`bash report-for-duty.sh --reset` removes
everything it created, should you ever want a pristine start.)

**P4 — Your paperwork.** Copy the two templates (once):

```sh
cp ../templates/logbook-template.md logbook.md
cp ../templates/case-notes-template.md ../../case-notes.md
```

`logbook.md` stays here in `labs/week-01` — it's this week's report.
`case-notes.md` lands at the repo root and runs all semester — one
short entry a week, every week, starting this one.

> **How wax seals work.** Each task below ends with a `make` command
> that checks your work at the bench. If the check passes, it prints a
> **wax seal** — a short code you paste into your logbook under that
> milestone. That's the whole ritual: work, check, seal, paste. The
> seal codes printed in this work order are illustrations, not answers
> — a seal only prints when the check actually passes at your bench.

> **If you're lost, start here (Provisions).**
> Getting a machine set up is the least interesting part of the week
> and the likeliest to bite. It is not a measure of you; work the list.
> - Run `pwd`. The output should end in `labs/week-01`. If it doesn't,
>   re-run the `cd` line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell,
>   not Linux. Type `wsl` and press Enter, then re-run the `cd` line.
> - Can't find your repo clone at either P2 path? You may have skipped
>   Getting Started **Step 0** — do that first, then return here.
> - `report-for-duty.sh: No such file or directory`? You're in the
>   wrong folder. `pwd`, then P2 again.

---

## Task 1 — Prove the bench answers *(~15 minutes → Seal M1)*

The Guild certifies every bench before it certifies anything *on* the
bench. Four commands, four proofs. Run each one and glance at the
output — you'll write one sentence about each in your logbook.

**1. Ask the kernel to identify itself:**

```sh
uname -a
```

Expected (WSL2 shown; Mac and native Linux differ in the middle — fine):

```
Linux YOURPC 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC ... x86_64 GNU/Linux
```

That one line is the kernel — the Overseer itself — stating its name,
version, and CPU architecture for the record.

**2. Count a command's system calls:**

```sh
strace -c ls
```

Expected — your file listing, then a table like:

```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 27.01    0.002298          65        35        13 openat
 23.35    0.001987          66        30           mmap
 13.15    0.001119          46        24           close
   ...
------ ----------- ----------- --------- --------- ----------------
100.00    0.008509          57       148        16 total
```

Every row is `ls` asking the operating system to do something on its
behalf. (Thirty-five `openat` calls to list one small folder — the
Engine consults a great many drawers to answer a small question.
Week 2 is entirely about this table.)

**3. Ask for the C compiler:**

```sh
gcc --version
```

Expected (first line; minor version drift is fine):

```
gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
```

A present, versioned compiler is the bench's forge: from Week 2 on
you'll feed it small C programs that speak to the kernel directly.

**4. Open a manual page from section 2:**

```sh
man 2 read
```

Expected: a full-screen page opens, headed `read(2)`, `System Calls
Manual`. **Press `q` to leave it.** If it opens at all, the manual
sections the labs lean on are installed.

**Now claim the seal.** From `labs/week-01`:

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-01/check'
Makefile
  ~~~ WAX SEAL of the Guild: 9A41C7F2 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-01/check'
```

(The stray file listing is the checker running `strace` on a real
command as proof; paste the code your own run prints, not this one.)
Paste your seal into `logbook.md` under **Milestone 1**, with one
sentence per smoke-test command: what did it prove about your machine?

> **If you're lost, start here (Task 1).**
> - Run `pwd`. It should end in `labs/week-01`; if not, Provisions P2.
> - `make: command not found` or `uname` prints nothing sensible?
>   You're not in your Linux shell — type `wsl` (Windows) or open your
>   VM's terminal, then P2.
> - One of the four smoke commands failed? Go straight to
>   **Troubleshooting** in `setup/getting-started.md` — it's organized
>   by exact symptom, and "a tool is missing" has a one-line fix.
> - `make: *** check: No such file or directory.  Stop.`? You ran
>   `make` from the wrong folder. `pwd`, then P2, then
>   `make -C check m1`. (Same cure if you ever see
>   `../../lib/seal.sh: No such file or directory`.)
> - Stuck inside a manual page? Press `q`.

---

## Task 2 — Learn the house *(~15 minutes → Seal M2)*

Your bench workspace is `~/enginehouse` — four rooms the staging built
for you. Walk through every one of them. (These commands work from any
folder: paths starting with `~` mean "from my home".)

**1. Survey the bench:**

```sh
ls -la ~/enginehouse
```

Expected:

```
total 24
drwxr-xr-x 6 you you 4096 Aug 17 09:00 .
drwxr-x--- 8 you you 4096 Aug 17 09:00 ..
drwxr-xr-x 2 you you 4096 Aug 17 09:00 inbox
drwxr-xr-x 2 you you 4096 Aug 17 09:00 ledgers
drwxr-xr-x 2 you you 4096 Aug 17 09:00 machinery
drwxr-xr-x 2 you you 4096 Aug 17 09:00 spool
```

Four rooms: **inbox** (papers addressed to you), **ledgers** (records),
**spool** (job output), **machinery** (working parts). The `-la` flags
mean *long listing, hidden files included*; the leading `d` on each
line means *directory*. (The rest of that permissions column is a
Week 13 topic — the Guild does not hand new apprentices every key on
day one.)

**2. Check the empty rooms — empty rooms are rooms too:**

```sh
ls ~/enginehouse/spool
```

Expected: nothing at all. A bare prompt. (`ls` reporting an empty room
says nothing, which is exactly what is in there. Later weeks will give
the spool plenty to say.)

**3. Open the inbox:**

```sh
ls ~/enginehouse/inbox
```

Expected:

```
noticeboard.txt  punch-card-fragment.txt
```

**4. Ask what the items are before opening them:**

```sh
file ~/enginehouse/inbox/*
```

Expected:

```
/home/you/enginehouse/inbox/noticeboard.txt:         ASCII text
/home/you/enginehouse/inbox/punch-card-fragment.txt: ASCII text
```

(`file` judges contents, not filenames — a habit worth keeping.)

**5. Read the noticeboard:**

```sh
cat ~/enginehouse/inbox/noticeboard.txt
```

Expected: the morning's notices — an Exhibition countdown poster
(`XVI WEEKS REMAIN`) and, below it, an older item from the Civic
Pensions Board with a pencil note in the margin. Read both; you're
about to want them for your case notes.

**6. Examine the fragment:**

```sh
cat ~/enginehouse/inbox/punch-card-fragment.txt
```

Expected:

```
.......O....O.......
...O...O............
.......O....O.......
...O...O............
.......O....O.......
...O...O............
.......O........O...
.......O....O.......
...O...O............
.......O............
...O................
.......O....O.......
```

A punched card, or the torn corner of one — `O` where a hole is
punched, `.` where the card is blank. Every card a loom accepts gets a
registration stamp pressed along its edge; this one has none, which is
why the porter, having no procedure for it, delivered it to the new
cohort's inbox. (The Guild teaches card-reading in a few weeks. Nothing
stops an apprentice counting holes early.)

**7. Measure it:**

```sh
wc -l ~/enginehouse/inbox/punch-card-fragment.txt
```

Expected:

```
12 /home/you/enginehouse/inbox/punch-card-fragment.txt
```

`wc -l` counts lines: twelve rows, the standard height of a punched
card. Note it in your logbook.

**Claim the seal.** From `labs/week-01`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-01/check'
  ~~~ WAX SEAL of the Guild: 51D3B9E0 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-01/check'
```

Paste your seal under **Milestone 2**, with two or three sentences on
what you found in `~/enginehouse` and how. (You'll file a case note on
the inbox in a moment — that's the section after Task 3.)

> **If you're lost, start here (Task 2).**
> - `ls: cannot access '/home/you/enginehouse': No such file or
>   directory`? You haven't reported for duty on this machine yet —
>   Provisions P2 then P3, and the bench will be there.
> - Typing the long paths is misery? It's meant to be. Press **Tab**
>   after a few letters and the shell finishes the path; press Tab
>   twice to see the choices. This is the week's best lesson.
> - `cat` printed nothing? You probably cat'ed the spool. Run
>   `ls ~/enginehouse/inbox` and use a filename it actually shows.
> - The seal check failed? Run `bash report-for-duty.sh` again (safe),
>   then `make -C check m2`.

---

## Task 3 — Read the manuals *(~15 minutes → Seal M3)*

The manual is one command, `man`, but it is a **library in numbered
sections** — and the same name can shelve different pages in different
sections:

| Section | What lives there | Example |
|---|---|---|
| 1 | Commands you type at the shell | `man 1 ls` |
| 2 | System calls — requests to the kernel | `man 2 read` |
| 3 | C library functions | `man 3 printf` |
| 5 | File formats | `man 5 passwd` |
| 8 | Administrator tools | `man 8 mount` |

**1. See one name shelved four ways:**

```sh
whatis write
```

Expected:

```
write (1)            - send a message to another user
write (1posix)       - write to another user
write (2)            - write to a file descriptor
write (3posix)       - write on a file
```

**2. Open the section-1 page** (press `q` to leave each page):

```sh
man 1 write
```

Expected — the header and NAME line read:

```
WRITE(1)                     User Commands                     WRITE(1)

NAME
       write - send a message to another user
```

**3. Now the same name in section 2:**

```sh
man 2 write
```

Expected:

```
write(2)                  System Calls Manual                  write(2)

NAME
       write - write to a file descriptor
```

Same word, different machinery: section 1's `write` sends notes
between logged-in users — the 1970s equivalent of passing a chit
across the gallery — while section 2's `write` is how every program
that has ever printed anything actually asked the kernel to print it.
This is why careful people write `write(1)` or `write(2)`, never just
"write": **the section number is part of the name.** In your logbook,
one sentence on the difference.

**4. One more manual, for the record.** Look up:

```sh
man 1 crontab
```

Expected — the NAME line reads:

```
NAME
       crontab - maintain crontab files for individual users (Vixie Cron)
```

Read the first paragraph of its DESCRIPTION too, then record in your
logbook, in one sentence of your own, what `crontab` is *for*. That's
the whole task — you won't need the tool itself for some weeks yet,
and when you do, you'll be glad the sentence is already in your book.

**5. When you don't know the name at all**, search by keyword:

```sh
man -k clock
```

Expected: a list of every page whose short description mentions clocks
— which is how you find a manual when all you have is a topic.

**Claim the seal.** From `labs/week-01`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-01/check'
  ~~~ WAX SEAL of the Guild: E0C4A118 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-01/check'
```

Paste your seal under **Milestone 3** with your `write(1)`-vs-`write(2)`
sentence and your `crontab` sentence.

> **If you're lost, start here (Task 3).**
> - Stuck in a manual page? **`q` quits.** Space scrolls down, `b`
>   scrolls back, `/word` searches inside the page.
> - `No manual entry for write in section 2`? Your manual pages are
>   incomplete — run the "a tool is missing" fix in
>   `setup/getting-started.md` Troubleshooting.
> - `man -k` returns `nothing appropriate`? Run `sudo mandb`, then try
>   again.
> - The seal check failed but both pages opened? Make sure you're in
>   `labs/week-01` (`pwd`), then `make -C check m3`.

---

## Case notes — first entry

Anything odd in the inbox? File a paragraph. This notebook is the part
of the course that behaves most like real work: you write down what you
noticed before you know whether it matters, and the meaning shows up
weeks later. Open `case-notes.md` (you copied it to the repo root in
P4) and fill in the Week 1 row: what you found, the command that showed
it to you, and what you make of it. Guesses are welcome and graded
kindly — the notebook is marked on being kept honestly, never on being
right early. Two habits worth starting now: **copy dates exactly**, and
note anything that seems to be missing as carefully as anything that's
present.

## Reflection (both prompts go in your logbook)

Two questions, and neither one has a trick in it. Answer in your own
words — I would far rather read a plain sentence you mean than a
polished one you borrowed.

1. In two or three sentences: what does an operating system actually
   *do* for a program like `ls`? You watched it happen — the `strace`
   table in Task 1 is `ls` asking the OS for things, one row at a
   time. (*zyBooks 1.1 vocabulary welcome but not required.*)
2. The same name, `write`, means a chat command in section 1 and a
   kernel call in section 2. Why is a sectioned manual a sensible
   design — and when this week did the section number save you (or
   cost you) time?

## Turn it in

Due **Friday, August 21, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)):

1. **`logbook.md`** — all three milestones: what you did, the seal
   pasted in, what it means; plus both reflection prompts and the
   time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 1 entry.

Upload both files to the Week 1 assignment. The three seals are
completion checks and carry 30% of the grade; the prose carries the
other 70% — findings, reasoning, reflection.

That closes all four objectives: the smoke test (M1) is objective 4,
the walk through `~/enginehouse` (M2) is objective 2, the manual work
(M3) is objective 3, and Reflection prompt 1 is objective 1 in your
own words.

> `SUBMISSION: EXPECTED BY FRIDAY 11:59 PM.`
> `WAX SEALS: THREE. ADMIRED.`
> `LATENESS: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

None of this is required and none of it is graded, which is exactly
what makes it the fun part. Think of it as the shelf I would pull down
if you stopped by my office and asked what else is in there.

- `man 1 intro` — a guided tour of the shell written decades ago for
  people meeting Unix for the very first time, and still one of the
  friendliest pages in the whole library.
- `man man` — the manual's manual, including what all the sections are.
- The fragment in your inbox is a real encoding — every hole means
  something, and the Guild teaches card-reading in a few weeks. An
  apprentice with a pencil and patience needn't wait.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
