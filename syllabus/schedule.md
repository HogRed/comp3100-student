# COMP 3100 — Semester Schedule

**Operating Systems · Fall 2026 · Harding University**
*"The Case Files of the Grand Analytical Engine"*

This page is the **authoritative list of dates** for the course. Decks,
work orders, and commission cover pages all point back here; if a date
anywhere else disagrees with this page, this page wins. Anything that
changes will be changed here first and announced in class and on Canvas.

---

## How a normal week runs

| When | What |
|---|---|
| **Before Wednesday's class** | That week's **zyBooks reading** (participation + challenge activities) is due. |
| **Monday** | Episode deck: the week's story beat, then the concept lecture, then the briefing for the week's work order. |
| **Wednesday & Friday** | Studio. You work the work order at your own machine; the instructor circulates. |
| **Friday, 11:59 pm** | **Work order deliverables due on Canvas:** your `logbook.md` for the week (wax seals pasted in) plus your updated running `case-notes.md`. |

Commissions (the five department projects) are **submitted in zyBooks**,
not Canvas, and are due at **11:59 pm** on the date listed below.

## Three calendar facts worth circling now

1. **Labor Day, Monday, September 7 — class *is* held.** We meet that
   Monday; the Enginehouse takes no holiday. Episode 4 runs as normal.
2. **Fall break, Friday, October 2 — no class.** Week 7 has only two
   sessions (Mon Sep 28 and Wed Sep 30), and its work order is sized for
   two sessions. **Nothing is due over the break: Week 7's deliverables
   move to Monday, October 5, at 11:59 pm.** This is the only week all
   semester that does not turn in on a Friday. Week 8 begins that same
   Monday as normal.
3. **Thanksgiving, Monday–Friday, November 23–27 — no class all week.**
   Nothing is due that week. The Engine rests; so do you.

Finals week is **December 7–11**. Guild Examination II meets in the
registrar's assigned slot, announced in class and posted in Canvas.
**Nothing else is due that week** — no work order, no commission, no
reading. The last deadline of the semester is Friday, December 4.

---

## The semester, week by week

| Wk | Dates (Mon–Fri) | Episode | Topic | zyBooks (due Wed) | Deliverables due 11:59 pm (Friday unless noted) | Commissions |
|---|---|---|---|---|---|---|
| 1 | Aug 17 – 21 | **Induction Day** | What an operating system is; your Linux environment; the shell; manual pages | Ch 1 | Work Order 01 | — |
| 2 | Aug 24 – 28 | **The Engine's Native Tongue** | System calls; a C on-ramp; tracing a program with `strace` | Ch 1 (finish) · Ch 2 (begin) | Work Order 02 | **Kureos assigned** (zyBooks 12.1) |
| 3 | Aug 31 – Sep 4 | **The Pantograph Desks** | Processes: `fork`/`exec`/`wait`, `/proc`, `pstree`, zombies | Ch 2 (finish) | Work Order 03 | — |
| 4 | Sep 7 – 11 | **The Dispatch Board** | CPU scheduling: priorities, `nice`, `chrt`/`SCHED_FIFO`, cgroup limits *(class held Labor Day, Mon Sep 7)* | Ch 3 | Work Order 04 | — |
| 5 | Sep 14 – 18 | **The Twin Looms** | Threads and data races with pthreads | Ch 4.1 (process interactions, critical sections) | Work Order 05 | **Kureos due** (Fri Sep 18) · **HUSH assigned** (12.2) |
| 6 | Sep 21 – 25 | **The Interlocking & the Semaphore Towers** | Synchronization: mutexes, semaphores, condition variables | Ch 4.2 – 4.5 (semaphores, monitors, classic problems) | Work Order 06 | — |
| 7 | Sep 28 – Oct 2 | **The Great Standstill** | Deadlock: the four conditions; diagnosing a hung system with `gdb` *(no class Fri Oct 2 — fall break)* | Ch 5 | Work Order 07 — **due Mon Oct 5** (fall break — deliverables for this week are due Monday instead) | — |
| 8 | Oct 5 – 9 | **Guild Examination I** | Mon: review · **Wed Oct 7: Exam I (Ch 1–5)** · Fri: open HUSH workshop | — | *(no work order this week)* | HUSH workshop, Fri Oct 9 |
| 9 | Oct 12 – 16 | **The Store** | Memory management: `malloc`, process memory layout, `valgrind` | Ch 6 | Work Order 09 | **HUSH due** (Fri Oct 16) · **Regular Expressions assigned** (12.3) |
| 10 | Oct 19 – 23 | **The Phantom Store** | Virtual memory: paging, `/proc/<pid>/maps`, `mmap`, page faults | Ch 7 | Work Order 10 | — |
| 11 | Oct 26 – 30 | **The Ledger Halls** | File systems: inodes, links, mounts, loop-mounting a disk image, recovering deleted files | Ch 8 | Work Order 11 | **Regular Expressions due** (Fri Oct 30) · **Versioning assigned** (12.5) |
| 12 | Nov 2 – 6 | **The Pneumatic Post** | Applied I/O: pipes, redirection, `/dev`, FIFOs | — *(Ch 9 optional)* | Work Order 12 | — |
| 13 | Nov 9 – 13 | **The Brass Keys** | Applied security: users and groups, permissions, `setuid`, `sudo`, authentication logs | — *(Ch 10 optional)* | Work Order 13 | **A Good Sport assigned** (12.4) |
| 14 | Nov 16 – 20 | **The Aetheric Exchange** | Ports and sockets: auditing every listening service with `ss`/`netstat` | — *(Ch 11 optional)* | Work Order 14 | **Versioning due** (Fri Nov 20) |
| — | Nov 23 – 27 | *Thanksgiving break — the Engine rests* | No class, nothing due | — | — | — |
| 15 | Nov 30 – Dec 4 | **The Reveal & the Exhibition** | Mon: the reveal · Wed: the finale · Fri: epilogue and the Exhibition (last class) | — | Work Order 15 · **sealed verdict due Mon Nov 30, start of class** | **A Good Sport due** (Fri Dec 4) |
| Finals | Dec 7 – 11 | **Guild Examination II** | Final exam: Ch 6–8 plus the applied weeks (12–14), lightly | — | *(nothing due — the exam only)* | — |

**Reading the table.** "Work Order *NN*" means the week's lab: submit
`logbook.md` and your updated `case-notes.md` on Canvas by 11:59 pm
Friday — except in Week 7, where fall break pushes the deadline to
Monday, October 5. A work order's number is its week's number, so there
are **fourteen graded work orders** — one every week except exam week,
and no Work Order 08. None are dropped. The exact zyBooks activity list
for each week is posted in Canvas alongside the chapter range above.

**Class meetings.** The course meets **44 times**: three days a week
across the fifteen teaching weeks, less Friday, October 2 for fall
break. That number is what the professionalism component in
[`syllabus.md`](syllabus.md) is scored against.

---

## The five Guild Commissions at a glance

These are the department's own projects, unmodified. Dr. Foust's spec is
authoritative for each one; the course adds only a cover page and the
calendar placement below. **All five are submitted in zyBooks.**

| # | zyBooks | Project | In-fiction name | Assigned | Due (11:59 pm) |
|---|---|---|---|---|---|
| 1 | 12.1 | Mr. Kureos | *The Census of the Enginehouse* | Mon Aug 24 (Wk 2) | **Fri Sep 18** (Wk 5) |
| 2 | 12.2 | HUSH | *The Speaking-Tube Console* | Mon Sep 14 (Wk 5) | **Fri Oct 16** (Wk 9) |
| 3 | 12.3 | Regular Expressions | *The Pattern Loom* | Mon Oct 12 (Wk 9) | **Fri Oct 30** (Wk 11) |
| 4 | 12.5 | Simple Versioning System | *The Revision Registry* | Mon Oct 26 (Wk 11) | **Fri Nov 20** (Wk 14) |
| 5 | 12.4 | A Good Sport | *The Exchange Audit* | Mon Nov 9 (Wk 13) | **Fri Dec 4** (Wk 15) |

An **open HUSH workshop** runs Friday, Oct 9 — bring your half-finished
shell and questions. The last two commissions run long on purpose: they
run through the applied weeks (12–15), which carry no required reading,
so the load moves from the reading to the projects. Each gets about
twenty-five days, and they land a fortnight apart — **neither one falls
in finals week**, where nothing is due but Exam II.

## Exams

| Exam | When | Covers | Weight |
|---|---|---|---|
| **Guild Examination I** | Wednesday, October 7 (Wk 8), in class | zyBooks Ch 1–5 and the work orders through Week 7 | 15% |
| **Guild Examination II** | Finals week, Dec 7–11 · slot set by the registrar, announced in class | zyBooks Ch 6–8, plus lighter coverage of the applied weeks (12–14) | 15% |

Both exams are written in the Guild's voice; the questions are ordinary
operating-systems questions. Nothing on either exam requires you to have
followed the story.

## Dates at a glance

- **First class:** Monday, August 17
- **Labor Day (class held):** Monday, September 7
- **Fall break (no class):** Friday, October 2 — Week 7's deliverables are
  due **Monday, October 5**, the semester's only non-Friday deadline
- **Exam I:** Wednesday, October 7
- **Thanksgiving break (no class):** November 23–27
- **Sealed verdict due:** Monday, November 30, start of class
- **Last class:** Friday, December 4 — also the semester's last deadline
  (Work Order 15 and Commission 5)
- **Finals week:** December 7–11 · Exam II slot set by the registrar,
  announced in class and posted in Canvas · **nothing else due**

For grading weights, the late policy, and everything else about how the
course is run, see [`syllabus.md`](syllabus.md).
