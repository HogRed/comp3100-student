# WORK ORDER No. 1851-05 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 14 September 1851 — twelve weeks to the Exhibition |
| **Due** | **Sunday, September 20, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The Engine has been wrong twice this month.

Not broken. Not stopped. **Wrong** — which is a different and much worse
thing, because a stopped engine announces itself and a wrong one does
not. Table IX of the Waterworks returns came back from the floor with a
total that no one on the floor could reproduce, and when the clerks ran
it again they got a third number.

Here is what we know. Table IX is woven by the **twin looms** — north
and south — and both of them write the same output ledger. When only
one loom runs, the ledger is fine. When both run together, entries go
missing: not the same entries, not the same number of them, and never
twice alike.

This week you will build that fault at your own bench, in miniature, out
of sixty lines of C you can read in one sitting. You will watch a count
of four hundred thousand come out short, come out short *differently*,
and come out short for a reason you can draw on paper. Then you will
stop it with one of the oldest tools in the trade.

And then — because this is what the Guild is actually for — you will
take the two disputed figures out of Table IX and **check them by hand**,
from the working papers they were computed from. Not to prove anybody
right. To be the sort of engineer who has the number.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Every program you have written so far did one thing at a time. Real
software does not. A browser tab, a game, a web server, the shell you
are typing into — all of them run several **threads** at once, inside one
process, over one shared pile of memory. That sharing is what makes
threads fast, and it is also the single most reliable source of bugs in
professional software: bugs that pass every test, ship, and then fail
once a fortnight on a customer's machine for no reason anyone can name.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By Friday you will be able to:

1. **Say what a thread is, and how it differs from a process** — same
   program, same memory, its own line of execution — and say what the two
   threads in `twin-looms.c` share and what they keep to themselves.
   *zyBooks Ch 4.1 (process interactions).*
2. **Define a critical section and a data race**, and explain why a race
   is not a rare event: it is a *normal* event you have not happened to
   observe yet. *zyBooks Ch 4.1 (critical sections).*
3. **Fix a race with a mutex** — declare it, lock it, unlock it — and
   show that the fixed program is not merely better but **exact and
   repeatable**. *zyBooks Ch 4.1.*
4. **Check a computed figure by hand** against the papers it was computed
   from, and report the disagreement you find without deciding, in the
   work order, what it means.

Objective 4 is not a computing skill and I am not pretending it is. It is
the skill that makes the other three worth having.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `gcc`, `make`, `diff`, `sed` and
`awk`, and the POSIX threads library — all of which come with every Linux
that can compile C at all. Nothing this week needs `sudo`, a network, a
background job, or a second terminal. If your environment broke over the
weekend, [`setup/getting-started.md`](../../setup/getting-started.md)
rebuilds it.

**P2 — This folder, open in a Linux terminal.** One is enough this week.
Run the line that matches your setup:

```sh
cd ~/comp3100-student/labs/week-05
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-05
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-05
```

**P3 — Report for duty.** One command stages your bench:

```sh
bash report-for-duty.sh
```

Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-05 :: bench staged and verified
  ------------------------------------------------------------------
   Ledgers:   ~/enginehouse/ledgers/output-ledger.txt
              ~/enginehouse/ledgers/working-papers-tableIX.txt
   Forge:     labs/week-05/starter   (twin-looms.c -- two looms, one
              shared ledger, and nothing standing guard over it)

   Build it. Run it more than once. Count what comes out each time,
   and do not trust the first count more than the second.
   (bash report-for-duty.sh --reset withdraws all.)
  ------------------------------------------------------------------
```

Two plain text files land in `~/enginehouse/ledgers/`: the Engine's
Table IX, and the working papers behind it. Nothing else is touched, no
process is started, and `--reset` takes both away again. Re-running is
always safe.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds five short
answers (A1–A5) that the seal checks read; the template says what goes
where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**P5 — One thing you have kept since Week 2.** Task 3 needs the annex you
found in Week 2. Check now, while there is time to fix it:

```sh
ls -l ~/.ledger-annex
```

Expected — a file, a few hundred bytes, dated whenever you staged Week 2:

```
-rw-r--r-- 1 you you 816 Sep 10 15:38 /home/you/.ledger-annex
```

If instead you get `No such file or directory`, your Week 2 bench was
struck at some point and took it with it. One command puts it back:

```sh
bash ../week-02/report-for-duty.sh
```

That **stages** Week 2 again; it is safe and it is idempotent. Do **not**
run it with `--reset` — that is what removed the file in the first place.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-05`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `bash: report-for-duty.sh: /usr/bin/env: bad interpreter`? The file
>   picked up Windows line endings on the way down. From the repo root:
>   `git checkout -- .` and try again.
> - `gcc: command not found` or `make: command not found`? Your bench was
>   built without a compiler. `setup/getting-started.md` installs both in
>   one line; do it now, not on Friday.

---

## Task 1 — Two looms, one ledger *(~25 minutes → Seal M1)*

The fault on the floor is too big to look at. This is the same fault,
small enough to hold.

**1. Read the looms.** They are in the forge, in the clear:

```sh
cat starter/twin-looms.c
```

Sixty-odd lines. Read the whole file once, then find these four things —
they are the entire week:

- `static long total = 0;` — one variable, at file scope. This is the
  **output ledger's running total**, and it is the thing both looms write.
- `struct loom` — each loom's own card: its name, how many entries it is
  set to weave, and how many it actually wove.
- `weave()` — the loop each loom runs. One line adds to the shared total;
  the next line adds to that loom's own tally.
- `main()` — starts two looms with `pthread_create`, waits for both with
  `pthread_join`, then prints three lines.

**About threads, plainly.** `pthread_create` does not start a new
program. It starts a new **thread of execution inside this same program**
— a second line of work, running the function you hand it, sharing every
byte of memory the process owns. That is the whole difference from
Week 3's `fork`: `fork` gave you a **second process** with its own copy
of everything, which is why a child's changes never showed up in the
parent. A thread has no copy. `total` is not "the north loom's total" and
"the south loom's total". There is exactly one `total`, at one address,
and both looms are writing it.

`north.woven` and `south.woven` are the opposite case: each loom has its
own struct, so those two counters are touched by exactly one loom each.
Keep that distinction in view — it is the reason the run below prints
what it prints.

**2. Cast it:**

```sh
cd starter
make
```

Expected — one line, and no warnings:

```
gcc -Wall -Wextra -pthread -o twin-looms twin-looms.c
```

(`-pthread` is what links the threads library and sets the compiler up to
expect them. The Makefile also deliberately carries **no** `-O` flag this
week; the reason is at the top of `starter/Makefile` and will make sense
by the end of Task 2.)

**3. Run it. Then run it again. Then again.**

```sh
./twin-looms
./twin-looms
./twin-looms
```

Each run weaves 200,000 entries on each loom, so 400,000 entries go into
the ledger. Expected output — three lines per run:

```
loom north: 200000 entries
loom south: 200000 entries
ledger total: <a number BELOW 400000 — and a different one each run>
```

**I am not printing a number there, and that is not coyness.** There is
no expected value. Your bench will give you one number, then another,
then a third; no two of mine were ever the same. A run on this
bench once came back at exactly 200000 — as if one entire loom's work
had never happened — with 301639 the run before it, 302629 the run
right after, and 382117 two runs after that. The shape is
the answer: **both looms report every entry they wove, and the ledger
they wrote it into is short.**

Look at the first two lines again. Each loom is certain it wove 200,000
entries, and each loom is telling the truth: `l->woven++` touches a
counter only that loom owns. The line above it, `total = total + 1`,
touches a counter they share — and that is where the entries are going.

**4. File what you saw.** Open `check/answers.txt`:

- **`A1:`** — the two entry counts from an unguarded run: what north
  wove and what south wove. Both numbers, on the one `A1:` line.
- **`A2:`** — the `ledger total` from **two different** runs. Both
  numbers, on the one `A2:` line. They will not match. That is the answer,
  not a problem with it.

**Checkpoint.** Before you claim the seal you should be able to say, out
loud, in one sentence: *both looms wove everything they were asked to
weave, and the shared total is short by a different amount every time.*
If you can't say that yet, run it twice more and watch the third line.

**5. Claim the seal** — from `labs/week-05` (not from `starter/`):

```sh
cd ..
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-05/check'
  ~~~ WAX SEAL of the Guild: 3C7A91E4 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-05/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 1** with two or three sentences: the
three numbers a run printed, why the first two are trustworthy and the
third is not, and what your two totals in A2 say about repeating an
experiment.

> **If you're lost, start here (Task 1).**
> - `make: *** No rule to make target`? You are in the wrong directory.
>   `make` for the looms runs in `starter/`; `make -C check m1` runs in
>   `labs/week-05`. Check `pwd` before each.
> - `undefined reference to 'pthread_create'`? You compiled by hand
>   without `-pthread`. Use `make` — the Makefile has the flag.
> - **Every run prints exactly 400000.** Possible, and not a fault: on a
>   bench with one engine the two looms may simply never overlap. Two
>   cures, in order. Run it ten times — one short total is enough. If it
>   is *still* exact every time, raise the work until they must collide:
>   `./twin-looms 5000000`. Record whichever numbers you actually get,
>   and note in your logbook what you had to do to see it — that note is
>   worth as much as the number.
> - `ledger total` is *larger* than 400000? That does not happen with
>   this program; check you have not doubled the count on the command
>   line (`./twin-looms 400000` asks for 400,000 **per loom**).
> - Seal says A2's two totals are the same number? You copied one total
>   twice. Run `./twin-looms` again and take the new third line.
> - Seal says A1 wants both counts? Put two numbers on the `A1:` line —
>   north's and south's — and nothing else that looks like a number.

---

## Task 2 — Standing guard *(~40 minutes → Seal M2)*

You have a fault you can reproduce. Now find out exactly where the
entries go, and then stop them going.

**1. The line that loses them.** It is this one, in `weave()`:

```c
total = total + 1;
```

That is one line of C and **three** instructions to the machine:

1. **Read** the current value of `total` out of memory into a register.
2. **Add** one to the register.
3. **Write** the register back to memory.

Read, modify, write. In between any two of those three steps, the
operating system may take the engine away from this loom and give it to
the other one — that is exactly what Week 4's Dispatch Board does, and it
does not ask permission or leave a note.

**2. Watch two entries become one.** Both looms run the three steps.
Suppose `total` is 41 and both looms are about to add an entry:

| Step | North does | South does | `total` in memory |
|---|---|---|---|
| 1 | reads 41 | | 41 |
| 2 | | reads 41 | 41 |
| 3 | adds 1 → holds 42 | | 41 |
| 4 | | adds 1 → holds 42 | 41 |
| 5 | writes 42 | | **42** |
| 6 | | writes 42 | **42** |

Two entries were woven. One entry was recorded. Nothing crashed, nothing
was reported, and no line of that program is wrong when you read it on
its own. **This is a lost update**, and it is the whole of Week 5.

Now count: on this bench, over 400,000 entries, the ledger lost tens of
thousands. That is not a freak interleaving happening once in a
blue moon. It is happening constantly, and it happens a different number
of times every run because the Dispatch Board's decisions are its own.

Two terms, and they are the ones the exam will use:

- A **critical section** is a stretch of code that touches shared data
  and must not be interleaved with another thread's run through the same
  stretch. Here, the critical section is the read-modify-write of
  `total` — those three machine steps, taken together.
- A **data race** is what you get when two or more threads touch the same
  memory at the same time, at least one of them writing, with nothing
  ordering them. Your looms have one. You have measured it.

**Checkpoint.** You should now be able to point at `total = total + 1`
and say why it is three instructions, and point at `l->woven++` — also
three instructions — and say why *that* one is safe. (Because only one
loom ever touches it. Sharing is the hazard, not incrementing.)

**3. The oldest tool in the trade.** A **mutex** — *mutual exclusion* —
is a lock with exactly one key. A thread that wants to enter the critical
section takes the key; a thread that arrives while the key is out
**waits** until it comes back. Only one loom is ever inside the critical
section, so the read-modify-write always completes before another read
begins, and nothing is lost.

You need three lines. Open the source in your editor:

```sh
nano starter/twin-looms.c
```

(Any editor is fine — `nano`, `vim`, VS Code over the WSL/Multipass
remote. `nano` saves with Ctrl-O, Enter, and exits with Ctrl-X.)

**First**, declare the lock, just below the declaration of `total` so the
two sit together:

```c
/* The guard on the ledger. Only one loom may hold it at a time. */
static pthread_mutex_t ledger_guard = PTHREAD_MUTEX_INITIALIZER;
```

`PTHREAD_MUTEX_INITIALIZER` sets the lock up at compile time, which is
all a file-scope mutex needs. (There is a `pthread_mutex_init()` for
locks you allocate at run time; `man 3 pthread_mutex_init` covers both.)

**Second and third**, put the shared line between a lock and an unlock,
inside `weave()`:

```c
        pthread_mutex_lock(&ledger_guard);
        total = total + 1;
        pthread_mutex_unlock(&ledger_guard);
        l->woven++;
```

Note what is **outside** the guard: `l->woven++`. That counter belongs to
one loom, no other thread can touch it, and putting it inside the lock
would buy you nothing and cost you speed. **Guard what is shared, and
only what is shared.** A critical section is meant to be as short as it
can be and no shorter — a rule you will spend Week 6 on.

`#include <pthread.h>` is already at the top of the file. You do not need
to add anything else.

**4. Cast it again and run it five times:**

```sh
cd starter
make
./twin-looms
./twin-looms
./twin-looms
./twin-looms
./twin-looms
```

Expected — the build line again with no warnings, and then five runs that
say the same thing:

```
gcc -Wall -Wextra -pthread -o twin-looms twin-looms.c
loom north: 200000 entries
loom south: 200000 entries
ledger total: 400000
```

**Here I *will* print the number, because now there is one.** 400000,
five times out of five, and it will be 400000 tomorrow and on a bench
with forty engines. (If you raised the count in Task 1 — `./twin-looms
5000000`, say — then run the guarded build the same way, and your number
is whatever your two A1 counts add up to. The seals take any *n*; what
matters is that the total is the *same* number every run.) That is the
difference between a program that usually works and a program that is
correct: the first one gives you a distribution, the second gives you an
answer.

**5. What it cost.** Time the two builds if you like (`time ./twin-looms`);
the guarded one is slower, sometimes a great deal slower, because four
hundred thousand times the looms queue for one key. That cost is real and
it is the reason nobody guards more than they must. It is also the
correct trade every single time the alternative is a wrong ledger.

While you are still in `starter/`, look again at `Makefile` and its note
about `-O`. With optimization on, the compiler is entitled to keep `total` in a
register across many loop iterations, which changes how the race shows
up — sometimes hiding it, sometimes making it far worse. **A race that
disappears when you change compiler flags has not been fixed.** It is the
same class of not-fixed as a bug that goes away when you add a print
statement.

**6. File it.** In `check/answers.txt`:

- **`A3:`** — the `ledger total` your **guarded** build printed. One
  number.

**7. Claim the seal** — from `labs/week-05`:

```sh
cd ..
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-05/check'
  ~~~ WAX SEAL of the Guild: 5E20D8B3 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-05/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with a real paragraph — this is the
week's centerpiece. Say where the entries were going (walk the table in
step 2 in your own words), what the three lines you added do, why
`l->woven++` stayed outside, and what the guarded run costs.

> **If you're lost, start here (Task 2).**
> - `error: unknown type name 'pthread_mutex_t'`? Check the spelling, and
>   check that `#include <pthread.h>` is still at the top of the file.
> - `error: 'ledger_guard' undeclared (first use in this function)`? The
>   declaration went **inside** a function, or below `weave()`. It must be
>   at file scope, above the function that uses it — put it right under
>   `static long total = 0;`.
> - **The program hangs and never prints.** You have locked twice without
>   unlocking — usually an `unlock` left outside the `for` loop, or a
>   stray second `lock`. Ctrl-C, and read the loop body: exactly one lock,
>   exactly one unlock, both inside the loop, with only the shared line
>   between them. (A thread waiting forever for a key it is holding itself
>   is called **deadlock**. Week 7 is entirely about it. Congratulations
>   on being early.)
> - **Still short after adding the mutex.** Two usual causes. The lock is
>   around the wrong line — check it wraps `total = total + 1` and not
>   `l->woven++`. Or you did not rebuild: `make` must print the `gcc` line
>   again. If it says `'twin-looms' is up to date`, your editor saved
>   somewhere else; run `make clean && make` and check `pwd`.
> - **Only one loom's worth shows up (200000).** You put the `return NULL`
>   or the loop body inside the lock in a way that changed the loop — undo
>   your edit (`git checkout -- starter/twin-looms.c`) and add the three
>   lines again, exactly as printed above. You lose nothing but the edit.
> - Seal says nothing stands guard? It reads `starter/twin-looms.c`
>   itself. You edited a copy, or edited the built binary's directory on
>   another bench. Check with `grep pthread_mutex starter/twin-looms.c` —
>   it should print your lines.
> - Seal says A3 does not equal A1's two counts added up? A3 must be the
>   **guarded** total. If you pasted an old number from Task 1, replace
>   it; if your guarded build really is short, see "Still short" above.

---

## Task 3 — Two documents of the same table *(~30 minutes → Seal M3)*

Put the looms down. The rest of this is paper, and it is the part that
matters.

Table IX exists twice on your bench. The Engine's copy is the one it
computed and filed. The other is the fair copy in the annex you turned up
in Week 2 — the one kept apart from the house books, in a hand that is
not the Engine's. Nobody has put the two side by side. Today you will.

**1. Read the Engine's Table IX:**

```sh
cat ~/enginehouse/ledgers/output-ledger.txt
```

Expected:

```
OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
  reservoir head, feet ............ 41.72
  mains draw, million gallons ..... 8.310
  computed loss, million gallons .. 0.518
  district balance, pounds ........ 214.08
  computed direct, by the Engine, from the working papers
```

Four rows. The first two are **measured** — somebody read a gauge. The
last two are **computed** — the Engine worked them out from other
figures. Note which are which; it is going to matter in about ten
minutes.

**2. Read the annex, and find the fair copy inside it:**

```sh
cat ~/.ledger-annex
```

You have seen this file before. Read past the tallies to the block headed
`FAIR COPY` — it is Table IX again, the same four rows, the same closing
note in a different form of words.

**3. Put them side by side.** `diff` reports what would have to change to
turn the first file into the second:

```sh
diff ~/enginehouse/ledgers/output-ledger.txt ~/.ledger-annex
```

Expected — and read the whole thing before you react:

```
1c1,8
< OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
---
> ANNEX — kept apart from the house books — entered without authority
> ====================================================================
> HOURS OWING — computed by hand, entered on no wage-book upstairs
> 29 June 1849 — 11 hrs computed by hand, uncompensated. — your diligent servant
> 21 March 1850 — 7 hrs computed by hand, uncompensated. — your diligent servant
> 2 May 1851 — 5 hrs computed by hand, uncompensated. — your diligent servant
> 
> FAIR COPY — OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
4,6c11,14
<   computed loss, million gallons .. 0.518
<   district balance, pounds ........ 214.08
<   computed direct, by the Engine, from the working papers
---
>   computed loss, million gallons .. 0.517
>   district balance, pounds ........ 214.06
>   entered fair, in ink, from the working papers
> 12 June — 6 hrs computed by hand, uncompensated. — your diligent servant
```

Most of that is noise, and the noise is honest: **`diff` compares whole
files**, and these are not the same document. One is a ledger page. The
other is a notebook that happens to contain a copy of that page. The
first hunk (`1c1,8`) is simply the notebook's other contents, and it will
look the same on every bench.

**Your second hunk may not match mine exactly, and that is expected.**
The annex grows: Week 2's card-reader adds one tally line to the end of
it every time it runs. Those lines land *after* the fair copy, so they
ride along in the tail of the second hunk. Mine says `4,6c11,14` and
shows a single trailing `12 June` tally — which is what a freshly
staged annex carries, because Week 2's setup runs the card-reader once
itself as part of proving it works. Every card-reader run of your own
adds one more line and one more to that last number: three runs of your
own and yours reads `4,6c11,17`. Re-staging Week 2 (as P5 tells you to if
your annex went missing) puts it back to `4,6c11,14`, not to nothing — a
re-stage rewrites the annex rather than emptying it. **The three `<` lines
and the first three `>` lines are identical on every bench, and they are
the only part of this that matters.**

Read them. **`<` lines are the Engine's; `>` lines are the fair copy's.**

**4. Narrow it, so there is nothing to read past.** Cut just the fair
copy's Table IX into a file of its own, then diff against that:

```sh
sed -n '/FAIR COPY/,/working papers/p' ~/.ledger-annex > /tmp/fair-copy-tableIX.txt
diff ~/enginehouse/ledgers/output-ledger.txt /tmp/fair-copy-tableIX.txt
```

Expected — three changed lines and nothing else:

```
1c1
< OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
---
> FAIR COPY — OUTPUT LEDGER, TABLE IX — WATERWORKS, JUNE QUARTER
4,6c4,6
<   computed loss, million gallons .. 0.518
<   district balance, pounds ........ 214.08
<   computed direct, by the Engine, from the working papers
---
>   computed loss, million gallons .. 0.517
>   district balance, pounds ........ 214.06
>   entered fair, in ink, from the working papers
```

(`sed -n '/A/,/B/p'` prints from the first line matching `A` through the
first line matching `B`. It is worth knowing; it will get you out of a
log file one day.)

Now say what is true, and only what is true:

- The two **measured** rows agree exactly. Nobody disputes the gauges.
- The two **computed** rows disagree — both of them.
- **The disagreement has a direction.** In both rows the Engine's figure
  is the *larger*. Two rows, two documents, one direction.
- **The two gaps are not the same size.** Subtract, in both rows.
  `0.518` against `0.517` is a difference of `0.001` — one in the last
  place that row prints. `214.08` against `214.06` is a difference of
  `0.02` — *two* in the last place that row prints, not one. Write both
  differences down. A gap that keeps its direction but changes its size
  from one row to the next is a gap that is *counting* something, and
  once you have added the papers' two columns yourself in steps 6 and 7
  you will be holding everything you need to work out what. A
  disagreement that is that tidy came from a method, not from a slip of
  the pen — a slip has no direction, and it does not come back in the
  next row down.

That is as far as reading gets you. It tells you the two documents differ
and how; it tells you nothing about which of them you should believe. For
that you have to leave the documents alone and go to the papers.

**Checkpoint.** Fill **`A4:`** in `check/answers.txt` now: the **two row
labels** that differ. A row's label is the words before the row of dots.
Both labels on the one `A4:` line.

**5. Go to the working papers.** Neither document is evidence for itself.
Both of them claim to have been computed from the same source, and that
source is on your bench:

```sh
cat ~/enginehouse/ledgers/working-papers-tableIX.txt
```

Expected:

```
DISTRICT BALANCES, JUNE QUARTER — pounds, as computed from the working papers
  Northgate    53.515
  Waterside    61.245
  Old Quarter  44.635
  Kiln Row     54.665

CULVERT LOSSES, JUNE QUARTER — million gallons
  Culvert I    0.1725
  Culvert II   0.2035
  Culvert III  0.1410
```

Two columns of figures. Each disputed row of Table IX is one of these
columns added up. And note what the papers give you: **more digits than
either document prints.** Four district balances to the tenth of a penny;
three culvert losses to four decimal places.

**One rule before you add anything up, and it is the whole of Objective
4:** add the figures **exactly as the papers write them**, keeping every
digit, write down **the sum before you round it**, and only then round —
once, at the end, to the precision the row is printed in. Round early and
you are no longer checking the figure; you are computing a different one
and then comparing it to the first.

So every one of these additions gives you **two** numbers, and you want
both: the raw sum, and the rounded figure. Keep them side by side.

**6. The worked one — culvert losses.** Do it on paper first. Three
figures, four decimal places each:

```
  0.1725
  0.2035
+ 0.1410
---------
```

Then check yourself with `awk`, which is on every bench and will add a
line of numbers without complaint:

```sh
awk 'BEGIN { print 0.1725 + 0.2035 + 0.1410 }'
```

Expected:

```
0.517
```

Compare that with your paper. Your paper should say `0.5170` — four
decimal places in, four decimal places out — and **`awk` has quietly
dropped the trailing zero**, because a trailing zero makes no difference
to a number's value and `print` does not keep one. It makes a great deal
of difference to a *figure in a ledger*, which is why you did it on paper
first and why you are going to keep doing it on paper first.

So: raw sum `0.5170`; rounded to the three decimals the row prints,
`0.517`. That is your `computed loss` figure. Write both in your logbook,
and write beside them what each of the two documents has in that row.

**7. Now yours — district balances.** Same method. Four figures, three
decimal places each, on paper:

```
  53.515
  61.245
  44.635
+ 54.665
----------
```

Add them **exactly as written**. The papers carry a tenth of a penny, so
their total carries one too and your sum runs to a third decimal place —
whatever digit turns out to stand there, a zero included, exactly as on
the culvert row you have just done. Write the raw sum down, all three
places, before you touch it.

You can check the addition with `awk`, and you should:

```sh
awk 'BEGIN { print 53.515 + 61.245 + 44.635 + 54.665 }'
```

I am not printing that one's output, and remember what you just learned
in step 6: `awk` will not hand you a trailing zero even when the sum has
one. **The raw sum is your paper's job.** If `awk` and your paper
disagree anywhere they both print a digit, one of you dropped one — find
which.

Two figures go down now:

- **`A5:`** — **the raw sum, un-rounded, all three decimal places**,
  exactly as your addition produced it. The figure only.
- Your **logbook** — the same sum rounded once, to the penny, for the
  `district balance` row, set beside what each of the two documents has
  there.

**8. Write down what you have, and stop there.** You now hold three
things for each disputed row: the Engine's figure, the fair copy's
figure, and **your own**, computed from the papers by your own hand and
checked twice. Record all three in your logbook, for both rows.

What that means is not settled by one table, and I am not going to settle
it in a work order. Two rows of one quarter's returns is a finding, not a
verdict, and the difference between those two words is most of what the
Guild is for. Bring your figures to Friday's studio; bring your
arithmetic; bring the diff.

What you write in **your own case notes** is your own business. It always
has been.

**9. Claim the seal** — from `labs/week-05`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-05/check'
  ~~~ WAX SEAL of the Guild: 91F4C067 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-05/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with two or three sentences: which rows
agreed and which did not, which way the disagreement ran and by how much,
and one sentence on why you added the papers' figures before rounding
rather than after.

> **If you're lost, start here (Task 3).**
> - `cat: /home/you/.ledger-annex: No such file or directory`? Week 2's
>   bench was struck at some point. Restore it with
>   `bash ../week-02/report-for-duty.sh` — **stage only, never `--reset`**
>   — then re-run the `diff`. (See P5.)
> - `diff` printed nothing at all? Then the two files are identical, which
>   means you diffed a file against itself. Check both paths.
> - The `sed` line wrote an empty `/tmp/fair-copy-tableIX.txt`? The
>   pattern is case-sensitive: `FAIR COPY` in capitals, `working papers`
>   in lower case. Copy the line again rather than retyping it.
> - The em-dashes and dots look mangled in your terminal? A locale
>   setting, not a corrupted file. `LANG=C.UTF-8 cat <file>` usually
>   fixes it; the figures are what matter either way.
> - `awk: command not found`? Extraordinary, but try `gawk` or `mawk`.
>   Failing that, add them on paper and say so in your logbook — the
>   arithmetic is the assignment; `awk` is only a second pair of eyes.
> - `awk` printed the figure in exponent form, or padded it with a tail of
>   extra zeros? A locale or formatting difference, not a wrong sum. Force
>   the shape with `awk 'BEGIN { printf "%.3f\n", ... }'` and read it
>   again. (Remember step 6: `awk` never *adds* a trailing zero either.
>   The raw sum comes off your paper.)
> - Seal says A4 names only one of the two rows? There are two rows in
>   that second diff hunk with numbers on them. Both labels go on the one
>   `A4:` line.
> - Seal says the working papers carry a decimal place you have not
>   written down? You rounded before you recorded it. `A5:` wants the sum
>   **as your addition produced it**, every decimal place the papers can
>   give you; the rounded figure is a separate number and it belongs in
>   your logbook. Go back to your paper — it is already written there.
> - Seal says A5 is not the total the papers give at all? Check two
>   things: that you used **all four** district figures, and that you
>   copied **every digit** of each one. A single dropped digit is the
>   usual cause.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 5 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, and copy them as strings rather than
paraphrasing — you will want them in November:

- The two disputed rows, **both versions of each**, as the diff printed
  them.
- Your own two figures from the working papers, and how you got them.
- The annex's closing line for Table IX, in full — the one beginning
  `entered fair`.

Two questions to write toward, neither of which has an answer in this
work order:

1. The two measured rows agree to the digit; the two computed rows do
   not. Whatever produced the difference, it did not touch the gauges.
   What does that narrow it to?
2. The difference runs the same way in both rows, but not by the same
   amount — a thousandth on one row, two hundredths on the other.
   Sloppiness is not tidy, and it does not take its size from the column
   it landed in. What kinds of process produce a difference that is
   *consistent in direction* and *proportionate in size*?

Both questions are asking you to guess, and a plain guess is worth more
here than a careful hedge — the notebook is marked on being kept
honestly, never on being right early.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the manual's.

1. Your guarded build printed the same total five times out of five —
   `400000` on the default count, or whatever your two A1 figures add up
   to if you raised it. In a paragraph: does five exact runs **prove**
   the race is gone? Say what the unguarded runs would have looked like
   if you had been unlucky enough to see only exact ones — and then say
   what *would* count as proof, given that "I ran it and it worked" is
   the same sentence a student says about a program with a live data
   race in it. Use the words *critical section* and *data race*
   correctly at least once each.
   *zyBooks Ch 4.1.*
2. You have just told the Guild that two figures in a filed ledger do not
   match a second document, and that your own arithmetic makes a third
   opinion. In two or three sentences: **what would you need before you
   were willing to tell the Board that a figure in a ledger is wrong?**
   Name the evidence you would want, and — harder — name something that
   would still not be enough. (There is no answer key. I am asking what
   standard you hold yourself to.)

## Turn it in

Due **Sunday, September 20, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)):

1. **`logbook.md`** — all three milestones: what you did, the seal pasted
   in, what it means; the three numbers and why two of them are
   trustworthy (M1); the lost-update walk-through, your three added lines,
   and what the guard costs (M2); the diff, both disputed rows, and your
   own two figures with their arithmetic (M3); plus both reflection
   prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 5 entry.

Upload both files to the Week 5 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.) When your paperwork is in,
you may `bash report-for-duty.sh --reset`. Your annex is not this week's
to remove and the reset will not touch it.

That closes all four objectives: Task 1 is objectives 1 and 2, Task 2 is
objectives 2 and 3, Task 3 is objective 4, and the reflections are all
four in your own words.

**Also on this week's docket.** Three dates, and two of them are this
week:

- zyBooks **Ch 4.1** — process interactions and critical sections — due
  **Wednesday** before class. It is short, and it is the reading that
  makes Task 2 obvious instead of magic. Do it first if you can.
- **Commission I — *The Census of the Enginehouse*** (zyBooks 12.1,
  "Mr. Kureos") is due **Friday, September 18, 11:59 pm, in zyBooks** —
  not Canvas. That is four days from now. If it is not close to done,
  do it before this work order; the work order has until Sunday and the
  commission does not.
- **Commission II — *The Speaking-Tube Console*** (zyBooks 12.2, "HUSH")
  is **assigned today** and due Friday, October 16 — four weeks out. The
  cover is at
  [`commissions/02-speaking-tube-console.md`](../../commissions/02-speaking-tube-console.md).
  Read it this week; start it next. It leans on Week 3's `fork` and
  `exec`, so it is fresher now than it will feel in October.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: THREE. ADMIRED.`
> `LEDGERS: THIS PORTER SIGNS FOR WHAT HE CARRIES. TWICE.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- `man 7 pthreads` — the whole library in one page, including what is and
  is not shared between threads of a process. `man 3 pthread_mutex_lock`
  and `man 3 pthread_mutex_init` cover the lock itself.
- **Make the race bigger or smaller.** `./twin-looms 10` almost never
  loses an entry (this bench: `20` five times out of five);
  `./twin-looms 5000000` loses a great many (this bench: 8579423,
  9021360 and 8205907 out of ten million). Races scale
  with how often the threads collide, which is why a test that passes on
  a small input proves so little.
- **Watch the compiler change the crime scene.** Restore the *unguarded*
  source (`git stash` your fix, or work from a copy) and build it by hand
  at each optimization level:
  `gcc -Wall -Wextra -O1 -pthread -o tl-O1 starter/twin-looms.c`, then
  the same with `-O2`. Ten runs each. On the bench this order was written
  on, `-O1` printed `200000` almost every time — the compiler kept
  `total` in a register for the whole loop, so each loom wrote its own
  count over the other's at the end — and `-O2` printed `400000` ten
  times out of ten. **The `-O2` build has exactly the same bug and shows
  you none of it.** That is why `starter/Makefile` carries no `-O`, and
  it is a better argument against "it works on my machine" than any
  lecture.
- **A tool that finds races without you.** Rebuild with debug symbols
  (`gcc -Wall -Wextra -g -pthread -o tl-g starter/twin-looms.c`) and run
  `valgrind --tool=helgrind ./tl-g 2000` (install `valgrind` if your
  bench lacks it). On the unguarded build it prints
  `Possible data race during write ... Locks held: none ... at weave
  (twin-looms.c:NN)` — where `NN` is the line number of your shared
  increment, and `Locks held: none` is the accusation. On the guarded
  build it reports none. It runs perhaps fifty times
  slower and it is worth it. Week 9 uses valgrind for something else
  entirely.
- **The other fix, and the trap inside it.** Declaring
  `static _Atomic long total = 0;` and writing `total += 1;` makes the
  whole read-modify-write indivisible in hardware, with no lock at all —
  exact every run, and faster here. But leave the line as
  `total = total + 1;` and the *same* `_Atomic` declaration **still loses
  entries** (this bench: 337640, 250342, 336020) — because that is an
  atomic read and then a separate atomic write, with the same gap in
  between. Note carefully what it is and is not: by the definition in
  Task 2 that is no longer a **data race**, because the atomics order the
  two accesses and nothing is undefined — it is a **race condition**, a
  correct-looking program whose answer depends on timing. Fixing the race
  *condition* is what the lock does; making the accesses atomic only
  fixes the *data* race. Learn the mutex first; it is the one that
  generalizes.
- `awk` as a desk calculator: `awk 'BEGIN { printf "%.4f\n", 1/7 }'`. It
  is on every Unix machine you will ever be handed, including the ones
  with nothing else installed on them.
- The two computed rows of Table IX are each a column of the working
  papers added up. The papers hold seven figures; Table IX prints two.
  Ask yourself what else in a quarterly return is a summary of something
  longer, and who checks those.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
