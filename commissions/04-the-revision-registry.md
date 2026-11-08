> **WITHDRAWN, Monday 9 November.** This commission is cancelled: there is
> nothing to submit for zyBooks 12.5 and no grade for it. Commission IV is
> now *The Exchange Audit*
> ([`05-the-exchange-audit.md`](05-the-exchange-audit.md)), due Friday,
> December 4. The page below is kept for the record only.

# ~~COMMISSION No. IV of 1851~~ — WITHDRAWN

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Commission** | ***The Revision Registry*** — the fourth of five |
| **Filed in the department's book as** | **zyBooks 12.5, "Simple Versioning System"** |
| **Assigned** | Monday, 26 October 1851 *(Week 11)* — six weeks to the Exhibition |
| **Due** | **Friday, November 20, 11:59 pm** *(Week 14)* — **submitted in zyBooks**, not Canvas |
| **Worth** | 4% of the semester |

---

## The commission

The Exhibition audit opened this morning in the Ledger Halls.

Every civic ledger the Engine keeps is to be examined, page by page,
before the world is invited to admire it. The auditors began at nine.
By ten they had their first question, and it was not one they could
answer: *what did this page say last week?*

Nobody knows. The Ledger Halls keep exactly one copy of every page —
the current one. When a page is altered, honestly or otherwise, the
old wording is simply gone, and the page looks as respectable as it
did before. A hall that keeps only the present cannot tell you when it
was changed or what it was changed from. It can only tell you what it
says now, and ask you to take its word.

I do not take pages at their word. Neither should you.

So the Board has agreed to a **registry of revisions**: a clerk who
walks the halls, looks at each page, and asks one question of it —
*has this been altered since my last fair copy?* If it has, the clerk
makes a new copy, numbers it, and files it in a drawer behind the
page. If it has not, the clerk leaves it be and says so. Drawers being
finite, the clerk may be told to keep only the most recent few copies
and clear out the rest. And the clerk does not copy its own drawers,
or the halls would fill with copies of copies by Christmas.

Your commission is to build that clerk. It will not be the finest
such machine ever made — the spec says as much in its first
paragraph, and it is right — but it will be yours, and you will know
exactly what it does and why.

Build it. Then alter a page and watch it notice.

— *B.M.*

---

## Requirements

> ### THE LINKED SPEC IS AUTHORITATIVE.
>
> **<https://cs.harding.edu/gfoust/classes/comp3100/projects/version>**
>
> This cover page adds a name, a date, and a story. It adds **no
> requirements**. Everything you are graded on lives at that link and in
> **zyBooks 12.5**, where you submit. Where this page and the spec
> disagree, **the spec wins** — read it, then read it again before you
> submit.

**Dr. Foust's specification, restated in one paragraph.** Write a
**Python** script, **`svs.py`**, that stores multiple versions of a
file. It takes zero or more **paths** and three options, built with
**`argparse`**: **`-r`/`--recursive`** (recurse on any subdirectories
encountered), **`-v`/`--verbose`** (report versions made and any
omissions), and **`-l LIMIT`/`--limit LIMIT`** (keep only the *LIMIT*
most recent versions). It iterates over every path given; given
**none**, it iterates over every entry in the **current directory**.
A path that does not exist prints
`prog: path: no such file or directory`, where *prog* is the script's
file name only. When iterating over a directory it **skips hidden
entries** — names that begin with a period. A **directory** is
recursed into if `-r` was given; otherwise, with `-v`, it prints
`omitting directory path`; otherwise nothing happens. For a **file**,
it creates a **`.versions`** subdirectory beside the file if one does
not exist, finds every version already there named
*filename*`.v`*N* (*N* being one or more digits), and takes the next
version number to be **one more than the largest** *N* — or **1** if
there are none. If this is the first version, or the file has changed
since its most recent version — meaning its **last-modified timestamp
is more recent than that of the last backup** — it copies the file to
*filename*`.v`*M* in `.versions`, *M* being the new number. If the file
has not changed, it prints `omitting unchanged path`. Then, if a limit
was given and more versions exist than the limit allows, it deletes
the **oldest** ones until only *LIMIT* remain. Version numbers are
**not assumed to be sequential**. Paths are printed relative to the
command-line argument they came from, and the spec's hints say you
should not need any subprocesses: everything you need is in `os`,
`os.path`, and `shutil`.

### One detail worth pausing on: v10 comes after v9

The spec tells you to store the version numbers you find **as
integers** and to sort them **numerically**. That is easy to read past,
because the obvious shortcut — sort the file names — looks as if it
does the same job. It does, right up until the tenth version:

```
>>> sorted(['ledger.txt.v9', 'ledger.txt.v10'])
['ledger.txt.v10', 'ledger.txt.v9']
>>> sorted([9, 10])
[9, 10]
```

Sorted as text, `v10` comes *before* `v9`, because the character `1`
comes before `9`. A registry that sorts names will think version 9 is
the newest, compare the page against the wrong copy, and then pick
`v10` as the next number to write — over the top of a copy that
already exists. With `-l`, it may cheerfully delete `v10` and `v11`
and keep `v9`. Nine versions in, nothing has gone wrong
yet, which is exactly why this bug survives testing.

The spec's other warning belongs to the same family: **do not assume
the numbers are sequential.** If `-l` has cleared out versions 1 to 3,
the drawer holds `v4` and `v5`, and the next copy is `v6`, not `v3`.
Pull the number out of each name, convert it with `int()`, and let the
largest integer decide.

---

## Practical notes

**Here is the clerk at work.** Run in a scratch directory, with
`svs.py` one level up and made executable:

```sh
$ echo "Page one" > ledger.txt
$ ../svs.py ledger.txt
$ ls .versions
ledger.txt.v1
$ ../svs.py -v ledger.txt
omitting unchanged ledger.txt
$ touch ledger.txt
$ ../svs.py ledger.txt
$ ls .versions
ledger.txt.v1  ledger.txt.v2
$ ../svs.py ledger.tx
svs.py: ledger.tx: no such file or directory
$ mkdir drafts
$ ../svs.py -v drafts
omitting directory drafts
```

The first run prints nothing and makes `v1`. The `-v` run finds the
page unchanged and says so. Then `touch` — which alters nothing but
the timestamp — is enough to earn a `v2`.

**The clerk checks the clock, not the contents.** That last step is
the spec working as written: a new version is made when the file's
last-modified time is newer than the last backup's, whether or not a
single character changed. `touch` is the quickest way to test the
"changed" branch without editing anything, and `stat ledger.txt`
shows you the timestamps the clerk is comparing.

**Test in a scratch directory.** Run with no paths, the script
versions everything in the current directory, and with `-r` it walks
down into every subdirectory as well. Make a directory for testing,
put a few small files and a subdirectory or two in it, and run there —
not in your home directory.

**`ls` will not show you `.versions`.** It is hidden, on purpose —
that is also why the script never versions its own backups. Use
`ls -a` to see it, and `ls .versions` to look inside.

**Paths are printed the way they were given.** Run `-r` on `drafts`
and a file two levels down is reported as `drafts/memo.txt` or
`drafts/old/memo.txt`, built up from the argument with
`os.path.join` — the spec recommends leaving your working directory
alone and passing longer paths down a recursive function.

**Let `argparse` write the help text.** The spec's own hint: you are on
the right track when `./svs.py -h` matches the synopsis at the top of
the spec. The description, the help strings, and the paragraph at the
bottom all come from arguments you hand to `argparse`, not from
`print`. And like the Census, the synopsis runs the script as
`./svs.py` — a sh-bang line and `chmod +x`.

**File names in a regular expression need `re.escape`.** If you find
the `.v`*N* names with a regular expression — the Pattern Loom's tools
— a file name such as `ledger.txt` contains a `.`, which means "any
character" to the regex engine. The spec's hint shows the fix:
`re.escape(filename)` before you add the rest of the pattern.

**Yes, this is what Git does.** The spec says so in its second
paragraph. Build it anyway: you will understand Git's `.git` directory
rather better afterwards.

---

## Before you submit

- [ ] It is a **Python 3** script, **`svs.py`**, using **`argparse`**
      for **`-r`**, **`-v`**, **`-l`**, and the paths.
- [ ] With **no paths** given, it works through the **current
      directory**.
- [ ] A missing path prints `prog: path: no such file or directory`,
      with the script's **file name only**.
- [ ] **Hidden** entries are skipped when iterating over a directory.
- [ ] Directories are **recursed into only with `-r`**; with `-v` and no
      `-r`, it prints `omitting directory path`.
- [ ] Backups go in a **`.versions`** directory beside each file, named
      *filename*`.v`*N*.
- [ ] A new version is made only when the file's **last-modified time
      is more recent** than the last backup's; otherwise it prints
      `omitting unchanged path`.
- [ ] Version numbers are compared as **integers**, and gaps in the
      numbering do not confuse it.
- [ ] **`-l`** deletes the **oldest** versions until only *LIMIT*
      remain.
- [ ] It does its work with `os`, `os.path`, and `shutil` — no
      shell commands run from inside the script.
- [ ] You have **re-read the linked spec** after finishing, not before.
- [ ] It is submitted in **zyBooks 12.5** by **Friday, November 20,
      11:59 pm**. Not Canvas. zyBooks.

> `COMMISSION: ISSUED.`
> `PAGES ALTERED: TO BE NOTICED. PAGES UNALTERED: TO BE LEFT ALONE.`
> `SUBMISSION CHANNEL: ZYBOOKS. CANVAS: NOT THE CHANNEL. ASKED AND ANSWERED.`
> `LATE PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
