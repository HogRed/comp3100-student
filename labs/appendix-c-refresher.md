# The Guild's C Refresher — an Appendix for New Hands

*Honourable Guild of Enginewrights — Ex Vapore, Ordo*

> **Entirely optional. Worth no points, ever.** This appendix exists
> for apprentices whose last languages were Java or Python and who
> would like C to stop feeling like a foreign country before Week 2's
> forge work. Budget **about 90 minutes**, self-paced: six parts of
> roughly fifteen minutes, each ending in one micro-exercise.
> **Answers to all six are at the bottom** — predict first, then check.
> Comfortable C hands should close this file and go do the work order.

## Before you start (in plain English)

If you are here because someone said "the rest of the semester is in
C" and your stomach dropped a little — you are not behind. You are
exactly where a thoughtful person lands after a few years of Java or
Python, and most of this room is standing right beside you.

Here is the reassuring part: C is a *small* language. That is not a
consolation prize, it is the entire design. There is less to memorize
here than in whatever you wrote last year — a handful of ideas about
values, addresses, rows of memory, and small labeled racks — and then
the language gets out of your way. What takes practice is not the
vocabulary. It is the habit of asking, at every line, *where does
this actually live?*

That habit is why C is worth knowing at all. Linux — and nearly every
other operating system you have ever used — is written in C, so
reading it is how you get to see the machinery instead of the
brochure. Every language you have written so far was standing on top
of this. This semester you get to walk downstairs and look at the
boiler.

Ninety minutes now, and every week after it reads more easily.
Nothing below is graded, timed, or reported to anyone. Predict before
you check, be wrong out loud a few times, and bring the wreckage to
studio — that is the whole technique.

Everything below runs in your course Linux environment from Week 1.
Make yourself a scratch folder so experiments don't wander into graded
work:

```sh
mkdir -p ~/c-refresher && cd ~/c-refresher
```

---

## Part 1 — The forge: how a C program is built *(~15 min)*

Java compiles to bytecode and hands it to a virtual machine; Python
hands source to an interpreter. **C compiles to machine code and hands
it to nobody.** The file `gcc` produces is the finished casting: raw
instructions your CPU executes directly, with no runtime supervisor
watching for out-of-bounds indexes or misused memory. That is why C is
fast, why the Linux kernel and `gcc` itself are written in it — and
why this course keeps *watchmen* (compiler warnings, AddressSanitizer,
valgrind) around every build. Nobody re-checks your work at runtime
unless you invite them.

That is a real change in job description, and worth naming plainly:
in C, the checking is yours to arrange. So the flags below are not
fussiness — they are the colleagues you hire at the start of every
build.

Type this in as `salute.c` — typing rather than pasting is the point,
because your fingers notice punctuation your eyes skip over:

```c
#include <stdio.h>

int main(void)
{
    int wheels = 40;
    printf("The Engine turns %d feet of figure wheels.\n", wheels);
    return 0;
}
```

Build and run it:

```sh
gcc -Wall -Wextra -g -o salute salute.c
./salute
```

Expected:

```
The Engine turns 40 feet of figure wheels.
```

What those pieces mean, once and for all:

| Piece | Meaning |
|---|---|
| `#include <stdio.h>` | Paste in the *declarations* of the standard I/O functions, so the compiler knows `printf`'s shape. Forget it and the compiler complains of an "implicit declaration" — Week 2's FAULT 1. |
| `int main(void)` | Every C program starts at `main`; its `int` return goes to the shell (`0` = success — check it with `echo $?`). |
| `printf("... %d ...", wheels)` | Text with placeholders: `%d` for `int`, `%s` for a string, `%zu` for a size, `%p` for an address. The compiler checks these *only* because `-Wall` asks it to. |
| `-Wall -Wextra` | Turn on the compiler's judgment. **Always.** A C compiler without warnings enabled is a foreman who waves everything through. |
| `-g` | Keep names and line numbers in the casting, so ASan, valgrind, and debuggers can cite `salute.c:6` instead of a raw address. |
| `-o salute` | Name the output. Without it you get the historical default `a.out`. |

The build actually happens in four stages — preprocess (`#include` and
friends are textual paste-ins), compile (C → assembly), assemble
(assembly → machine code), link (join your code with the C library).
One command to feel the first stage:

```sh
gcc -E salute.c | wc -l
```

Expected: a number in the hundreds — about 800 on the course image, and
it drifts with your glibc version — your seven-line program *after*
the preprocessor pastes `stdio.h` in. When an error message someday
cites code you never wrote, this is where it came from.

> **Micro-exercise 1.** Without running it: what does this program
> print, and what does `echo $?` show right after?
>
> ```c
> #include <stdio.h>
>
> int main(void)
> {
>     int capsules = 4;
>     printf("%d minutes to an answer,\n", capsules);
>     printf("%d capsules in the tube.\n", capsules - 1);
>     return 2;
> }
> ```
>
> Predict, then type it in as `ex1.c`, build with the full flag set,
> and check both predictions. A wrong prediction is the useful kind —
> it tells you exactly which paragraph above to reread.
> *(Answer at the bottom.)*

---

## Part 2 — Pointers: the pneumatic post *(~15 min)*

Brassbridge's pneumatic post can deliver a capsule to any pigeonhole
in the city, because every pigeonhole has a **brass address plate**.
The Store — memory — works the same way: every variable lives
somewhere, and that somewhere has an address.

A **pointer is a slip of paper with an address written on it.** That
is the entire idea, and notice how much of it you already know:
nobody has ever confused a friend's house with the address on the
envelope, or expected copying the address to copy the house. Pointers
have a fearsome reputation, but most of that fear is unfamiliar
notation rather than a hard idea. Two operators move you between a
thing and its address:

- `&x` — *"read the address plate"*: the address where `x` lives.
- `*p` — *"send for the contents"*: the thing living at the address
  written on slip `p`.

Type this in as `post.c`:

```c
#include <stdio.h>

int main(void)
{
    int ledger = 214;        /* a value, living in one pigeonhole   */
    int *slip = &ledger;     /* a slip holding that pigeonhole's address */

    printf("value: %d\n", ledger);
    printf("address on the slip: %p\n", (void *)slip);
    printf("contents at that address: %d\n", *slip);

    *slip = 215;             /* deliver a new value BY ADDRESS */
    printf("ledger is now: %d\n", ledger);
    return 0;
}
```

Expected (the address is your machine's, and changes every run):

```
value: 214
address on the slip: 0x7ffd8be2a614
contents at that address: 214
ledger is now: 215
```

Read the last two lines again: the program changed `ledger` **without
naming it** — it wrote through the address. That is what pointers are
*for*: handing someone else the means to reach your data. When C wants
a function to modify a caller's variable, it hands over an address —
this is why `scanf("%d", &x)` needs the `&`, and it is Java's
"references" and Python's "names bind to objects" made visible and
manual.

Declaration reading habit: `int *slip` reads best right-to-left —
"`slip` is a pointer to an `int`." The `*` belongs to the declaration;
in an expression, `*slip` is the dereference.

Two slips of caution:

- **A blank slip:** `NULL` is the address that addresses nothing.
  Dereference it and the Overseer halts your program on the spot —
  the famous *segmentation fault*: a delivery attempted to a
  pigeonhole that does not exist, refused at the door.
- **A stale slip:** an address can outlive the thing that lived there
  (Part 4 shows how). C will cheerfully deliver to the old address.
  The watchmen exist because C will not stop you.

> **Micro-exercise 2.** Predict all four printed lines:
>
> ```c
> #include <stdio.h>
>
> int main(void)
> {
>     int a = 5, b = 12;
>     int *p = &a;
>
>     printf("%d %d\n", a, b);
>     *p = *p + 1;
>     p = &b;
>     *p = *p + 1;
>     printf("%d %d\n", a, b);
>     printf("%d\n", *p);
>     printf("%d\n", *(&a));
>     return 0;
> }
> ```
>
> Then type it in as `ex2.c` and check. *(Answer at the bottom.)*

---

## Part 3 — Arrays and strings: rows of pigeonholes *(~15 min)*

An **array** is a row of pigeonholes rented side by side: `int
hours[5]` is five `int`s in a straight line, indexed `0` through `4`.
The bracket syntax is pointer arithmetic wearing gloves: `hours[2]`
means *"the contents two pigeonholes past the start"*, and the bare
name `hours` is (in nearly every expression) the address of the first
one.

The part that bites every newcomer from Java or Python: **C never
checks your index.** `hours[5]` on a five-slot array is not an
exception, not an error message — it is a delivery to whoever lives
next door. Week 2's FAULT 3 is exactly this, and AddressSanitizer
exists because the language will not catch it.

This is not a trap you escape by being clever. It is a place where
the language assumes a human is counting — a fair description of most
of C, and the reason this course drills habits rather than tricks.

Type in `rows.c`:

```c
#include <stdio.h>
#include <string.h>

int main(void)
{
    int hours[5] = {4, 5, 6, 7, 8};
    int total = 0;

    for (int day = 0; day < 5; day++)   /* 0..4 — five trips exactly */
        total += hours[day];
    printf("week's tally: %d\n", total);

    char motto[] = "Ex Vapore, Ordo";
    printf("%s has %zu letters but fills %zu pigeonholes.\n",
           motto, strlen(motto), sizeof motto);
    return 0;
}
```

Expected:

```
week's tally: 30
Ex Vapore, Ordo has 15 letters but fills 16 pigeonholes.
```

That last line is the whole theory of C strings. A **string is just a
`char` array with a contract**: after the last real character comes a
byte of value zero, written `'\0'`, the **terminator**. `printf("%s")`
and `strlen` both walk pigeonhole by pigeonhole until they meet it.
Fifteen letters plus one terminator = sixteen `char`s. Hence:

- `strlen(s)` — letters before the terminator (walks the row; needs
  `<string.h>`).
- `sizeof s` — pigeonholes the *array* occupies (counted at compile
  time; terminator included).
- Lose the terminator — overwrite it, or copy fifteen letters into a
  fifteen-slot array — and `strlen` keeps walking into the neighbors'
  pigeonholes until it happens upon a zero byte. Whole catalogs of
  security holes are this paragraph.

> **Micro-exercise 3.** Predict the three printed numbers:
>
> ```c
> #include <stdio.h>
> #include <string.h>
>
> int main(void)
> {
>     char name[8] = "Bray";
>     int  gauge[4] = {7, 0, 2, 6};
>
>     printf("%zu\n", strlen(name));
>     printf("%zu\n", sizeof name);
>     printf("%d\n", gauge[strlen(name) - 1]);
>     return 0;
> }
> ```
>
> Then type it in as `ex3.c` and check. *(Answer at the bottom.)*

---

## Part 4 — `malloc` and `free`: the Store's counter clerk *(~15 min)*

Arrays declared like `int hours[5]` have their size fixed when you
write the program. When the size arrives at *runtime* — a file of
unknown length, a user's count — you rent pigeonholes from the
**Store's counter clerk**: `malloc`.

- `malloc(n)` — *"rent me `n` bytes"* — returns the address of the
  first byte (a slip of paper: a pointer), or `NULL` if the Store
  cannot oblige. Check it.
- `free(p)` — *"the rental at this address is surrendered"* — returns
  it exactly once, using the same address slip `malloc` issued.

Two functions, one promise. The promise — you rented it, so you give
it back — is the first piece of housekeeping in your programming life
that nobody does for you, and it is worth meeting calmly here rather
than at midnight later in the term.

Type in `store.c`:

```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int days;
    printf("how many days? ");
    if (scanf("%d", &days) != 1 || days < 1)
        return 1;

    int *hours = malloc(days * sizeof *hours);  /* rent: days ints */
    if (hours == NULL)
        return 1;

    for (int d = 0; d < days; d++)
        hours[d] = d + 4;                       /* rented rows index like arrays */

    int total = 0;
    for (int d = 0; d < days; d++)
        total += hours[d];
    printf("tally over %d days: %d\n", days, total);

    free(hours);                                /* surrender the rental */
    return 0;
}
```

Build it, run it, answer `5`, expect `tally over 5 days: 30`.

The clerk's ledger rules, and what breaks when they're broken:

| Rule | Broken, it's called | Who catches it |
|---|---|---|
| What you rent, you surrender — eventually, once | a **leak** (rent and forget) | `valgrind` — "definitely lost" bytes |
| Surrender each rental exactly once | **double free** | ASan / the C library, loudly |
| After `free`, the slip is stale — never deliver through it | **use-after-free** | ASan (`heap-use-after-free`) |
| Never touch past what you rented | **heap overflow** | ASan (`heap-buffer-overflow`) |

Java's garbage collector and Python's reference counts do the
surrendering for you; C makes it a bookkeeping duty, which is why a
long-running C program with sloppy books slowly eats the machine. Run
the clerk's auditor over your (correct) program to see a clean bill:

```sh
gcc -Wall -Wextra -g -o store store.c
valgrind ./store
```

Expected, among the report: `All heap blocks were freed -- no leaks
are possible` and `ERROR SUMMARY: 0 errors`. Now comment out the
`free(hours);` line, rebuild, and run valgrind again — expect
`definitely lost: 20 bytes in 1 blocks`. Put the `free` back.

> **Micro-exercise 4.** Build it with the usual flags and the compiler
> mutters once. Run it plain (no valgrind yet) and it prints `4`, then
> dies loudly — glibc catches this one itself and aborts with
> `free(): double free detected in tcache 2`. Read the source and name
> *both* clerk's rules it breaks, and where, before valgrind confirms
> your reading.
>
> Two cautions, because this one is rigged to mislead. First, the
> compiler spells its complaint `-Wuse-after-free`, but handing a
> surrendered slip back to the clerk *is* a way of using it — read the
> `note:` line and you will see it pointing at the earlier `free`, not
> at any read. Second, the compiler and glibc are both shouting about
> the **same** rule. The other broken rule makes no noise at all: no
> warning, no abort, nothing but a clean-looking `4`. That is the one
> you have to find by reading the source, and it is the reason the
> clerk keeps books instead of trusting how the program felt.
>
> ```c
> #include <stdio.h>
> #include <stdlib.h>
>
> int main(void)
> {
>     int *a = malloc(3 * sizeof *a);
>     int *b = malloc(3 * sizeof *b);
>     for (int i = 0; i < 3; i++)
>         a[i] = b[i] = i;
>     printf("%d\n", a[2] + b[2]);
>     free(a);
>     free(a);
>     return 0;
> }
> ```
>
> Fix both on paper, then type in your fixed version as `ex4.c` and
> prove it with `valgrind ./ex4`. *(Answer at the bottom.)*

---

## Part 5 — Structs: a labeled rack *(~15 min)*

A **struct** is a small rack of pigeonholes under one name, each
compartment labeled — the closest C comes to an object, with all the
methods left off. If you are arriving from classes, the missing half
is not hidden somewhere clever: C keeps the data and the functions
that act on it as separate things, and leaves the joining to you.
Type in `rack.c`:

```c
#include <stdio.h>

struct loom {
    char name[16];
    int  cards_run;
    int  jammed;      /* C has no boolean of its own until C99's
                         <stdbool.h>; 0 is false, everything else true */
};

void service(struct loom *l)
{
    l->cards_run = 0;     /* reach a member THROUGH AN ADDRESS: ->  */
    l->jammed = 0;
}

int main(void)
{
    struct loom west = { "West Gallery", 4128, 1 };

    printf("%s: %d cards, %s\n",
           west.name, west.cards_run,
           west.jammed ? "JAMMED" : "running");

    service(&west);
    printf("%s: %d cards, %s\n",
           west.name, west.cards_run,
           west.jammed ? "JAMMED" : "running");
    return 0;
}
```

Expected:

```
West Gallery: 4128 cards, JAMMED
West Gallery: 0 cards, running
```

The two member operators, and the only rule you need:

- `west.name` — the **dot** reaches into a struct you hold directly.
- `l->cards_run` — the **arrow** reaches into a struct you hold *by
  address* (it is exactly `(*l).cards_run`, abbreviated).

And note *why* `service` takes an address: passed plainly, C hands
functions a **copy** of the struct — the function would service the
copy, the original would stay jammed, and no warning would tell you.
Handing over the address (`&west`) is how the function reaches the
one true rack. This is the Part 2 lesson wearing work clothes, and
it is how every C library you will meet this semester — `pthread`s,
file APIs, the lot — expects to be spoken to.

> **Micro-exercise 5.** Predict the two printed lines:
>
> ```c
> #include <stdio.h>
>
> struct capsule {
>     int district;
>     int minutes;
> };
>
> void reroute(struct capsule c)  { c.minutes = 99; }
> void expedite(struct capsule *c) { c->minutes = 2; }
>
> int main(void)
> {
>     struct capsule p = { 7, 4 };
>     reroute(p);
>     printf("district %d: %d minutes\n", p.district, p.minutes);
>     expedite(&p);
>     printf("district %d: %d minutes\n", p.district, p.minutes);
>     return 0;
> }
> ```
>
> Then type it in as `ex5.c` and check — the compiler even warns that
> `reroute`'s assignment goes nowhere (`-Wunused-but-set-parameter`);
> it sees the change will never leave the room, which IS pass-by-value.
> *(Answer at the bottom.)*

---

## Part 6 — Reading the watchmen: a field guide *(~15 min)*

Week 2's work order has you repair four faults by symptom. Error
messages read like accusations when you are tired; they are closer to
a colleague pointing at a line and saying *this bit, here*. Reading
them is a skill rather than a talent, and it is the skill that most
changes how the rest of this course feels. Here is the habit of mind,
condensed — C's error reports reward a *reading order*:

1. **Read the first complaint first.** One real mistake often
   cascades; the compiler's later messages are frequently echoes of
   the first. Fix, rebuild, read again.
2. **The line number is where trouble was *noticed*, not always where
   it was *made*.** An error on line 40 whose cause is a missing
   semicolon on line 39 is a rite of passage.
3. **`warning` is not `error` — treat it as one anyway.** The casting
   still pours, which is exactly what makes warnings dangerous: the
   program *runs*. The Guild's checkers compile with `-Werror`
   (warnings promoted to errors) for this reason.
4. **Know which watchman you're reading.** The *compiler* judges the
   source before it runs. *AddressSanitizer* (built in via
   `-fsanitize=address`) watches addresses while it runs — wrong
   pigeonholes, stale slips. *valgrind* replays the run under a
   magnifier — uninitialised reads, leaked rentals. They overlap
   barely at all, which is why the Guild posts all three.
5. **`man` is on your side**: section 3 for library calls (`man 3
   printf`, `man 3 malloc`), section 2 for system calls — Week 1's
   sectioned-library lesson, earning its keep.

A worked example — the classic first message of every C career:

```
warning: implicit declaration of function 'strlen' [-Wimplicit-function-declaration]
```

Translated: *"You called `strlen`, but no header has told me its
argument and return types, so I am guessing — badly."* The fix is
never to silence the guess; it is to `#include` the header that
declares the function (`man 3 strlen` names it in its SYNOPSIS —
`<string.h>`). Modern GCC even prints the answer in a `note:` line
underneath. The compiler is not an adversary; it is the one colleague
who read the whole manual.

> **Micro-exercise 6.** Each message below came from a real one-line
> mistake. Name the mistake (no compiler needed — this one is a paper
> exercise):
>
> ```
> a) warning: implicit declaration of function 'malloc'
> b) warning: suggest parentheses around assignment used as truth value
> c) error: expected ';' before 'return'
> d) AddressSanitizer: stack-buffer-overflow ... WRITE of size 4
> e) Conditional jump or move depends on uninitialised value(s)   (valgrind)
> ```
>
> *(Answer at the bottom.)*

---

That is the whole refresher. Sweep the scratch folder if you like
(`rm -r ~/c-refresher`), and take the work order at forge heat. C
rewards exactly the virtues the Guild already demands: write down what
you did, and never trust a figure you have not checked — least of all
your own.

One thing worth saying out loud before you go. What you practiced
here is not a course dialect: it is the working language of kernels,
databases, embedded controllers, and half the tools you rely on
without thinking about them. You can read that code now — slowly,
which is how everyone reads it at first, including the people who
maintain it. That is not a small door to have opened in ninety
minutes.

---

## Answers

Compare these against your predictions rather than grading yourself
on them. The gap is the interesting part: a wrong prediction is a
belief you did not know you were holding, and now you know where to
look. When one surprises you, change a single line of the little
program and run it again until the machine stops surprising you —
that beats memorizing the answer every time.

**1.** It prints `4 minutes to an answer,` then `3 capsules in the
tube.` (the second `printf` computes `capsules - 1` without changing
`capsules`). `echo $?` shows `2` — `main`'s return value is the
process's exit status, and anything nonzero reads as "failure" to the
shell. This is why every script and Makefile this semester can tell
whether your programs worked.

**2.** `5 12`, then `6 13`, then `13`, then `6`. Walkthrough: `p`
first holds `a`'s address, so `*p = *p + 1` turns `a` into 6; then the
slip is rewritten to `b`'s address, so the same line turns `b` into
13; `*p` now reads through to `b` (13); `*(&a)` is just `a` (6) — the
two operators cancel.

**3.** `4`, `8`, `6`. `strlen` counts letters up to the terminator
(`Bray` = 4); `sizeof` reports the declared array (8 pigeonholes,
however few are used); `gauge[strlen(name) - 1]` is `gauge[3]` = 6.

**4.** The two broken rules: `b` is rented and never surrendered (a
**leak** — valgrind: `definitely lost: 12 bytes in 1 blocks`), and `a`
is surrendered **twice** (`free(a); free(a);` — a double free; the
second call must become `free(b);`). Fixed, the program frees each of
`a` and `b` exactly once and valgrind reports `0 errors` with `All
heap blocks were freed`. If you named *use-after-free*, the compiler's
choice of words caught you — nothing in this program ever reads
through a stale slip; the only stale slip is the one handed back to
the clerk a second time. Note, too, which watchman caught which: the
warning and the abort both point at the double free, and the leak is
mentioned by nobody until valgrind counts the books. (The arithmetic
itself was never wrong — `4` prints before either `free` runs — but a
value printed correctly is no proof of correct bookkeeping. That is
the entire moral of Part 4.)

**5.** `district 7: 4 minutes` then `district 7: 2 minutes`.
`reroute` receives a *copy* — its change dies with it. `expedite`
receives the address and reaches the one true capsule. If you expected
`99` anywhere, reread Part 5's last paragraph — this is the single
most useful thing to know about passing structs.

**6.** (a) Missing `#include <stdlib.h>` — `malloc`'s header. (b) `=`
(assignment) inside a condition where `==` (comparison) was meant.
(c) The *previous* line lost its semicolon — the compiler only noticed
upon reaching `return` (see reading-order habit 2). (d) A write one
past the end of an array — an off-by-one loop bound, usually `<=`
where `<` belonged. (e) A variable read before it was given a value —
initialise it where it is declared.

---

*Filed with the Guild library. Return when C stops feeling foreign —
or sooner, whenever a watchman's report wants translating.*
