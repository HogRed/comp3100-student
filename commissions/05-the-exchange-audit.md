# COMMISSION No. IV of 1851 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Commission** | ***The Exchange Audit*** — the last of four |
| **Filed in the department's book as** | **zyBooks 12.4, "A Good Sport"** |
| **Assigned** | Monday, 9 November 1851 *(Week 13)* — four weeks to the Exhibition |
| **Due** | **Friday, December 4, 11:59 pm** *(Week 15)* — **submitted in zyBooks**, not Canvas |
| **Worth** | 5% of the semester |

---

## The commission

The Exhibition is four weeks off, and the Board has asked a plain
question that nobody in the Enginehouse can answer: *what, exactly, is
the telegraph exchange listening to?*

An exchange is a switchboard of lines. Some are open to the sister
cities and to anyone who rings. Some are for the house alone, and are
meant never to leave it. Some were opened by an apprentice at a bench
for an afternoon and forgotten. And some are not listening at all, but
are merely in the middle of a conversation. All of them appear in the
exchange's own register of lines, a long dull table that no one reads
because it is long and dull.

I have read it. It is not much better the second time.

What the Board wants is not the table but its **summary**: how many
lines are open to the outside, and which; how many are kept for the
house, and which; how many belong to apprentices' own instruments, and
how many of those are *yours*; and how many conversations are under
way. One page, in a fixed form, that a Board member can read on the
way to dinner.

Your commission is to build the auditor that writes that page. It
asks the exchange for its register, sorts every line into its drawer,
and reports. It does not judge what it finds. It counts, and it names
the ports, and it leaves the judging to people.

Build it. Then run it against the exchange and see what you are told.

— *B.M.*

---

## Requirements

> ### THE LINKED SPEC IS AUTHORITATIVE.
>
> **<https://cs.harding.edu/gfoust/classes/comp3100/projects/sport>**
>
> This cover page adds a name, a date, and a story. It adds **no
> requirements**. Everything you are graded on lives at that link and in
> **zyBooks 12.4**, where you submit. Where this page and the spec
> disagree, **the spec wins** — read it, then read it again before you
> submit.

**Dr. Foust's specification, restated in one paragraph.** Write a
**Python** program, **`sport.py`** (a playful abbreviation of
"scanport"), that runs **`netstat -anpt`** with **`subprocess.run`** —
capturing its output as text; the order of the flags does not matter —
and prints a summary of the **TCP** listening services, applications,
and connections it reports. Each line of the register is handled **on
its own**, and a line that is not a well-formed TCP line, or whose
address is malformed, is **ignored**; the spec gives the exact tests,
so take them from there. Do not assume any ordering of header or data
lines. A line in the **LISTEN** state with a port of **32768 or
higher** is a **user application**; a LISTEN line with any other port
is an **internal service** if its host is `127.0.0.1` or `::1`, and an
**external service** otherwise, and the port number is recorded. A
line in **any other state** is an **ongoing connection**. Some of
these are **yours**: `netstat` shows the PID and program name only for
your own processes unless you are root, and the spec says how that
counts. A port that appears more than once — on both IPv4 and IPv6,
say — is **counted and listed once** per category. The output has
**four categories, each with a count**: external services and internal
services (each with its ports listed beneath), user programs listening
(with how many are yours in parentheses), and ongoing connections
(with how many are yours in parentheses). It must match the **example
in the spec exactly**.

### One detail worth pausing on: count a port once

An exchange that speaks both the old and the new numbering will list
the same line twice, once for each:

```
tcp    0   0 0.0.0.0:22   0.0.0.0:*   LISTEN   -
tcp6   0   0 :::22        :::*        LISTEN   -
```

Two rows, one port. The spec asks for it to be counted and listed
**once**, and the tool for that is the one the spec hints at: a
`set`, which cannot hold the same member twice, and `sorted`, which
puts the members in order when you print them.

```
>>> ports = set()
>>> ports.add(22)
>>> ports.add(22)
>>> sorted(ports)
[22]
```

The other half of the same care is the filter itself: a header line
or a blank line is not a line of the register, and it must neither
crash the auditor nor be counted.

---

## Practical notes

**Test on pasted text first.** The spec's own hint is the kindest one
in the project: read the register from `sys.stdin.read()` while you
are building, so that you can paste in a few lines (good ones, and
deliberately bad ones) and see what the auditor makes of them. Switch
to the real `subprocess.run` call once the sorting is right. Lines are
separated by `\n` only.

**Read the register yourself first.** Run `netstat -anpt` at the
prompt and look at what it prints before you write a line of Python. See
which column holds the state, which holds the address, and what
the last column looks like for a line that is not yours (the PID and
program appear only for your own processes unless you are root). Your
program will be reading exactly what you are reading.

**One line, one decision.** Handle each line separately and keep
no assumption about what came before. A function that takes a single
line and returns what drawer it belongs in is easy to test, and you
will thank yourself for it.

**Split an address at the last colon.** *This is our suggestion, not
the spec's.* `127.0.0.1:631` and `:::22` both end in a port, but the
second begins with colons of its own. `rsplit` takes the end of the
string, and `isdigit` will tell you whether what you found is a port.
The spec decides what counts as well formed.

**Regular expressions are optional.** The spec says so. If you do
reach for one, the Pattern Loom's tools apply; if you do not, `split`
will do the whole job.

**Run it as a program, if you like.** As with the Census, it is a
good habit to give the script a sh-bang line and `chmod +x`, so that it
runs as `./sport.py`. The spec does not ask for it.

---

## Before you submit

- [ ] It is a **Python** program, **`sport.py`**, that runs
      **`netstat -anpt`** with **`subprocess.run`**, capturing its
      output as text.
- [ ] A line that is not a well-formed TCP line, or has a malformed
      address, is **ignored**, by the spec's own tests.
- [ ] No ordering of header or data lines is assumed; each line is
      handled **independently**.
- [ ] LISTEN on a port of **32768 or higher** is a **user application**;
      other LISTEN lines are **internal** (`127.0.0.1` or `::1`) or
      **external** services, with the port recorded.
- [ ] Any other state is an **ongoing connection**.
- [ ] The **"yours"** counts in parentheses follow the spec.
- [ ] A port seen more than once is **counted and listed once** per
      category, and the ports are printed in order.
- [ ] The output has the **four categories and counts**, and matches
      the spec's example **exactly**.
- [ ] You have **re-read the linked spec** after finishing, not before.
- [ ] It is submitted in **zyBooks 12.4** by **Friday, December 4,
      11:59 pm**. Not Canvas. zyBooks.

> `COMMISSION: ISSUED.`
> `LINES OPEN: TO BE COUNTED. LINES COUNTED: TO BE COUNTED ONCE.`
> `SUBMISSION CHANNEL: ZYBOOKS. CANVAS: NOT THE CHANNEL. ASKED AND ANSWERED.`
> `LATE PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
