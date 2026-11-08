# WORK ORDER No. 1851-13 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 9 November 1851 — four weeks to the Exhibition |
| **Due** | **Sunday, 15 November, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The Warden has ordered an audit of the registry before the Exhibition's
crowds arrive: every key the Guild has cut, and every key shown at a Guild
door since the books were opened. The Warden's clerks have begun with the
registry itself, and have turned up a spare key that nobody at the Warden's
desk remembers cutting. It is stamped like the rest. It is in no book of
theirs.

Before you read the Warden's log, learn what the Engine means by *who you
are* and *what you may do*: the numbers behind a user name, the ten
characters at the start of every `ls -l` line, and one special mark in those
ten, the **setuid bit**, that lets a program borrow its owner's authority.
Then audit: find every file on the bench that carries that mark, read the
Warden's log of keys shown at the doors, and set it beside the porters' visitor
book, which is kept on paper by a different hand.

The registry is not yours to mend. Leave every paper as you found it, and
write down what is there. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Every program on the Engine runs *as* someone, and every file says who may
do what with it. This week is about reading both: who a program is running
as, what a file's owner has allowed, and what happens when a file is allowed
to run as its owner instead of as you. It ends with reading a log, the way an
auditor does.

The fiction is set dressing and the commands are the course; **no task here
requires story knowledge.** There is no required reading this week. zyBooks
**Ch 10** (security) is optional; where a section bears on a task it is named
below. By the time you hand this in you will be able to:

1. **Say who you are to the Engine.** `id`, `whoami` and `groups`; a **uid**,
   a **gid** and the **supplementary groups**; the seven fields of an
   `/etc/passwd` line (the file you read in Commission I, and cut with
   `cut -d:` in Week 12); **root** is uid 0.
2. **Read a permission string and change it.** The type letter and the three
   **rwx** triads (owner, group, other); `chmod` in **symbolic** form
   (`g+r`) and **octal** form (`640`); and what **x on a directory** means.
3. **Explain the setuid bit, and what it does and does not do.** A real
   setuid-root program (`passwd`, `sudo`, `su`) runs with its owner's
   authority (and `sudo` sets the real uid too, so `sudo id` reports root).
   A setuid **script** does
   not: the kernel ignores the bit on a script. *zyBooks Ch 10.3 (optional),
   whose 10.3.1, "Typical domain changes in Unix", is this mechanism.*
4. **Audit a bench for setuid files.** `find -perm -4000`, and what to ask
   about each file it prints.
5. **Read an authentication log, and cross-reference it with a second.**
   `grep`, `cut`, `sort`, `comm`, and a one-line `awk` you will read aloud,
   to ask whether an entry in one log falls inside a window in the other.

Objective 5 is the one the Guild examines hardest. A log says which key was
shown at which door and when. What it says is not always the whole of what
happened, and a second book is the only way to find out what it leaves unsaid.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `id`, `groups`, `getent`, `ls`, `stat`,
`chmod`, `find`, `cut`, `sort`, `comm`, `grep`, `sed` and `awk`, plus `sudo`
for one short command. Every setup path in this course installs them.
Nothing needs a network.

Staging asks for the house keys **once**, and says what for before it asks.
After that, one command in Task 2 uses `sudo` again, in a box that says what
it does. If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-13
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-13
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-13
```

**P3 — Report for duty.** One command stages this week's bench: it lays the
registry's three papers under `~/enginehouse/registry/`. It asks for the
house keys **once** — it says so, and says what for, before it asks — and
does nothing else with them. Run it now, on Wednesday:

```sh
bash report-for-duty.sh
```

Expected — first the list of what the keys are for, then (after your
password, if `sudo` asks for it) the duty slip:

```
Before the registry can be staged, the house keys are wanted. They are
asked for once, for the whole of the following, and for nothing else:

  * Two papers are made over to uid 1849 (chown): the spare key
    .spare-key and the Warden's log auth-ledger.log. Nothing else is.
  * The spare key has its setuid bit set (chmod 4755), so that it lists
    as -rwsr-xr-x. It is a script that prints one line and exits; the
    kernel does not give a script anyone else's privileges. Nothing is
    compiled and nothing is started.
  * The porters' visitor book is laid down as yours; the room that holds
    all three, ~/enginehouse/registry/, is yours too. No root is needed
    for either of those.

One prompt covers all of it. sudo may ask for your password now, once,
and everything listed above happens inside that one window.


  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-13 :: bench staged and verified
  ------------------------------------------------------------------
   Registry:  ~/enginehouse/registry/   three papers, laid out for you

   Nothing is running this week. The registry is files, not a
   process: nothing to lose on `wsl --shutdown`, a reboot or closing
   every Ubuntu window. The work order shows you where to look.
   (bash report-for-duty.sh --reset removes the registry. The house
   roll stays -- later weeks are standing on it.)
  ------------------------------------------------------------------

```

On a bench that has never staged Week 6, Week 10 or Week 12, one more item
comes first in the list, **the roll** (one dormant entry restored to the
bench's list of accounts), and the roll office adds a note of its own as it
works. It will not ask you for anything. The number `1849` is that account's
uid; it owns two of this week's papers, and you will see it on your own
screen in Task 2.

One thing lands under `~/enginehouse/` that is yours to work in:
`registry/`, with three papers in it. Nothing else this week is staged.
Tasks 1, 2 and 4 also use a small folder of your own inside it,
`workbench/`, that you make yourself in Task 1.

**There is nothing to lose.** The registry is files, not a process: it
survives `wsl --shutdown`, a reboot and closing every Ubuntu window. If a
command ever finds the registry missing, run `bash report-for-duty.sh` again
to lay it down afresh. Re-staging puts the three papers back exactly as they
were and leaves your `workbench/` alone.

**Never run `report-for-duty.sh` with `sudo`.** The script asks for the
house keys itself, once, exactly when it needs them. Under `sudo` it would
stage **root's** home folder instead of yours, and nothing this week — not
the commands below, not the seals — would find it there. It refuses before
it touches anything, and says so.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds ten short
answers — A1 to A10 — that the seal checks read; the template says what
goes where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**What varies, and what does not.** Your screen will differ from this work
order in the places that are your bench's own: your user name and home
folder (written `you` here), your own uid and gid (`1000` on the bench these
were taken from), the groups you belong to, the free-text fifth field of
your `/etc/passwd` line, the mode a new file starts with (set by your
`umask`: `-rw-r--r--` here, `-rw-rw-r--` on some benches), every date and
time a listing prints (written `…`), and which stock setuid programs your
bench carries and in which order. What does **not** vary: root is uid 0, the
`s` that marks a setuid file, the registry's three papers and who owns them,
and every line of the two logs.

**A note on this week's shape.** Three sessions: **Monday's deck**, then
**Wednesday's and Friday's studios**, no break. Four tasks, four seals,
about two and a quarter hours at the terminal — more than the two studios
hold, so plan on some of it at home. Tasks 1 and 2 are Wednesday's, with
Task 3 begun. **Task 4 is Friday's work**: it ends with one command, and you
want to be at your bench when you type it. Claim each seal as soon as its
task is done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-13`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-13`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or a `syntax error near unexpected token`
>   from the script? The file picked up Windows line endings on the way
>   down. From the repo root: `git checkout -- .` and try again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. The script asks for the keys itself, once; run it
>   again without `sudo`.
> - The script says it cannot get root? Take it to your instructor rather
>   than working around it; the bench is left exactly as it was found.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again.

---

## Task 1 — Who you are, and what you may do *(~30 minutes → Seal M1)*

Every program the Engine runs, and every file it holds, belongs to someone.
Before you audit anyone else's, find out who you are.

**1. Ask.** Three questions, three short answers:

```sh
id
whoami
groups
```

Expected — `you` stands for your user name; your numbers and your groups
will differ, and the list is usually longer on a bench with more software on
it:

```
uid=1000(you) gid=1000(you) groups=1000(you),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),30(dip),46(plugdev),1001(docker)
you
you adm dialout cdrom floppy sudo dip plugdev docker
```

The Engine knows you by a **number**, not a name: your **uid**. `uid=1000`
is who you are; `(you)` is the name it goes by. `gid` is your **primary
group**, the group new files you make normally take. `groups=` lists every group
you are in, the primary first; the rest are your **supplementary groups**. The Engine asks
about your uid, your gid and these groups every time you open a file. Nothing
else about you counts.

One uid is special. **Root is uid 0**, and the Engine lets root do almost
anything. Keep that in mind for Task 2.

**2. Where the numbers come from.** A user is a line in `/etc/passwd`. You
read that file in Commission I and again in Week 12. Look at yours:

```sh
getent passwd "$USER"
```

Expected (the fifth field is free text; yours may be anything):

```
you:x:1000:1000:COMP-3100 Apprentice Enginewright:/home/you:/bin/bash
```

(`getent passwd` asks the bench's list of accounts, wherever it lives, and
prints it in `/etc/passwd`'s own format. On this bench the list is the file.)
Seven fields, separated by colons. Number them with a throwaway pipeline:

```sh
getent passwd "$USER" | tr ':' '\n' | cat -n
```

Expected:

```
     1	you
     2	x
     3	1000
     4	1000
     5	COMP-3100 Apprentice Enginewright
     6	/home/you
     7	/bin/bash
```

`tr ':' '\n'` turns each colon into a new line; `cat -n` numbers them.
Field 1 is the name and field 3 the **uid**. Field 4 is the **primary gid**.
Field 6 is the home folder, and field 7 the login shell. (Week 12's
`cut -d: -f7` took that last one for every account at once.) The `x` in
field 2 stands where a password once lived. The password itself is kept
elsewhere, in a file you may not read; you will see why in step 3. *zyBooks
Ch 10.2 (optional) is about how a system checks a user's password.*

And root's line, for the contrast:

```sh
getent passwd root
getent group "$(id -g)"
getent group sudo
```

Expected:

```
root:x:0:0:root:/root:/bin/bash
you:x:1000:
sudo:x:27:you
```

`/etc/group` has the same shape: a name, an `x`, the **gid**, and the list of
members. Your primary group often has nobody listed, because membership in it
comes from field 4 of your passwd line. The `sudo` group lists `you`: that
is why `sudo` will let you in, in Task 2.

**3. The ten characters.** Every `ls -l` line starts with ten characters.
Look at two files that matter:

```sh
ls -l /etc/passwd /etc/shadow
```

Expected:

```
-rw-r--r-- 1 root root … /etc/passwd
-rw-r----- 1 root shadow … /etc/shadow
```

Read the first one, triad by triad. The **first character** is the type: `-`
a regular file, `d` a directory, `l` a symbolic link (you have met all
three). The next nine are **three triads**, each `r`, `w` and `x` or a dash
where that right is absent:

```
- rw- r-- r--
│ │   │   └── other   (everybody else):  r--  may read
│ │   └────── group   (the file's group): r--  may read
│ └────────── owner   (the file's owner): rw-  may read and write
└──────────── type:    -  a regular file
```

The Engine reads only the **one** triad that applies to you: the owner's
if you are the owner, otherwise the group's if you are in the file's group,
otherwise other's. `/etc/passwd` is readable by everybody; it has to be,
because every program turns uids into names with it. `/etc/shadow`, the file
that holds the passwords, gives **other** nothing at all: the third triad is
`---`. Try to read it and see:

```sh
cat /etc/shadow
```

Expected:

```
cat: /etc/shadow: Permission denied
```

Two more words from that line. After the link count come the **owner** (`root`)
and the **group** (`root`, or `shadow`). The owner is the one number the Engine
trusts to change a file's mode, and root may change anything.

**Checkpoint (halfway).** Say, without looking: what a uid is and where its
name comes from, and how many rwx triads a mode string has and who each one
is about.

**4. Change a mode, on a file of your own.** Make yourself a small folder
and a file in it:

```sh
mkdir -p ~/enginehouse/registry/workbench
cd ~/enginehouse/registry/workbench
echo "a note for the register" > note.txt
ls -l note.txt
```

Expected (the first ten characters depend on your `umask`; `-rw-rw-r--` is
normal on some benches):

```
-rw-r--r-- 1 you you 24 … note.txt
```

`chmod` changes the mode, in two notations. The **octal** form gives each
triad a digit: read = 4, write = 2, execute = 1, and add them. `rw-` is
4+2 = 6; `r--` is 4; `---` is 0. So `600` is "owner read and write, nobody
else anything":

```sh
chmod 600 note.txt
ls -l note.txt
```

Expected:

```
-rw------- 1 you you 24 … note.txt
```

The **symbolic** form says who (`u` owner, `g` group, `o` other, `a` all),
then `+` to add or `-` to take away or `=` to set, then the rights. Give
the group read:

```sh
chmod g+r note.txt
ls -l note.txt
stat -c '%A %a' note.txt
```

Expected — `%A` is the ten characters and `%a` the octal, which `stat` can
print for you:

```
-rw-r----- 1 you you 24 … note.txt
-rw-r----- 640
```

Owner 6, group 4, other 0: the file is now at **640**. Say it in octal
instead, and the result is the same:

```sh
chmod 640 note.txt
stat -c '%A %a' note.txt
```

Expected:

```
-rw-r----- 640
```

Take away your own read and watch the Engine believe you:

```sh
chmod u-r note.txt
cat note.txt
```

Expected:

```
cat: note.txt: Permission denied
```

Even the owner is held to the owner's triad, and with no `r` in it, no
read. Put it back:

```sh
chmod u+r note.txt
cat note.txt
```

Expected:

```
a note for the register
```

**5. What `x` means on a directory.** On a file, `x` means "may be run as a
program". On a directory it means something else: **may be passed through**,
to reach what is inside by name. `r` on a directory means "may list the
names". They are not the same right. Make a folder with a paper in it and
take them apart:

```sh
mkdir vault
echo "the paper" > vault/paper.txt
chmod u=rw vault
ls vault
cat vault/paper.txt
```

Expected — with `r` and no `x`, you can see the name, and you cannot get to
the paper:

```
paper.txt
cat: vault/paper.txt: Permission denied
```

(On Ubuntu, `ls` is usually an alias for `ls --color=auto`. Run on a
terminal, it may also print an extra
`ls: cannot access 'vault/paper.txt': Permission denied` line, because it
tries to look at the file to colour its name. The extra line is harmless; the
`cat` is the one that matters.)

Now the other way round:

```sh
chmod u=x vault
ls vault
cat vault/paper.txt
```

Expected — with `x` and no `r`, you cannot list the folder, but you can
still reach a paper whose name you know:

```
ls: cannot open directory 'vault': Permission denied
the paper
```

Set it back, so nothing is left locked:

```sh
chmod 755 vault
ls -ld vault
```

Expected:

```
drwxr-xr-x 2 you you … vault
```

**6. File what you found.** Open `check/answers.txt`:

- **`A1:`** — your uid, then your primary gid, as `id` printed them (step 1).
  Two numbers, with a space between.
- **`A2:`** — the ten-character mode string of `note.txt` after it was at
  640 (step 4), then its octal mode.
- **`A3:`** — in `/etc/passwd`: the field number of the login shell, then the
  field number of the primary gid (step 2). Two numbers.

**Checkpoint.** Before the seal, you should be able to say, without looking:
what your uid is and where the Engine keeps the name that goes with it; how
to read `-rw-r-----` triad by triad and who each triad is about; what `640`
means digit by digit; and why a folder with `r` but no `x` and a folder with
`x` but no `r` behave differently.

**7. Claim the seal** — from `labs/week-13` (you are in `workbench/`, so
go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-13/check'
  ~~~ WAX SEAL of the Guild: F3647AD8 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-13/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 1** with
your `id` line, the numbered walk of your passwd line, and the three
`chmod` states of `note.txt` with the `ls -l` of each.

> **If you're lost, start here (Task 1).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-13`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m1` again.
> - `cd: /home/you/enginehouse/registry/workbench: No such file or directory`?
>   Make it: step 4's first line, `mkdir -p ~/enginehouse/registry/workbench` (the registry must be
>   staged first: P3).
> - `getent: command not found`? Read the file instead:
>   `grep "^$USER:" /etc/passwd`. Same line, same seven fields.
> - Step 4's `ls -l` printed `-rw-rw-r--`, not `-rw-r--r--`? Your `umask`
>   differs. Carry on: `chmod 600` sets every triad, whatever it was.
> - `chmod: cannot access 'note.txt'`? You are not in `~/enginehouse/registry/workbench`. `cd` to
>   it and run step 4's first lines again.
> - `cat note.txt` worked after `chmod u-r`? You are root, or the file is
>   not yours. Run `id`: root is uid 0, and root ignores the triads.
> - Seal says A2 is a different string? Run `chmod 640 note.txt` and copy
>   what `ls -l` prints, all ten characters, the dash included.
> - Seal says A3's numbers are the wrong way round? The login shell comes
>   first, the primary gid second.
> - Seal says there is no registry? `bash report-for-duty.sh` (P3) lays it
>   down; the seals will not work on a bench that never staged the week.

---

## Task 2 — The setuid bit, and what it does and does not do *(~35 minutes → Seal M2)*

Some programs have to do things their user is not allowed to do. `passwd`
lets you change your password, which means writing to `/etc/shadow`, a file
you just saw you may not even read. The Engine's answer is a mode bit with a
very odd meaning.

**1. A real one.** List three programs that ship with your bench:

```sh
ls -l /usr/bin/passwd /usr/bin/sudo /bin/su
```

Expected (sizes and dates differ from bench to bench, written `…`; the
first ten characters and the owner do not):

```
-rwsr-xr-x 1 root root … /bin/su
-rwsr-xr-x 1 root root … /usr/bin/passwd
-rwsr-xr-x 1 root root … /usr/bin/sudo
```

Look at the owner's triad: `rws`, where you expected `rwx`. That `s` is the
**setuid bit** showing through. The owner's `x` is still there (the file is
runnable) and the bit sits in the same place. A file with the bit set runs
**as its owner**, whoever started it. These three are owned by **root**
(uid 0), so while `passwd` runs, it holds root's authority, enough to write
`/etc/shadow`, and gives it back when it ends. `stat` can print the mode string and
the owner's name:

```sh
stat -c '%A  %U  %n' /usr/bin/passwd
```

Expected:

```
-rwsr-xr-x  root  /usr/bin/passwd
```

The octal form of `-rwsr-xr-x` is **4755**: the extra leading `4` is the
setuid bit, as `r` is 4 inside a triad. (This is what the book, in zyBooks
Ch 10.3.1 (optional), calls a **domain change**: the program's rights are
the owner's, for as long as it runs.)

**2. The effective uid.** Two uids matter while a program runs. The **real**
uid is who started it. The **effective** uid, or **euid**, is whose
authority it holds right now: the one the Engine checks. `id -u` prints your
euid. Ask it, then ask it again from under `sudo`, which is a setuid-root
program:

```sh
id -u
sudo id
```

Expected — your uid, then what `sudo id` prints:

```
1000
uid=0(root) gid=0(root) groups=0(root)
```

> **THE HOUSE KEYS, ONCE MORE — `sudo id`.**
> *What it does:* runs the ordinary command `id` as root and prints what it
> sees. It **changes nothing**.
> *The exact command, and no other:* `sudo id`
> *How it ends:* it prints and exits; nothing is left running. `sudo` may ask
> for your password, once.
> *Why:* so you can see a setuid-root program at work. `sudo` takes root's
> authority from its own setuid bit, sets both of its uids to 0, and then
> starts `id`. `id` is only `sudo`'s child and is not setuid itself; the
> `uid=` it prints is the real uid, which `sudo` has made 0 (there is no
> separate `euid=` because the two now agree). Root is uid 0.
> *`su` is a cousin:* it **becomes** another user, and needs *their*
> password. `sudo` runs **one** command under a policy, with *your* password.
> You do not need `su` this week. Do not try either on the account that
> owns the spare key: it has no password and no login shell, so `su` refuses
> it. Nothing this week asks you to act as it.

(`sudo -l` lists what `sudo` will let you run. Try it if you are curious;
nothing below needs it.)

Expected — the rules that apply to you; yours will differ:

```
Matching Defaults entries for you on …:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User you may run the following commands on …:
    (ALL : ALL) ALL
    (ALL) NOPASSWD: ALL
```

**3. Set the bit on a file of your own.** Go back to your folder and make a
script of your own that prints its euid:

```sh
cd ~/enginehouse/registry/workbench
printf '#!/bin/sh\nid -u\n' > probe.sh
chmod 755 probe.sh
ls -l probe.sh
```

Expected:

```
-rwxr-xr-x 1 you you 16 … probe.sh
```

`chmod u+s` sets the bit, and `u-s` takes it off:

```sh
chmod u+s probe.sh
ls -l probe.sh
stat -c '%A %a' probe.sh
./probe.sh
```

Expected:

```
-rwsr-xr-x 1 you you 16 … probe.sh
-rwsr-xr-x 4755
1000
```

The `s` appeared and the mode is 4755, but the script printed *your* euid,
as it always did. This file's owner is **you**, so "run as its owner" and
"run as you" are the same thing, and the bit has nothing to change. The bit
matters when the owner is someone else. Take it off again:

```sh
chmod u-s probe.sh
ls -l probe.sh
```

Expected:

```
-rwxr-xr-x 1 you you 16 … probe.sh
```

Leave nothing of yours setuid: the audit in step 4 counts every setuid file
under your home, `workbench/` included. This should print nothing at all:

```sh
find ~/enginehouse/registry/workbench -perm -4000
```

**Checkpoint (halfway).** Say, without looking: what the `s` replaced, which
uid a setuid program runs as, and why your own `probe.sh` showed no change.

**4. The audit: find every setuid file.** An auditor does not wait to be
told where a setuid file is. `find` can walk a tree and select files by
mode: `-perm -4000` means "has at least the 4000 bit", the setuid bit. Ask
it about your own home first:

```sh
find "$HOME" -perm -4000
```

Expected:

```
[ your bench prints each setuid file under your home here, one path a line ]
```

One path should come back, and it ends in the registry. (If `find` prints
more than one, or none, say so in your logbook; the seal reads whatever your
bench prints.) List the registry, owners as **numbers** (`-n`) and nothing
hidden (`-a`):

```sh
ls -lan ~/enginehouse/registry
```

Expected (`1000` is the bench user's uid on the bench these were taken from;
yours may differ):

```
total 36
drwxr-xr-x 3 1000 1000 4096 … .
drwxr-xr-x 5 1000 1000 4096 … ..
[ your bench prints the spare key's line here: ten characters, a number, a number ]
-rw-r--r-- 1 1849  100 14877 … auth-ledger.log
-rw-r--r-- 1 1000 1000  1430 … visitor-ledger-1851.txt
drwxr-xr-x 2 1000 1000  4096 … workbench
```

Three papers, your `workbench/`, and `.` and `..`. Two of the three papers have the same owner, a
number that is **not yours** and not root's: **1849**, group `100`. It is the
account you met owning fittings in Weeks 10 and 12. Find the `s`. The file
that carries it is the **spare key**, a name that begins with a dot, so a
plain `ls` would not show it. Write down its ten characters, and the number
that owns it.

**5. Run it.** The key is a short script. Read it first (a file you may read
is a file you may read), then run it, then ask for your euid:

```sh
cat ~/enginehouse/registry/.spare-key
```

Expected:

```
#!/bin/sh
# A spare key. Cut by no one the Warden knows; its owner on the roll is uid 1849.
echo "This key was never cut by the Warden."
exit 0
```

Four lines. It prints one sentence and ends. Now run it and ask:

```sh
~/enginehouse/registry/.spare-key
id -u
```

Expected — the sentence, then your own euid, unchanged:

```
This key was never cut by the Warden.
[ your euid, the number step 2 printed ]
```

The file is owned by another account and carries the setuid bit. The number
`id -u` printed is **yours**, and be clear what that number does and does not
show. `id -u` ran in your own shell *after* the key had finished, so it
would print your number whatever the key had done: a genuine setuid
program would leave the same line behind. It shows only that your shell is
as it was. What the key held *while it ran* is a separate fact, and the
number above cannot show it. Monday's slide did: a script with the setuid
bit, owned by another account, printing its own euid from inside as it ran,
and the number was the runner's, unchanged. The reason is the kernel's rule:
it **ignores the setuid bit on a script**. When it starts a `#!` script it
hands the file to an interpreter (`/bin/sh`), and does not let the file's
owner's authority ride along. (Letting it ride along would be too easy to
abuse, and the kernel does not.) So the spare key exists, carries the mark,
and gives the person who runs it exactly what that person already had.

You may not change it either: you are neither its owner nor root.

```sh
chmod u-s ~/enginehouse/registry/.spare-key
```

Expected:

```
chmod: changing permissions of '/home/you/enginehouse/registry/.spare-key': Operation not permitted
```

Write down what you saw: the key's mode and owner, the one sentence it
prints, and your euid before and after. It is a mode and a fact, not a
verdict. Whether a file like this ought to exist on a Guild bench at all is
what an audit asks next.

**6. File what you found.** In `check/answers.txt`:

- **`A4:`** — the spare key's ten-character mode string, as `ls -l` printed
  it (step 4), then the number of the uid that owns it.
- **`A5:`** — your euid as `id -u` printed it straight after you ran the key
  (step 5; it shows your shell, not the key's inside), then the uid `sudo id`
  printed for the one command (step 2: the number after `uid=`, the real uid
  `sudo` set to 0). Two numbers.

**Checkpoint.** You should be able to say what the `s` is and where it sits;
what the euid is and how it differs from the uid you log in with; why
`sudo id` says 0 and the spare key leaves you as you were; and what `find
-perm -4000` is asking for.

**7. Claim the seal** — from `labs/week-13` (you are not in it now, so go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-13/check'
  ~~~ WAX SEAL of the Guild: B3F1D4C2 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-13/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 2** with
the three stock programs' `ls -l` lines, `sudo id`, your `probe.sh`
before-and-after, the `find`, the registry listing, and the key run followed
by `id -u`.

> **If you're lost, start here (Task 2).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-13`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m2` again.
> - `find "$HOME" -perm -4000` printed nothing? The registry is not staged,
>   or you ran `--reset`. From `labs/week-13`: `bash report-for-duty.sh`.
> - `sudo: a password is required` and nothing to type it into? Run `sudo
>   id` in a terminal you are sitting at. If your bench has no `sudo`, take
>   it to studio: nothing here works around it.
> - `~/enginehouse/registry/.spare-key: command not found`? The key's name
>   begins with a dot and is easy to mistype. Press Tab after
>   `registry/.sp`.
> - `./probe.sh: Permission denied`? Step 3's `chmod 755` was skipped. Run
>   it, then try again.
> - Seal says A4's string has no `s`? You copied the string of an ordinary
>   executable. Run `ls -l` on the key itself: the `s` takes the owner's `x`
>   place.
> - Seal says A4 carries your own uid? The owner is the first number after
>   the link count in `ls -ln`, and it is not you.
> - Seal says A5 claims your euid changed? It did not. Run the key, then
>   `id -u`, and copy that number. The second number is `sudo id`'s.
> - Seal says the spare key is not as staged? `bash report-for-duty.sh`
>   rebuilds it.

---

## Task 3 — Read the Warden's log *(~35 minutes → Seal M3)*

Your work in this task is to read a log and write down what is there:
counts, keys, dates. Draw no conclusion. The Warden's registry log lives in
the registry:

```sh
cd ~/enginehouse/registry
```

**1. The shape of it.** Look at the first lines:

```sh
head -5 auth-ledger.log
```

Expected:

```
# The Warden's registry log -- one line per key shown at a Guild door.
# date weekday time door key event
1850-01-06 Mon 16:30 BOARD-ROOM key=clerk-01 PRESENT
1850-01-07 Tue 09:58 LODGE key=porter-03 PRESENT
1850-01-16 Thu 08:22 ENGINE-HALL key=enginewright-07 PRESENT
```

Two header lines begin with `#`; every other line is a record with six
words: a **date**, the **weekday**, a **time**, a **door**, a **key** (the
holder's number or station, written `key=…`) and an **event**. The dates
are written year-month-day, which has a convenient property: sorted as text,
they sort in time order. To count only the records, leave out the `#` lines:
`-v` inverts a match, `-c` counts.

```sh
grep -vc '^#' auth-ledger.log
```

Expected:

```
261
```

**2. Count by key, by door, by event.** `cut` takes a field from each line
(`-d' '` splits on spaces; `-f5` is the fifth). `sort | uniq -c` counts the
runs, as in Week 12, and `sort -rn` puts the biggest first:

```sh
grep -v '^#' auth-ledger.log | cut -d' ' -f5 | sort | uniq -c | sort -rn
```

Expected — one row for each key, with its count; your bench prints them:

```
[ your bench prints the tally here: a count, then key= and a holder ]
```

Read it: it is the first answer to "who comes to these doors". Now the doors:

```sh
grep -v '^#' auth-ledger.log | cut -d' ' -f4 | sort | uniq -c | sort -rn
```

Expected:

```
     45 BOARD-ROOM
     37 TUBE-SHOP
     29 COMPUTING-ROOM
     28 ENGINE-HALL
     27 WEST-DOOR
     24 REGISTRY
     22 READING-ROOM
     21 LODGE
     13 EAST-GALLERY
     10 EAST-DOOR
      5 ARCHIVE
```

And the events, the sixth word:

```sh
grep -v '^#' auth-ledger.log | cut -d' ' -f6 | sort | uniq -c
```

Expected:

```
[ your bench prints the tally here: a count, then an event ]
```

`PRESENT` is a key shown at a door. The other two words bracket a stretch of
time during which a door's session was held open. Read the tally; draw
nothing from it.

**3. One key, line by line.** The key written `key=1849` is the number you
saw owning two papers in Task 2. Count its lines, then read them:

```sh
grep -c 'key=1849' auth-ledger.log
```

Expected:

```
NN
```

Your bench prints a number there: write it down. It counts **every** line
with that key, whatever the last word is.

```sh
grep 'key=1849' auth-ledger.log
```

Expected — every line, in the order the log wrote them. The first two are:

```
1851-07-29 Wed 18:24 READING-ROOM key=1849 PRESENT
1851-08-07 Fri 18:33 READING-ROOM key=1849 PRESENT
[ … your bench prints every remaining line of that key here. Read them all. ]
```

Now only the lines whose event opens a session:

```sh
grep -c 'SESSION-OPEN' auth-ledger.log
grep 'SESSION-OPEN' auth-ledger.log
```

Expected:

```
[ your bench prints a count, then each opening line here: date, weekday,
  time, door, key and the event SESSION-OPEN ]
```

Copy these lines into your logbook exactly. Keep the order.

**Checkpoint (halfway).** Say, without looking: what the six words of a
record are, and why counting one key's lines is not the same as counting one
event.

**4. First and last.** Which dates does the log cover? Take the date field
of every record, sort it, and print the first line and the last (`sed -n
'1p;$p'`: print line 1, and the last line, `$`):

```sh
grep -v '^#' auth-ledger.log | cut -d' ' -f1 | sort | sed -n '1p;$p'
```

Expected:

```
[ your bench prints two dates here: the earliest, then the latest ]
```

**5. Every setuid file on the bench.** Step 4 of Task 2 searched your home.
An audit asks the whole machine. Start at the root of the filesystem, and
this time keep an eye on what `find` complains about, by sending its
complaints (descriptor 2) down the pipe and its results (descriptor 1) to
the sink. This is Week 12's `2>&1 >` order, again:

```sh
find / -xdev -perm -4000 -type f 2>&1 >/dev/null | head -3
```

Expected — a few of the directories `find` may not enter; yours name others:

```
find: ‘/etc/polkit-1/rules.d’: Permission denied
find: ‘/etc/credstore’: Permission denied
find: ‘/etc/credstore.encrypted’: Permission denied
```

`-xdev` keeps `find` on the one filesystem you started in. On Windows/WSL2,
`/` also reaches your whole Windows disk under `/mnt/c`, and a search
without `-xdev` can run for minutes; on the bench these were taken from it
took five. `-type f` asks for regular files only. Now throw the complaints
away with `2>/dev/null` and read the list:

```sh
find / -xdev -perm -4000 -type f 2>/dev/null | sort
```

Expected:

```
/home/you/…
/usr/bin/chfn
/usr/bin/chsh
…
/usr/bin/mount
…
/usr/bin/passwd
/usr/bin/su
/usr/bin/sudo
/usr/bin/umount
…
```

And how many:

```sh
find / -xdev -perm -4000 -type f 2>/dev/null | wc -l
```

Expected:

```
NN
```

The list above is the shape, trimmed with `…`. Your bench's list is its own: it varies with the software installed on it.
It is the list *your account can discover on this filesystem*: `2>/dev/null`
hides the complaints, it does not search the folders you were refused.
Most of what you see is the stock set, owned by root, from the packages
your bench carries. Go down it and ask of each file one question: who put
this here, and should it be setuid? That is what an audit is. For this task,
only write down what is there, and whether any of the paths is under your
home.

**6. File what you found.** In `check/answers.txt`:

- **`A6:`** — how many files `find "$HOME" -perm -4000` lists on your bench
  (Task 2 step 4), then the name of the one under `registry/`, as `ls`
  prints it.
- **`A7:`** — how many lines of the Warden's log carry `key=1849`, whatever
  their last word (step 3). One number.
- **`A8:`** — the earliest date in the log, then the latest (step 4), as the
  log writes them: year-month-day. Two dates.

**Checkpoint.** You should be able to say what a line of the log records
and what it does not; why the log's dates sort as text; the difference
between counting one key's lines and counting one event; and what `-xdev`
and `2>/dev/null` each keep out of your way.

**7. Claim the seal** — from `labs/week-13` (you are not in it now, so go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-13/check'
  ~~~ WAX SEAL of the Guild: 4411D53D ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-13/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 3** with
the tallies, the lines of `key=1849` in order, the two end dates, and the
whole-bench `find` with its count.

> **If you're lost, start here (Task 3).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-13`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m3` again.
> - `grep: auth-ledger.log: No such file or directory`? You are not in the
>   registry, or it is not staged. `cd ~/enginehouse/registry`, or from
>   `labs/week-13`: `bash report-for-duty.sh`.
> - The tally has fewer rows than you expected? `grep -v '^#'` leaves out
>   the header lines; make sure the quotes around `^#` are straight ones.
> - `find` has been running for minutes? You left out `-xdev`, and on WSL it
>   is walking your Windows disk. Press Ctrl-C and run the line as printed.
> - `find` printed a screenful of `Permission denied`? You left out
>   `2>/dev/null`. The list is still there, buried; run it again with it.
> - Seal says A7 counts only the openings (or only the `PRESENT` lines)?
>   A7 counts every line that carries the key: `grep -c 'key=1849'`.
> - Seal says A8's dates are not the log's? Take them from the sorted output
>   of step 4, not from the first line of the file: that one is a comment.
> - Seal says A6's number is not what `find` under your home lists? Run
>   `find "$HOME" -perm -4000 | wc -l`. The whole-bench count is step 5's.
>   If it lists `probe.sh` too, take the bit off: `chmod u-s` on it.

---

## Task 4 — Cross-reference the two books *(~35 minutes → Seal M4)*

Two books were kept at the Guild's doors: the Warden's log, which you just
read, and the porters' **visitor book**, which is paper, copied out, kept at
the lodge. They were written by different hands and neither knows what the
other says. A cross-reference asks of an entry in one: *does the other
book have a window around it?* Draw no conclusion. Count, and copy.

The visitor book is the third paper in the registry. Look at its shape:

```sh
cd ~/enginehouse/registry
head -4 visitor-ledger-1851.txt
```

Expected:

```
# Porters' lodge -- visitors to the reading room, copied from the paper book.
# date weekday in time out time visitor
1851-07-01 Wed in 16:07 out 18:08 …
1851-07-03 Fri in 17:26 out 18:13 …
```

(The last word on each line is the visitor's name, written as the porters
wrote it. No seal reads it, and every command below leaves that field
out.) Each line is a **documented visit**: a date, a weekday, an arrival
(`in`) and a departure (`out`). A visit is a **window** on that day, from
the arrival time to the departure time.

**1. The days first.** The cheapest cross-reference is by day: which days
does the log open a session on, and which days does the book have a visit
on? `sort -u` keeps one copy of each; `comm` compares two sorted files and
prints in three columns the lines only in the first, only in the second and
in both. `-12` hides columns 1 and 2, leaving what is **in both**; `-23`
hides 2 and 3, leaving what is **only in the first**:

```sh
grep 'SESSION-OPEN' ~/enginehouse/registry/auth-ledger.log | cut -d' ' -f1 | sort -u > ~/enginehouse/registry/workbench/open-days.txt
grep -v '^#' ~/enginehouse/registry/visitor-ledger-1851.txt | cut -d' ' -f1 | sort -u > ~/enginehouse/registry/workbench/visit-days.txt
wc -l ~/enginehouse/registry/workbench/open-days.txt ~/enginehouse/registry/workbench/visit-days.txt
comm -12 ~/enginehouse/registry/workbench/open-days.txt ~/enginehouse/registry/workbench/visit-days.txt
comm -23 ~/enginehouse/registry/workbench/open-days.txt ~/enginehouse/registry/workbench/visit-days.txt
```

Expected:

```
[ your bench prints the two line counts and their total, then the days
  that are in both files, then the days that are only in the first.
  The last of these may print nothing at all; that is a result too. ]
```

A day in both files is only the same *day*. It does not say the opening
fell between the arrival and the departure. Step 2 does.

**2. Make the windows visible.** Turn the book into two marks per visit,
`IN` at the arrival and `OUT` at the departure, and the openings into one
mark each, `SEEN`. Every line becomes `date time MARK`, which sorts as text
into time order (a date, then a 24-hour time, both padded with zeros). `sed
's/$/ IN/'` adds a word to the end of each line. `cut -f1,4` takes the
date and the arrival; `-f1,6` the date and the departure:

```sh
grep -v '^#' ~/enginehouse/registry/visitor-ledger-1851.txt | cut -d' ' -f1,4 | sed 's/$/ IN/'  > ~/enginehouse/registry/workbench/marks.txt
grep -v '^#' ~/enginehouse/registry/visitor-ledger-1851.txt | cut -d' ' -f1,6 | sed 's/$/ OUT/' >> ~/enginehouse/registry/workbench/marks.txt
grep 'SESSION-OPEN' ~/enginehouse/registry/auth-ledger.log | cut -d' ' -f1,3 | sed 's/$/ SEEN/' > ~/enginehouse/registry/workbench/opens.txt
wc -l ~/enginehouse/registry/workbench/marks.txt ~/enginehouse/registry/workbench/opens.txt
```

(`>` starts `marks.txt`; the second `>>` adds to it: Week 12's difference.)
Expected — two lines per visit, one per opening:

```
[ your bench prints the line counts here: marks.txt, opens.txt, a total ]
```

**3. Sort them together and look.** `sort` takes more than one file. Put the
marks and the openings in one list, in time order, and show each opening
with the line above it and the line below it (`grep -B1 -A1`):

```sh
sort ~/enginehouse/registry/workbench/marks.txt ~/enginehouse/registry/workbench/opens.txt | grep -B1 -A1 SEEN
```

Expected:

```
[ your bench prints the sorted listing here. For each opening, read the
  line above it and the line below it. Copy the first eleven lines into
  your logbook. ]
```

Read it as a picture. A `SEEN` that sits between an `IN` above and an `OUT`
below, on the same day, is an opening that falls **inside a documented
visit**. A `SEEN` with something else above or below it does not.

**Checkpoint (halfway).** Say, without looking: what an `IN` and an `OUT`
mark, why a day in both books is not yet a window, and what you are about to
ask the `awk` to count.

**4. Count them.** Eyes are slow. A small `awk` program can walk the sorted
list and count. Read it aloud once before you run it: it keeps a switch
`i`; an `IN` line turns the switch **on**, an `OUT` line turns it **off**,
and every `SEEN` line seen while the switch is on is counted in `n`. At the
end it prints `n`:

```sh
sort ~/enginehouse/registry/workbench/marks.txt ~/enginehouse/registry/workbench/opens.txt | awk '$3=="IN"{i=1} $3=="OUT"{i=0} $3=="SEEN"&&i{n++} END{print n+0}'
```

Expected:

```
[ your bench prints one number here ]
```

(`$3` is the third word of the line, the mark. The program prints `0` if
nothing was counted, because of `n+0`.) That number is your A9: how many of
the log's session openings fall inside a documented visit. Compare it with
the number of openings in Task 3 step 3. Write both down.

**5. Ask the same of another key.** A cross-reference is worth little if it
is only run once. Run the same test on a different key: the one at the top
of Task 3's tally, the key that appears most often in the log. Write its
lines as `date time SEEN`, then sort them in with the same marks and run the
same program:

```sh
grep 'key=apprentice-master' ~/enginehouse/registry/auth-ledger.log | cut -d' ' -f1,3 | sed 's/$/ SEEN/' > ~/enginehouse/registry/workbench/master.txt
wc -l < ~/enginehouse/registry/workbench/master.txt
sort ~/enginehouse/registry/workbench/marks.txt ~/enginehouse/registry/workbench/master.txt | awk '$3=="IN"{i=1} $3=="OUT"{i=0} $3=="SEEN"&&i{n++} END{print n+0}'
```

Expected — first a count of that key's lines (it is not zero), then the
count of those that fall inside a visit:

```
[ your bench prints two numbers here, one per line ]
```

Look at the first number. A count from the second pipeline means
nothing unless the first number says the key was there to be counted. That
is why you printed both. To see for yourself how the key's lines sit among
the windows, look at the middle of September in the sorted list:

```sh
sort ~/enginehouse/registry/workbench/marks.txt ~/enginehouse/registry/workbench/master.txt | grep '^1851-09-1'
```

Expected:

```
[ your bench prints that stretch of the sorted list here: for each day, the
  marks and any lines of the key ]
```

**6. File what you found.** If you file your answers from a second
terminal, or an editor that takes over this one, that is fine — but come
back to **this** terminal afterwards: step 8 is the last command of the lab,
typed here. In `check/answers.txt`:

- **`A9:`** — how many of the log's session openings fall inside a documented
  visit (step 4). One number.
- **`A10:`** — how many times the key shown most often in the log falls
  inside a documented visit (step 5, the second number). One number.

**Checkpoint.** You should be able to say what a window is and how the sorted
list shows one; why a day in both books is not yet a window; what the `awk`
switch is doing line by line; and why a count by itself wants a second number
beside it.

**7. Claim the seal** — from `labs/week-13` (you are not in it now, so go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m4
```

Expected:

```
make: Entering directory '.../labs/week-13/check'
  ~~~ WAX SEAL of the Guild: 318D62BA ~~~
  (Paste this seal into your logbook under Milestone 4.)
make: Leaving directory '.../labs/week-13/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 4** with
both counts and how you got each, the `comm` output, the first eleven lines
of the sorted listing, and the line count of the second key.

> **If you're lost, start here (Task 4).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-13`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m4` again.
> - `No such file or directory` on `~/enginehouse/registry/workbench/…`? Make the folder: `mkdir
>   -p ~/enginehouse/registry/workbench`.
> - `sort: cannot read: ~/enginehouse/registry/workbench/marks.txt`? Step 2 was not run in this
>   terminal, or you ran `--reset` since. Run step 2 again from the
>   registry.
> - `marks.txt` has half the lines it should? Step 2's second line wants
>   `>>` (two arrows) so it adds to the file. Run both lines again,
>   starting with the single `>`.
> - The `awk` line printed nothing, or an error? Copy it again as one line.
>   The single quotes hold the whole program, so no line of it may be broken.
> - Your two counts disagree with a neighbour's? The log and the book are
>   the same on every bench. Compare the sorted listings line by line.
> - Seal says A9 counts every line of that key? A9 counts only the openings
>   (step 4's `SEEN` lines), not every line of the key.
> - Seal says A10 is how many times that key appears at all? A10 is the
>   second number of step 5, not the first.
> - Seal says A10 is not right yet? Read the windows
>   again, in the sorted list: a line counts only if its day is a visit day
>   *and* its time sits after that day's `IN` and before its `OUT`.

**8. The closing command.** You have filed your answers and claimed M4. One
command left. If you opened an editor or a second terminal to fill
`answers.txt`, come back to this one — this is the last command of the lab.
From anywhere:

```sh
cd ~/enginehouse/registry/workbench && sort marks.txt opens.txt | awk '$3=="IN"{i=1} $3=="OUT"{i=0} $3=="SEEN"{t++; if(i)n++} END{print "sessions opened: " t+0 "; inside a documented visit: " n+0}'
```

```
[ your bench prints a line here ]
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 13 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The `ls -lan` of the registry, all three papers with their owners.
- The spare key's four lines, from `cat`, and what it printed when you ran
  it, with your `id -u` straight after.
- The log's lines of `key=1849`, in order, as `grep` printed them.
- The first eleven lines of Task 4 step 3's sorted listing.

Three questions to write toward, none of which has an answer in this work
order:

1. The spare key lists as setuid, yet running it changed nothing about who
   you were. What did it grant, then? What would you want to know before
   deciding whether a file like it belongs on a Guild bench?
2. The Warden's log records which key was shown at which door and when. What
   does that let you say about who was at the door, and what does it leave
   unsaid? What would the porters' book add, and what would it still leave
   unsaid?
3. What would you want to know next, and which command might show it?

Write a plain account of what the registry holds and what the two books
record. The notebook is marked on being kept honestly and quoting exactly,
never on drawing the cleverest conclusion — least of all about people.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the registry's.

1. In a paragraph: explain to someone who has never used a terminal why
   `passwd` can change a file its user may not even read, and why a script
   with the very same mark on it can't. Use **uid**, **effective uid**,
   **setuid bit** and **mode** correctly at least once each. *zyBooks Ch
   10.3 (optional).*
2. In two or three sentences: a log can say which key was shown at a door,
   and not whose hand held it. What would you add to the door, or to the
   log, so that it could say more? What would you give up for it? (There is
   no answer key.)

## Turn it in

Due **Sunday, 15 November, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted
   in, what it means. M1 wants your `id`, the numbered passwd walk and the
   three `chmod` states of `note.txt`; M2 wants the stock setuid programs,
   `sudo id`, your own `probe.sh` before and after, the `find`, the
   registry listing, and the key run with your euid beside it — **the
   graded centre of the week is the reason the kernel gives for the key
   granting nothing, and an honest word on what `id -u` afterwards can and
   cannot show**; M3 wants the tallies, the lines of `key=1849` in order, the two
   end dates and the whole-bench `find`; M4 wants both counts and how you
   got each, the `comm` output, the first eleven lines of the sorted listing,
   and the line count of the second key — written down **as counts and
   quotations, with nothing drawn**. Plus both reflection prompts and the
   time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 13 entry.

Upload both files to the Week 13 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**When your paperwork is in,** you may stand the bench down. From
`labs/week-13`:

```sh
bash report-for-duty.sh --reset
```

It needs no `sudo`: the papers sit in a folder you own, and a folder's owner
may remove what is in it. It removes the whole registry: the three papers
**and your `workbench/`**, with everything you made in it. Copy out anything
you want to keep first. Every other week's papers stay exactly where they
are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday, 17
November**. Hand it in on Sunday.

How the tasks cover the five objectives: Task 1 is objectives 1 and 2;
Task 2 is objectives 3 and 4 (the setuid bit, then the audit of your home);
Task 3 is objectives 4 and 5 (the whole bench, then the Warden's log); Task
4 is objective 5 at work. The reflections cover them in your own words.

**Also on this week's docket.**

- **No required reading this week.** zyBooks **Ch 10** (security) is
  optional; 10.2 (user authentication) and 10.3 (access control) are the
  sections nearest this week's work.
- **Commission V — *The Exchange Audit*** (zyBooks 12.4, "A Good Sport") is
  assigned today, **Monday, 9 November**.
- **Commission IV — *The Revision Registry*** (zyBooks 12.5, "Simple
  Versioning System") is due **Friday, 20 November, 11:59 pm, in zyBooks**
  — not Canvas. The cover is at
  [`commissions/04-the-revision-registry.md`](../../commissions/04-the-revision-registry.md).

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FOUR. THREE SESSIONS. NO BREAK.`
> `THE LOG RECORDS THE KEY. THE LODGE RECORDS THE VISITORS. THIS PORTER FILES BOTH.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap. Everything here is reading and
looking, on your own files.

- **Octal and symbolic, both ways.** `stat -c '%a %A' somefile` prints the
  same mode in both notations. Try `chmod 4755` and `chmod u+s,a+x` on a
  scratch file of your own and compare. Also `chmod 4644`, which gives an
  `S` in capitals: the setuid bit is set on a file with no owner `x`, and
  `ls` says so with the capital letter.
- **`umask`.** Type `umask`. It is the set of rights a new file is *not*
  given: why your `note.txt` started at 644 (or 664) and not 666. `umask -S`
  says it in letters.
- **setgid on a directory.** The setgid bit (`g+s`) on a **folder** makes
  new files inside it take the folder's group, not their maker's: how a team
  folder keeps one group. It shows as an `s` in the group triad.
- **The sticky bit and `/tmp`.** `ls -ld /tmp` prints `drwxrwxrwt`: the
  final `t` is the **sticky bit**. Anyone may make a file in `/tmp` (`/tmp`'s
  mode grants everyone `w` and `x`), but only the file's owner, the folder's owner
  or root may remove or rename it. Week 12's FIFO rules touched
  this one.
- **More than the bits.** `getfacl somefile` shows an **access control
  list**, finer-grained than three triads, if your bench has `getfacl`.
  And `man 7 capabilities` names the pieces root's authority is cut into,
  so a program can hold one without holding all. Read the names; there is no
  need to use them.
- **`sudo -l` and the sudoers rules.** `sudo -l` prints what you may run,
  and as whom. The policy it reads is `/etc/sudoers`, which only root may
  open, and which `visudo` checks before it saves.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what the log says. Then ask the other book."*
