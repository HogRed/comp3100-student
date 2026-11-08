# COMMISSION No. III of 1851 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Commission** | ***The Pattern Loom*** — the third of four |
| **Filed in the department's book as** | **zyBooks 12.3, "Regular Expressions"** |
| **Assigned** | Monday, 12 October 1851 *(Week 9)* — eight weeks to the Exhibition |
| **Due** | **Friday, November 6, 11:59 pm** *(Week 12)* — **submitted in zyBooks**, not Canvas |
| **Worth** | 5% of the semester |

---

## The commission

The invitations went out this morning.

Five sister cities, five sealed envelopes, five Boards who will soon be
asked to trust our Engine with their own ledgers. Which means the
replies will start arriving, and with them the clerks' paperwork that
always follows a promise: figures to be checked, addresses to be
answered, dates to be entered, and margin notes from every hand that
touched a page on its way to us.

The Board's first instinct was to hire more clerks to read it all. I
have asked for a loom instead.

You have watched a Jacquard loom work. The card goes in, and a hook
lifts only where the card has a hole. The loom does not *understand*
the card; it simply refuses every thread that does not fit the
pattern. That is exactly the machine I want at the ledger desk: a card
that describes the *shape* of a well-formed figure, or address, or
date, and a reader that holds every entry up to it and says yes or no.
No tired eyes. No "close enough."

Your commission is to punch four of those cards. Three that say
whether an entry has the right shape, and one that finds a clerk's
margin note in a line of text and hands back what the note says. The
cards are small. Punching them precisely is the whole craft — a hole
one place too wide and the loom lets the wrong thread through, and
nobody notices until the cloth is finished.

Punch them carefully. Test every card against the examples before you
trust it with the cities' post.

— *B.M.*

---

## Requirements

> ### THE LINKED SPEC IS AUTHORITATIVE.
>
> **<https://cs.harding.edu/gfoust/classes/comp3100/homework/regex/>**
>
> This cover page adds a name, a date, and a story. It adds **no
> requirements**. Everything you are graded on lives at that link and in
> **zyBooks 12.3**, where you submit. Where this page and the spec
> disagree, **the spec wins** — read it, then read it again before you
> submit.

**Dr. Foust's specification, restated in one paragraph.** In a Python
file named **`hw.py`** — zyLabs gives you a template for it — write
**three regular expressions and a function**. **`problem1`** is a
regular expression for a **number**: it may contain a decimal point,
but may not start or end with one, and it may have a minus sign in
front with no space between the minus and the number. **`problem2`** is
a regular expression for an **email address** of the form
*user*`@`*host*, where both parts contain only letters, digits,
underscores, and periods; neither part begins with a period, ends with
one, or has two in a row; and the host has at least one period (the
user need not). **`problem3`** is a regular expression for a **date**:
a 1- or 2-digit month, a 1- or 2-digit day, and a 2- or 4-digit year,
in that order, separated by `/`, `-`, or `.` — **the same character
both times** (the spec's hint: back references). **`problem4(text)`**
is a function that searches a string for the substring
`note="`*text*`"` and **returns the text in the quotes**. That text may
be any characters except a newline or a quotation mark; there must be
no word-character immediately before `note`; there may be zero or more
spaces (but not newlines) before and after the `=`; the context around
the substring does not matter; and if it is not found, the function
returns **`None`**. Each problem in the spec comes with a list of
strings that must match and strings that must not — those lists are
your test cases.

### One detail worth pausing on: `keynote` is not `note`

The last example in problem 4 is the one to stare at:

```
<section keynote="good"note="bad"footnote="ugly">
```

The spec says your function returns **`bad`**. Not `good`, even though
`good` comes first in the line.

Read it the way the loom would. The letters `note="` appear three
times in that line — inside `keynote`, on their own, and inside
`footnote`. A pattern that simply hunts for `note="` finds the first
one, inside `keynote`, and cheerfully returns `good`. That is wrong,
and it is wrong for exactly the reason the spec gives: there must
*not* be a word-character immediately before the match. The `y` in
`keynote` is a word-character. The `"` before the second `note` is
not.

The spec's own reminder is the tool: *"Remember there is a word-break
indicator."* Find it in your notes or the zyBooks section, and put it
where it belongs. Then run this exact line through your function and
watch it say `bad`.

---

## Practical notes

**Do it in zyLabs.** The spec's own suggestion: work directly in the
zyLabs template and submit when you are finished. If you would rather
work in VS Code, the spec links the three starting files — `hw.py`,
`main.py`, and an empty `__init__.py` that has to be there for the
import to work.

**Use the raw strings the template gives you.** The template opens each
pattern as `r''`. Keep the `r`. Without it, Python reads your
backslashes before the regular-expression engine ever sees them, and
`\b` stops meaning what you think it means.

**Whole string or anywhere in it?** The starter `main.py` (which is not
graded — it is there for your own testing) checks `problem1` with
`re.fullmatch`, which asks whether the *whole* string fits the pattern.
That is the right way to read the three must-match / must-not-match
lists. Try `1a2` with `re.search` instead and it happily finds the `1`
at the front — a match, on a string the spec says must fail. Problem 4
is the opposite kind of question: the note sits *somewhere inside* a
longer line, so that one is a search.

**The template's `problem4` body is a placeholder.** It returns a list
of numbers for one particular date. That is a stand-in so the file runs,
not a hint about the answer. The spec says what `problem4` returns:
the text between the quotes, or `None`.

**"Spaces" means spaces.** Problem 4 allows zero or more *spaces*
around the `=`, "but not new-lines." A shorthand class that matches all
whitespace also matches a newline, and then the spec's
`note=` / `"nope"` example, split across two lines, would wrongly find
`nope`.

**The shape, not the sense.** The date pattern checks form, not the
calendar: the spec lists `57/82/4123` as a string that **must match**.
Do not add month or day validation the spec did not ask for — it will
reject a string the tests expect you to accept.

**Test against the spec's lists, every one.** There are forty-six
example strings across the four problems, and every one of them is a
test you can run in thirty seconds. The ones in the *must not match*
lists are where most patterns quietly fail.

---

## Before you submit

- [ ] It is **`hw.py`**, built on the zyLabs template, with
      **`problem1`**, **`problem2`**, **`problem3`**, and a function
      **`problem4(text)`**.
- [ ] **`problem1`** matches every number on the spec's list and none of
      the non-numbers — including `.5`, `7.`, `-.238`, and `- 6`.
- [ ] **`problem2`** accepts every listed address and rejects every
      listed fake — including `hello@world` and `nancy@coolmail..biz`.
- [ ] **`problem3`** uses the **same separator both times**, and rejects
      `11.22-33` and `4/5.6`.
- [ ] **`problem4`** returns the text in the quotes for all six of the
      spec's examples — **`bad`** for the `keynote` line — and returns
      **`None`** for all four of its counter-examples.
- [ ] You have **re-read the linked spec** after finishing, not before.
- [ ] It is submitted in **zyBooks 12.3** by **Friday, November 6,
      11:59 pm**. Not Canvas. zyBooks.

> `COMMISSION: ISSUED.`
> `CARDS TO BE PUNCHED: FOUR. CARDS PUNCHED APPROXIMATELY: NOT CARDS.`
> `SUBMISSION CHANNEL: ZYBOOKS. CANVAS: NOT THE CHANNEL. ASKED AND ANSWERED.`
> `LATE PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
