# COMMISSION No. II of 1851 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Commission** | ***The Speaking-Tube Console*** — the second of five |
| **Filed in the department's book as** | **zyBooks 12.2, "HUSH"** |
| **Assigned** | Monday, 14 September 1851 *(Week 5)* |
| **Due** | **Friday, October 16, 11:59 pm** *(Week 9)* — **submitted in zyBooks**, not Canvas |
| **Worth** | 4% of the semester |

---

## The commission

The tubes have always talked past each other.

Every bay in the Enginehouse has its own speaking tube — a brass mouth
in the wall that carries a voice from the floor above, or from the
yard, or from the dispatch clerk's cubby three corridors over. For as
long as anyone can remember, the tubes have simply *received*. A
porter puts an ear to the mouthpiece, hears the order, and walks it by
hand to whichever engine is meant to run it. It is slow. It is also,
Wednesday last, how we lost eleven minutes discovering that "start the
loom" meant Loom Three and not Loom One, because the porter who took
the message had gone to lunch and left no note.

The Board has asked for a console. Not another porter — a fitting,
bolted to the wall where the tubes converge, that listens for an
order, works out which engine the order names, and sets that engine
running itself, with no body in between to mishear it or wander off.
One order in, one engine started, and the console waits — properly
waits, not merely assumes — until that engine reports itself finished
before it takes the next order down the tube.

You built half of this already, in Week 3, and did not call it a
console. The pantograph desk clones itself — one desk-hand becomes
two, the twin sent off to become an entirely different clerk doing an
entirely different job, while the original sits at its post and does
not touch the next docket until word comes back that the twin's task
is done. That is the whole mechanism this commission asks you to wire
to a listening ear instead of a fixed instruction: hear the order,
clone yourself, let the copy become whichever engine the order named,
and wait at your post for word that it is finished. You already know
how to do every piece of this. The only new thing is that the
instruction now arrives from outside, one line at a time, instead of
being written into the desk beforehand.

Two orders will need to stay at the console and never go down the tube
to a cloned hand at all. "Leave" cannot be handed to a copy of
yourself — if the copy leaves, you are still standing at your post, no
better off for it. "Move to a different room" is the same trouble: a
clone that changes address does nothing for the original left behind
in the old one. Both must be answered by the console itself, on the
spot, before anything is cloned.

And some orders will simply be wrong — a program that was never
installed at this address, a word the console does not recognise as an
engine at all. The console must say so, plainly, and go back to
listening. It must not fall silent, and it must not fall over.

Mr. Kureos, hearing the plan described at his Wednesday visit,
allowed it his highest praise: "That is precisely the sort of
housekeeping I never had the patience to build properly. Do it well,
and do it once."

Build the console. Make it listen, make it dispatch, make it wait.

— *B.M.*

---

## Requirements

> ### THE LINKED SPEC IS AUTHORITATIVE.
>
> **<https://cs.harding.edu/gfoust/classes/comp3100/projects/hush>**
>
> This cover page adds a name, a date, and a story. It adds **no
> requirements**. Everything you are graded on lives at that link and in
> **zyBooks 12.2**, where you submit. Where this page and the spec
> disagree, **the spec wins** — read it, then read it again before you
> submit.

### One detail worth pausing on: after the child speaks, it stops

The spec's instructions for a failed `execvp` are two clauses: the
child "prints an error message and exits." It doesn't dwell on what
happens if you write the first clause and quietly skip the second, and
that is worth sitting with for a moment, because it is the single most
common way this project misbehaves on a first attempt.

Remember what a fork actually hands you: two copies of the same
process, both holding the same instructions, both about to carry on
from the very next line. If your child prints `asdf: command not
found` and then simply falls through — returns from a function,
say, instead of calling `sys.exit()` — it does not go away. It is
still the shell. It re-enters the very loop you wrote, prints its own
`HUSH> ` right alongside the parent's, and now two processes are
reading from the same keyboard, each catching lines meant for the
other. Nothing crashes. The prompts just quietly double, and the shell
starts behaving as though it has hiccups.

The spec's word for this is *exits* — plainly stated, easy to read
past. Take it as license to be deliberate about it: the child's part
in this ends the instant `execvp` has either replaced it or failed to.
There is no third path that leads back into the loop.

---

## Practical notes

**The three calls the spec asks you to use directly.** `os.fork` to
split the shell into two processes, `os.execvp` in the child to turn
that copy into the program the order named, and `os.wait` in the
parent to hold your place until the child is done. All three live in
Python's `os` module, and the spec's own hints link straight to their
documentation — worth reading before you write a line of code.

**The prohibition is explicit, not a house rule.** The spec's own
words: "Although Python has several higher-level functions for
executing processes, you must use fork and exec on this project!"
That rules out `subprocess.run`, `subprocess.Popen`, `os.system`,
`os.popen`, and anything else that hides the fork/exec/wait sequence
from you — not because they don't work, but because the point of the
commission is watching the operating system do this in the open, with
your own hands on the machinery. The spec notes you'll meet the
higher-level versions later in the semester, once you've earned the
shortcut.

**This is Week 3's mechanism, not a new one.** If `os.fork` handing
you back two copies of the same process, or a parent that has to
`os.wait` for a child it just made, feels unfamiliar rather than
half-remembered, that is worth a re-read of the Week 3 work order
before you start typing.

**The open workshop.** Friday, October 9 — the Friday of Exam I's
week, with a week still to go before the due date — is set aside as an
open HUSH workshop. Bring whatever you have running, or not running,
and the specific place it breaks.

**Testing without typing every line by hand.** The shell just loops
over `sys.stdin`; it does not care whether that stream is your
keyboard or a redirected file. A small text file of commands, fed in
with `./hush.py < commands.txt`, will save you retyping the same five
lines every time you test a fix — the same `<` trick the Census cover
showed you.

---

## Before you submit

- [ ] It is a **Python 3** program.
- [ ] It uses **`os.fork`**, **`os.execvp`**, and **`os.wait`**
      directly — no `subprocess`, `os.system`, `os.popen`, or any other
      higher-level process helper anywhere in the file.
- [ ] It loops over `sys.stdin`, printing the prompt before each line
      and reading commands until input ends.
- [ ] Every command line is split into words before it reaches
      `execvp` — the first word as the program, all the words as its
      arguments.
- [ ] If `execvp` fails, the **child** prints the error and exits — it
      does not take the parent down with it.
- [ ] The **parent** waits for the child to finish before prompting
      for the next line.
- [ ] `exit` and `cd` are handled inside the shell itself and never
      sent down to a forked child.
- [ ] Wildcards in a command line are expanded with `glob.glob`, word
      by word, before the command runs.
- [ ] Your shell's output matches the spec's own worked example,
      exactly — the example is the grading standard, not a suggestion.
- [ ] You have **re-read the linked spec** after finishing, not
      before.
- [ ] It is submitted in **zyBooks 12.2** by **Friday, October 16,
      11:59 pm**. Not Canvas. zyBooks.

> `COMMISSION: ISSUED.`
> `THE LINE IS OPEN.`
> `SUBMISSION CHANNEL: ZYBOOKS. CANVAS: NOT THE CHANNEL. ASKED AND ANSWERED.`
> `LATE PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
