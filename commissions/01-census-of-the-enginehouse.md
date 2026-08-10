# COMMISSION No. I of 1851 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Commission** | ***The Census of the Enginehouse*** — the first of five |
| **Filed in the department's book as** | **zyBooks 12.1, "Mr. Kureos"** |
| **Assigned** | Monday, 24 August 1851 *(Week 2)* — fifteen weeks to the Exhibition |
| **Due** | **Friday, September 18, 11:59 pm** *(Week 5)* — **submitted in zyBooks**, not Canvas |
| **Worth** | 4% of the semester |

---

## The commission

The reading room gave up a small treasure last week.

Sorting the Computing Room's surviving papers for the Exhibition
archive, a porter turned up a bundle in a familiar hand: **Mr. I. M.
Kureos**, Chief Computer of this Guild for nineteen years, now retired
and — as half of you have already discovered on visiting days — the
patient old gentleman who will sit with you over a column of figures
until it balances.

Among his papers was a **census routine**. Not a grand thing. A short
procedure for reading the house roll and reporting who was on it, by
first name, with a count beside each. He appears to have run it often.
The margin note that came with it is pure Kureos: *"A house should
know who is in it."* He kept count of everyone, as was his habit.

The roll he counted is gone; the Computing Room was disbanded two
years ago. But the Enginehouse has a roll of its own — every bench,
every porter, every account the Overseer recognises — and nobody has
counted it since the Engine took over the civic ledgers. The Board
would like a number before the Exhibition. I would like it done
properly.

So: **rebuild the Old Master's census routine for the modern rolls.**
His method, your hand. When it works, take it round to the reading
room on a Wednesday and show him. He will ask you how you tested it.
Have an answer ready.

— *B.M.*

---

## Requirements

> ### THE LINKED SPEC IS AUTHORITATIVE.
>
> **<https://cs.harding.edu/gfoust/classes/comp3100/projects/kureos>**
>
> This cover page adds a name, a date, and a story. It adds **no
> requirements**. Everything you are graded on lives at that link and in
> **zyBooks 12.1**, where you submit. Where this page and the spec
> disagree, **the spec wins** — read it, then read it again before you
> submit.

**Dr. Foust's specification, restated in one paragraph.** Write a
**Python script** that reports the first names of all users given the
contents of a `passwd` file. Give it a **sh-bang line** so it can be run
directly as a program, assuming the Python interpreter sits where the
spec says it sits on Taz. Your program must **not read any files** —
it reads its data from **standard input** (`stdin`), and it must read
*all* of standard input. The input is in `/etc/passwd` format: one line
per user, **seven fields separated by colons** — username, the password
placeholder (`x`), user id, group id, real name, home directory, and
shell. You may assume every line is well-formed: never blank, always
containing six colons. **Skip any account whose user id is less than
1000** (those are system accounts). **Skip any account whose "real
name" field is blank**, since some accounts have no name attached.
Count **first names only** — the first name is the first "word" of the
real-name field, i.e. the first sequence of non-whitespace characters
(the spec's own hint: split on whitespace). Report each distinct first
name with the number of times it occurred, one per line, in the form
`Name: count`, matching the worked example at the end of the spec.

### One detail worth pausing on: the order

The spec gives **no sentence** telling you how to order the output. It
gives something better — a worked example. Feed it the sample roll and
it prints:

```
Dana: 1
Frank: 2
Gabriel: 1
Hailey: 1
Joe: 2
Alice: 1
Susan: 1
```

Look at that carefully. **Alice comes after Joe.** That is not
alphabetical order — it is the order in which each name *first appeared
in the input*, because `Alice Tucker`'s line sits below `Joe Blow`'s in
the sample. A plain Python dictionary preserves insertion order and
gives you this for free; reaching for `sorted()` would give you
something the spec's example does not show.

So: **match the spec's example.** Do not sort unless the spec or
zyBooks tells you to sort. *(The example above is transcribed from the
spec as of this printing. If the linked page has changed, believe the
linked page, not this cover.)*

---

## Practical notes

**Running it.** Two ways, and both are worth knowing:

```sh
# 1. Hand the file to Python, and let Python hand it to your script:
python3 census.py < /etc/passwd

# 2. Or use the sh-bang line the spec asks for, and run it as a program:
chmod +x census.py
./census.py < /etc/passwd
```

The `<` is the whole trick: it points your script's standard input at a
file instead of at your keyboard. Your program never knows the
difference, which is exactly why the spec forbids opening files
yourself.

**Running it with no redirect** — just `./census.py` — leaves it
waiting on your keyboard. That is not a hang. Type or paste a few
`passwd` lines, then press **Ctrl-D** on a line of its own to signal
end-of-file, and the counts appear. Useful for testing one awkward line
without editing a file.

**Name the file whatever you like.** This cover says `census.py`
because of the story; the spec's example calls it `getnames.py`.
zyBooks will tell you what it wants. The name is not the assignment.

**zyBooks grades your standard output exactly.** Character for
character — capitalisation, the colon, the single space after it, the
line breaks, and no decorative extras. A program that computes every
count correctly and prints `Dana = 1` scores nothing. Print `Dana: 1`.
Resist the urge to add a friendly header.

**Your `/etc/passwd` will not match the zyBooks test data, and that is
expected.** The zyBooks tests feed your program their own roll on
stdin. Your VM's roll is your VM's. Agreement between them would be a
coincidence, not a passing grade — the point is that the *same program*
handles both, because it reads whatever it is given.

---

## Try it on your own bench *(worth no points, entirely the point)*

Python 3 is already on your VM, and so is a real roll. When your script
works, run it on the genuine article:

```sh
./census.py < /etc/passwd
```

You are on it — but *how* the roll names you depends on which door you
came in by. Look at your own line first:

```sh
grep "^$(whoami):" /etc/passwd
```

Field five is the real name. On the **WSL2** path the course's config
file sets it to `COMP-3100 Apprentice Enginewright`, so the census
reports `COMP-3100: 1`. On **Multipass** you are the stock `ubuntu`
account and it reports `Ubuntu: 1`. On **native Linux** it reports
whatever real name your own account carries. And on the **Codespaces**
path nothing sets that field at all — if it is empty, rule two skips
you and you appear nowhere. That is not a bug in your program; it is
your program obeying the blank-name rule.

Predict your output from the line you just printed, then run the census
and check. Whatever it says, the Guild has counted you. Welcome to the
roll.

A few things worth noticing while you are there:

- **`root`, `daemon`, `bin`, `sys`** and the rest of that crowd do not
  appear. User id under 1000 — the spec's first filter, doing its job
  on real data.
- **You may see an entry you did not expect.** `nobody` carries user id
  **65534**, which is comfortably *greater* than 1000, so the rule keeps
  it. That is the rule working correctly, not a bug in your program.
  Read the line with `grep nobody /etc/passwd` and satisfy yourself.
- **Read the whole file** — `cat /etc/passwd` — and count by eye what
  your program counted by machine. They should agree. If they do not,
  one of you is wrong, and finding out which is the entire skill this
  house is trying to teach you.

Then do the thing Mr. Kureos would actually ask for: run it twice, and
check the second time in ink.

---

## Before you submit

- [ ] It is a **Python** script with a **sh-bang** line.
- [ ] It **opens no files** — everything arrives on `stdin`.
- [ ] It reads **all** of standard input, to end-of-file.
- [ ] Accounts with **user id < 1000** are skipped.
- [ ] Accounts with a **blank real-name field** are skipped.
- [ ] It counts the **first whitespace-delimited word** of the real-name
      field only.
- [ ] Output is `Name: count`, one per line, **matching the spec's
      worked example** — including its order.
- [ ] You have **re-read the linked spec** after finishing, not before.
- [ ] It is submitted in **zyBooks 12.1** by **Friday, September 18,
      11:59 pm**. Not Canvas. zyBooks.

> `COMMISSION: ISSUED.`
> `SUBMISSION CHANNEL: ZYBOOKS. CANVAS: NOT THE CHANNEL. ASKED AND ANSWERED.`
> `LATE PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
