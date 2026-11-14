# WORK ORDER No. 1851-14 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 16 November 1851 — three weeks to the Exhibition |
| **Due** | **Sunday, 22 November, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The telegraph office reports two things it cannot account for. A
transmission is queued on the exchange for the Exhibition, and nobody at the
office queued it. And something on the exchange is **listening**: a line held
open, waiting for replies, that nobody at the office remembers installing.

Before you go looking for it, learn how the Engine keeps its lines: the
numbered doors called **ports**, the difference between a program that waits
at a door and one that knocks on it, and the table the Engine keeps of every
door that is open. Then audit: list every listener on your bench, account for
each one, find the one nobody installed, and read what it is waiting on. A
procedure for staying a queued transmission is filed beside the queue. If the
queue should be stayed, stay it by that procedure and no other way.

Destroy nothing. Write down what is there. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Programs on one machine talk to programs on another, and to each other, by
**network connections**. This week is about seeing them: which programs on
your machine are waiting for a connection, who started each one, who may
reach it, and how to tell the ones that should be there from the one that
should not. Everything you run this week runs on **your own machine**, and
every connection you make stays inside it.

The fiction is set dressing and the commands are the course; **no task here
requires story knowledge.** There is no required reading this week. zyBooks
**Ch 11** (distributed systems) is optional; its section **11.2** defines the
three words the week rests on, and they are quoted below where you first
need them. By the time you hand this in you will be able to:

1. **Read the Engine's table of listeners.** `ss -tln`, column by column:
   the State, the **local address and port**, the **peer**. What a **port**
   is, and what a **socket** is.
2. **Listen, and connect.** Open a listener of your own with `nc -l`,
   connect to it from a second terminal, and watch the table change from
   **LISTEN** to **ESTABLISHED** and back to nothing. **Client** and
   **server**, and the **ephemeral** ports the Engine hands out to clients.
3. **Tell who may reach a listener.** **Loopback** (`127.0.0.1`, this
   machine only) against **all interfaces** (`0.0.0.0`); the port ranges;
   `/etc/services`, the bench's list of port numbers and the services that
   normally use them.
4. **Audit every listener, and find its owner.** `ss -tlnp` as yourself and
   under `sudo`, and `netstat -tlnp` beside it, the older tool: why a process
   column can be blank, and what root sees that you do not. `ps -o uid` for
   the account a process runs as.
5. **Read what a listener is waiting on, and stop it by the book.** Count,
   read, and follow a written procedure that moves papers and destroys none.

Objective 4 is the one the Guild examines hardest. A table that says
*something is listening* is not yet an account of *what* is listening, or
whose it is, or whether it ought to be there. An audit is the work of
answering those three questions for every row.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `ss`, `nc`, `ps`, `ls`, `head`, `cat`,
`grep`, `wc` and `mv`, which every setup path in this course installs, and
one more tool, **`netstat`**, which some benches lack. Install it now, once:

```sh
sudo apt install -y net-tools
```

(*A Good Sport*, the commission due 4 December, runs `netstat` too.) If that
line fails, carry on: everything `netstat` shows this week, `ss` shows as
well, and no seal needs `netstat`. Nothing this week needs a network
connection to anywhere else.

Staging asks for the house keys **once**, and says what for before it
asks. After that, Task 2 uses `sudo` twice more, each time in a box that
says what it does. If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-14
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-14
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-14
```

**P3 — Report for duty.** One command stages this week's bench: it lays the
exchange under `~/enginehouse/exchange/` and starts what is listening there.
It asks for the house keys **once** — it says so, and says what for, before
it asks — and does nothing else with them. Run it now, on Wednesday:

```sh
bash report-for-duty.sh
```

Expected — first the list of what the keys are for, then (after your
password, if `sudo` asks for it) the duty slip:

```
Before the exchange can be staged, the house keys are wanted. They are
asked for once, for the whole of the following, and for nothing else:

  * The queue's papers. They are made over to uid 1849. Their
    folder, and everything else in the exchange, stays yours.
  * The listener. It is launched as a transient unit named 'aether-listener-1000'
    (systemd-run), takes port 1851 on 127.0.0.1 -- this machine only --
    then drops itself to uid 1849 and stands. systemd keeps it
    alive past this shell.
  * One look at the port's owner (only root may see another account's
    process there), to confirm it is the listener just launched.

One prompt covers all of it. sudo may ask for your password now, once,
and everything listed above happens inside that one window.


  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-14 :: bench staged and verified
  ------------------------------------------------------------------
   Exchange:  ~/enginehouse/exchange/   a transmission is queued here

   Something on this machine is listening that you did not start.
   It can be reached from this machine only. The work order shows
   you how to find it, and how to ask it what it is waiting for.

   It is a living process, not a file: it does NOT survive
   `wsl --shutdown`, a reboot, or (on WSL) closing every Ubuntu
   window. Re-run this script to stage it afresh -- that rebuilds
   the exchange with its queue full, and sweeps away anything you
   did there before.
   (bash report-for-duty.sh --reset closes the exchange. The house
   roll stays -- it belongs to the course.)
  ------------------------------------------------------------------

```

The `1000` in the unit's name is your own uid, so yours may differ. On a
bench that has never staged Week 6, 10, 12 or 13, one more item comes first
in the list, **the roll** (one dormant entry restored to the bench's list of
accounts), and the roll office adds a note of its own as it works. It will
not ask you for anything. If you have staged before, an item **the old
exchange** appears too. If `netstat` is not yet installed, the script ends
with a note saying so:

```
report-for-duty: note -- netstat is not on this bench. This week and the
  A Good Sport commission both use it. Install it once with:
    sudo apt install -y net-tools
```

One thing lands under `~/enginehouse/` that is yours to work in:
`exchange/`, with a queue, a tray called `held/` (empty), and a procedure.
(A second, `exchange-works/`, holds the machinery. You will not need to look
in it.)

What listens on the exchange is a **living process, not a file**: it does
not survive `wsl --shutdown` or a reboot, and on WSL, **closing every Ubuntu
window** can stop it too. If Task 2's or Task 3's commands find nothing
listening when you come back, run `bash report-for-duty.sh` again to stage
it afresh. **Re-staging refills the queue and sweeps away anything you did
in `exchange/`** — so if it happens after Task 4, do Task 4 again.

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
order in the places that are your bench's own: your user name (written `you`
here), your uid (`1000` on the bench these were taken from), **process ids**
(`pid=…`), the port you choose in Task 1 and the port the Engine hands your
client, the range in `ip_local_port_range`, **the rows that are your bench's
own housekeeping** (Task 2 step 2 says what they are on WSL; a Multipass or
a native Linux bench shows its own set), and every date and time a listing
prints (written `…`). What does **not** vary: the listener nobody started,
its port and address and owner, and every paper in the exchange.

**A note on this week's shape.** Three sessions: **Monday's deck**, then
**Wednesday's and Friday's studios**. Four tasks, four seals, about two and
a quarter hours at the terminal — more than the two studios hold, so plan
on some of it at home. Tasks 1 and 2 are Wednesday's, with Task 3 begun.
**Task 4 is Friday's work**: it ends with one command, and you want to be at
your bench when you type it. Task 1 wants **two terminals open side by
side**; on Windows Terminal, a second Ubuntu tab is enough. This is the
last work order before the break: it is due Sunday, before the Engine
rests. Plan to be done before you travel.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-14`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-14`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or a `syntax error near unexpected token`
>   from the script? The file picked up Windows line endings on the way
>   down. From the repo root: `git checkout -- .` and try again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. The script asks for the keys itself, once; run it
>   again without `sudo`.
> - `report-for-duty: TCP port 1851 on this machine is already taken`?
>   Something else on your bench holds that port. Nothing has been staged.
>   Take the line it tells you to run to your instructor.
> - `report-for-duty: gcc not found`? Your bench has lost a tool. Run the
>   *"a tool is missing"* fix in `setup/getting-started.md`
>   (Troubleshooting), then run the script again.
> - The script says it cannot get root? Take it to your instructor rather
>   than working around it; the bench is left exactly as it was found.
> - `sudo apt install -y net-tools` fails? Carry on without it: every
>   `netstat` step below has an `ss` step beside it.

---

## Task 1 — A port of your own *(~30 minutes → Seal M1)*

Before you audit what is listening on your bench, open a listener of your
own and watch the Engine's table change as you use it.

**1. The table.** Ask the Engine which programs are waiting for a
connection:

```sh
ss -tln
```

Expected — on a staged WSL bench; yours may have more rows, or different
ones, above the last:

```
State  Recv-Q Send-Q  Local Address:Port Peer Address:PortProcess
LISTEN 0      4096       127.0.0.54:53        0.0.0.0:*          
LISTEN 0      1000   10.255.255.254:53        0.0.0.0:*          
LISTEN 0      4096    127.0.0.53%lo:53        0.0.0.0:*          
LISTEN 0      8           127.0.0.1:1851      0.0.0.0:*          
```

`ss` lists **sockets**. The three letters ask for three things: `-t` only
**TCP** sockets (TCP is the kind of connection that carries a stream of
bytes, in order, with delivery checked; its cousin **UDP** sends separate
messages with no such promise, and `-u` would list those instead); `-l` only
the ones that are **listening**; `-n` print **numbers**, not names. Read the
last row column by column:

```
LISTEN   0  8   127.0.0.1:1851   0.0.0.0:*
│        │  │   │         │      └── Peer Address:Port   anyone, any port: no one is connected yet
│        │  │   │         └───────── the port:            1851
│        │  │   └─────────────────── the local address:   127.0.0.1
│        └──┴─────────────────────── Recv-Q, Send-Q:      ignore them this week
└─────────────────────────────────── State: LISTEN, waiting for someone to connect
```

A **port** is a number, 1 to 65535. In the book's words it is *"an integer
assigned to a process by the OS for the purpose of communication"* (zyBooks
11.2, optional). An address says which machine; the port says which program
on it. Put an address and a port together and you have one end of a
conversation, a **socket**: *"a communication point of the form <IP, p>"*
(11.2 again). `ss` prints a socket as `address:port`. (`netstat`, the older
tool, calls the two address columns **Local Address** and **Foreign
Address**, the words the Sport spec uses. `ss` says **Peer**.)

So the last row says: some program on this machine holds the socket
`127.0.0.1:1851` and is waiting there. The `Process` column, which would say
which program, is blank. You will come back to that row in Task 2.

**2. Where clients' ports come from.** A program that *waits* for
connections picks its port, so that others know where to knock. A program
that *knocks* does not care which port it knocks from, and the Engine hands
it one from a range kept for the purpose, the **ephemeral** ports
("short-lived": each lasts one conversation). Ask for the range:

```sh
cat /proc/sys/net/ipv4/ip_local_port_range
```

Expected — two numbers, the lowest and the highest. These are from the bench
these pages were taken from; yours may differ:

```
43255	47350
```

The Sport spec says it plainly: on Linux, ephemeral ports are given a number
of **32768 or higher**, and the numbers below 32768 are kept for the
machine's own services. Your bench's range sits at or above that line. A
port of your own, opened for an afternoon, belongs up there too, and never
below it.

**3. Open a listener of your own.** Choose a port: any number from **32768
to 65535** that nothing on your bench is using. The bench these were taken
from used `47450`. Put your number in a shell variable, so every command
below can be typed exactly as printed, then check it is free:

```sh
P=47450
ss -tln | grep -w "$P"
```

Expected — nothing at all. Nothing printed means nothing holds that port.
(If a row comes back, choose another number and try again.)

Now `nc` ("netcat"), the simplest client and server there is. `nc -l`
**listens** on an address and port and prints whatever arrives. In
**terminal A**:

```sh
nc -l 127.0.0.1 "$P"
```

Expected — nothing; the cursor waits. `nc` is a **server** now: a program
that waits for others to come to it. Leave it waiting.

Open **terminal B** beside it. A new terminal is a new shell, which does not
know your `P`, so set it again (your own number, not necessarily this one),
then look at the table with one more letter, `-p`, for **process**:

```sh
P=47450
ss -tlnp
```

Expected (the pid is your bench's own):

```
State  Recv-Q Send-Q  Local Address:Port  Peer Address:PortProcess                      
LISTEN 0      1000   10.255.255.254:53         0.0.0.0:*                                
LISTEN 0      4096       127.0.0.54:53         0.0.0.0:*                                
LISTEN 0      1           127.0.0.1:47450      0.0.0.0:*    users:(("nc",pid=3005,fd=3))
LISTEN 0      8           127.0.0.1:1851       0.0.0.0:*                                
LISTEN 0      4096    127.0.0.53%lo:53         0.0.0.0:*                                
```

Your listener is there, `127.0.0.1:47450`, and **its Process column is
filled in**: the program `nc`, its pid, and its descriptor number (`fd=3`,
Week 12's file descriptors: a socket is opened, read and written like a
file). It is yours, so `ss` may tell you. Look at the row below it. The
Process column there is still blank.

`netstat` says the same in its own layout. If you installed it (P1):

```sh
netstat -tlnp
```

Expected:

```
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 10.255.255.254:53       0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:47450         0.0.0.0:*               LISTEN      3005/nc             
tcp        0      0 127.0.0.1:1851          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
```

Read the first two lines: `netstat` says outright that it is leaving some
programs out. A `-` in the **PID/Program name** column means `netstat` did
not identify the program: here, because it is not yours. (This is the header the Sport spec shows, word for word.)

**Checkpoint (halfway).** Say, without looking: what a port is and what a
socket is; what `-t`, `-l`, `-n` and `-p` each ask `ss` for; and why your
own listener's row names its program when the row below it does not.

**4. Connect.** Still in **terminal B**, be the **client**, the program that
goes to the server:

```sh
nc 127.0.0.1 "$P"
```

The cursor waits again. Type a line and press Enter:

```
hello
```

Expected — in **terminal A**, the line arrives:

```
hello
```

Two programs, one on each side of a connection: the **client** knocked, the
**server** answered the door. That is the arrangement the book calls
**client-server**, and it notes that *"indirect communication using ports is
the norm"* (11.2).

**5. Watch the connection in the table.** You want to look at the table
without ending the client, so pause it: in **terminal B**, press **Ctrl-Z**.
Bash says the job is **Stopped** and gives you your prompt back. A stopped
process is frozen, not gone, and its connection stays open. Now:

```sh
ss -tn | grep -w "$P"
```

(`-l` is gone: this asks for connections, not listeners.) Expected — the
ports on your bench will differ:

```
ESTAB 0      0          127.0.0.1:47450    127.0.0.1:44411       
ESTAB 0      0          127.0.0.1:44411    127.0.0.1:47450       
```

**Two rows for one connection**, because a connection has two ends and both
of them are on this machine. One is the server's end: local
`127.0.0.1:47450`, the port you chose, and its peer `127.0.0.1:44411`. The
other is the client's end, the other way round. (`ss` may list them in
either order.) Where did `44411` come
from? You never chose it. The Engine handed it to the client from the
ephemeral range of step 2: `44411` lies between `43255` and `47350`. The
State is `ESTAB`, short for **established**: a connection in use. `netstat`
spells the word out:

```sh
netstat -tn | grep -w "$P"
```

Expected:

```
tcp        0      0 127.0.0.1:47450         127.0.0.1:44411         ESTABLISHED
tcp        0      0 127.0.0.1:44411         127.0.0.1:47450         ESTABLISHED
```

**Now end it.** Bring the client back with `fg`, then press **Ctrl-C**.
Terminal A's `nc` ends with it: a server that `nc -l` started serves one
connection and stops. Then, in either terminal:

```sh
ss -tln | grep -w "$P"
ss -tan | grep -w "$P"
```

Expected — the first prints nothing: your listener has left the table.
The second (`-a`, **all** sockets, listening or not) still shows a trace of
the connection:

```
TIME-WAIT 0      0           127.0.0.1:44411     127.0.0.1:47450       
```

**TIME-WAIT** is a closed connection that the Engine keeps on its books for
about a minute, so that a late, stray packet from the old conversation is
not mistaken for part of a new one. Run the line again in a minute and it is
gone. (You will see rows like it all week, every time you connect to
anything. They are the Sport spec's **ongoing connections**: anything not in
the LISTEN state.)

**6. File what you found.** Open `check/answers.txt`:

- **`A1:`** — the port your own `nc -l` listened on (step 3). One number.
- **`A2:`** — the word `ss -tn` printed in the State column while the client
  was connected (step 5). One word.

**Checkpoint.** Before the seal, you should be able to say, without looking:
what a port, a socket, a client and a server are, with your own `nc` as the
example of each; why the client's port was a number you never chose; why one
connection made two rows; and what `LISTEN`, `ESTAB` and `TIME-WAIT` each
mean.

**7. Claim the seal** — from `labs/week-14`:

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-14/check'
  ~~~ WAX SEAL of the Guild: BCC92809 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-14/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 1** with
the `ss -tln` row of your own listener, its `ss -tlnp` row with the process
named, the two `ESTAB` rows, and the `TIME-WAIT` row, each with one sentence
saying what it shows.

> **If you're lost, start here (Task 1).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-14`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m1` again.
> - `ss -tln | grep -w "$P"` printed nothing, but so does everything after
>   it? `P` is not set in this terminal. Run `echo "$P"`; if it prints an
>   empty line, set it again: `P=` and your number, no spaces.
> - `nc: Address already in use`? Something holds that port. Choose another
>   number at 32768 or above, check it with `ss`, and start again.
> - The client in terminal B waits, but nothing reaches terminal A? The two
>   terminals have different numbers in `P`. Run `echo "$P"` in both.
> - Pressing Ctrl-C in terminal B ended the client but you never saw the
>   `ESTAB` rows? Start the server in A again, connect from B again, then
>   **Ctrl-Z** (not Ctrl-C) before the `ss` line.
> - `fg` says `no such job`? The client has already ended. Nothing to undo:
>   carry on from "Now end it".
> - `netstat: command not found`? P1's install line, or carry on with `ss`.
> - Seal says A1 is below 32768? Choose a port at 32768 or above and run
>   the steps again: a low number is where a machine keeps its services.
> - Seal says there is no exchange? `bash report-for-duty.sh` (P3) stages
>   it; the seals will not work on a bench that never staged the week.

---

## Task 2 — Audit every listener *(~35 minutes → Seal M2)*

An audit lists **every** listener on the bench and accounts for each one:
what it is, who started it, who can reach it, and whether it ought to be
there. Start with what you can see as yourself.

**1. As yourself.** Close any `nc` still running from Task 1. Then:

```sh
ss -tlnp
```

Expected:

```
State  Recv-Q Send-Q  Local Address:Port Peer Address:PortProcess
LISTEN 0      4096       127.0.0.54:53        0.0.0.0:*          
LISTEN 0      1000   10.255.255.254:53        0.0.0.0:*          
LISTEN 0      4096    127.0.0.53%lo:53        0.0.0.0:*          
LISTEN 0      8           127.0.0.1:1851      0.0.0.0:*          
```

You asked for the process (`-p`), and every Process column is blank. In
Task 1 your own listener's was filled in. The rule: **`ss` names the program
behind a socket only if the program is yours, or if you are root.** You can
see *that* something listens before you can see *what*. That is the whole
reason an audit needs the house keys.

**2. Account for each row, as far as you can.** Two questions of every row:
**who can reach it**, from the address; and **what it is**, from the port.

*The address.* `127.0.0.1` is **loopback**: the machine's address for
itself. A listener bound to it can be reached **from this machine only**;
nothing on the network can see it. In fact every address that begins `127.`
is loopback, so `127.0.0.53` and `127.0.0.54` are this machine too (`%lo`
after an address names the loopback interface, `lo`). The opposite is
`0.0.0.0`, which `ss` may print as `*`, and its newer-style twin `[::]`:
**all interfaces**, every address this machine has, so a listener there can
be reached by any machine that can reach this one. The Sport spec puts it the
same way: `0.0.0.0` is all IP addresses for this machine; `127.0.0.1` only
this machine. One more kind is on this bench: `10.255.255.254`, an address
this machine has that is neither. There is no `0.0.0.0` row on this bench.
(The Sport spec calls a low-port listener on `127.0.0.1` an **internal**
service and any other low-port listener **external**; by its rule even the
`127.0.0.53` rows count as external. That is the spec's line, not a
judgment of the rows.)

*The port.* Some port numbers are agreed on by everybody, so that a client
knows where to knock: 22 for remote logins, 53 for the **domain name
service** (the service that turns names like `harding.edu` into
addresses), 80 for web servers. Ports 0 to 1023 are called **well-known**;
1024 to 49151 are **registered**; above that, the dynamic range. (*A Good
Sport* draws its own line lower, at 32768, as Task 1 showed: the two lists
disagree, and this week follows the Sport's.) The bench
keeps the agreed list in a plain file, `/etc/services`. Ask it about the two
ports in your table:

```sh
grep -w '53/tcp' /etc/services
grep -w '1851/tcp' /etc/services
```

Expected — the first finds a line; the second finds nothing at all:

```
domain		53/tcp				# Domain Name Server
```

> **On WSL: the bench's own housekeeping.** The three rows on port 53 are
> your machine's **name service**, and they are expected. `127.0.0.53` and
> `127.0.0.54` belong to `systemd-resolved`, Ubuntu's name-service program,
> which you will see named in step 3. `10.255.255.254:53` is WSL's own name
> service, which lives on the Windows side, outside this Linux's table of
> processes, so **no command will name a program for it, not even under
> `sudo`**. It is not a second mystery. Write it down as what it is.
> A Multipass or a native Linux bench shows its own set of housekeeping
> rows, not these: account for yours the same way, by address and by
> `/etc/services`.

That leaves one row that no list accounts for: a port with no entry in
`/etc/services`, below the line where your own programs belong, held by a
program you cannot see. Note its address and its port.

**Checkpoint (halfway).** Say, without looking: what loopback means and who
can reach a loopback listener; what `0.0.0.0` would mean instead; and which
rows on your bench you have accounted for, and how.

**3. With the house keys.** Root may see every process.

> **THE HOUSE KEYS, ONCE MORE — `sudo ss -tlnp`.**
> *What it does:* runs the same `ss` as root, so the Process column is
> filled in for every listener, not just yours. It **changes nothing**.
> *The exact command, and no other:* `sudo ss -tlnp`
> *How it ends:* it prints and exits; nothing is left running. `sudo` may ask
> for your password, once.
> *Why:* an audit must know what program holds each port, and only root may
> see another account's process.

```sh
sudo ss -tlnp
```

Expected (pids are your bench's own):

```
State  Recv-Q Send-Q  Local Address:Port Peer Address:PortProcess                                   
LISTEN 0      4096       127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=118,fd=17))
LISTEN 0      1000   10.255.255.254:53        0.0.0.0:*                                             
LISTEN 0      4096    127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=118,fd=15))
LISTEN 0      8           127.0.0.1:1851      0.0.0.0:*    users:(("aether-listener",pid=558,fd=4)) 
```

Every row but one now has a program. The two `127.0.0.5x` rows are
`systemd-resolved`, as step 2 said (the name is cut to fifteen letters: the
kernel keeps no more than that of a program's name). `10.255.255.254` stays
blank even to root, as step 2 said it would. And the port with no entry in
`/etc/services` is held by a program called **`aether-listener`**. You did
not start it. Write down its pid from your own screen.

**4. The older tool.** `netstat` sees the same table. As yourself, with
nothing of yours listening:

```sh
netstat -tlnp
```

Expected:

```
(No info could be read for "-p": geteuid()=1000 but you should be root.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 10.255.255.254:53       0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:1851          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
```

A different complaint from Task 1's, for the same reason: with no listener
of yours to show, `netstat` says it could read no process information at
all, because your effective uid (`geteuid()`, Week 13's euid) is not root's.
With the keys:

> **THE HOUSE KEYS, ONE LAST TIME — `sudo netstat -tlnp`.** Same as the box
> above: root's view, prints and exits, **changes nothing**. Skip it if you
> did not install `netstat`; step 3 already showed you everything it shows.

```sh
sudo netstat -tlnp
```

Expected:

```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 10.255.255.254:53       0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      111/systemd-resolve 
tcp        0      0 127.0.0.1:1851          0.0.0.0:*               LISTEN      2882/aether-listene 
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      111/systemd-resolve 
```

Same rows, same answer, one difference worth seeing: `netstat` fits the pid
and the name into one 19-character column, so with a long pid the name comes
out cut, here as `aether-listene` (with a short pid it may fit). `ss` prints
it in full. When the two tools disagree on a name, trust the one that did not cut
it.

**5. Whose is it?** A program runs **as** an account, Week 13's uid. `ps`
will tell you which, and for the uid it needs no keys. Put the listener's pid
from step 3 where `NNN` is:

```sh
ps -o uid,pid,comm -p NNN
```

Expected:

```
[ your bench prints a header line, then one line: the uid the listener
  runs as, its pid, and its name ]
```

(`-o` chooses the columns: `uid` the account as a number, `pid`, and `comm`
the program's name.) Write down the uid, as a number. It is not yours and
not root's.

Now you can answer the audit's questions for the last row: *what* (a
program called `aether-listener`), *who* (the uid you just read), *who can
reach it* (the address), and *what it is for* (no entry in
`/etc/services`). Whether it ought to be there is Task 3's question. Draw no
conclusion yet.

**6. File what you found.** In `check/answers.txt`:

- **`A3:`** — the address the listener nobody on this bench started is bound
  to, as `ss` prints it in front of the colon (steps 1 and 3).
- **`A4:`** — its port (step 3). One number.
- **`A5:`** — the uid it runs as, as `ps -o uid` printed it (step 5). One
  number — not its pid.

**Checkpoint.** You should be able to say why your own `ss -tlnp` showed no
program on that row and root's did; what the address tells you about who
can reach it; how you accounted for every other row on your bench, the ones
on port 53 included; and the difference between a uid and a pid.

**7. Claim the seal** — from `labs/week-14`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-14/check'
  ~~~ WAX SEAL of the Guild: 10F21572 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-14/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 2** with
your audit: **every** row of your `sudo ss -tlnp`, each with its address,
port, program, and one line saying who can reach it and how you accounted
for it; then the `ps` line for the one you could not account for.

> **If you're lost, start here (Task 2).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-14`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m2` again.
> - No row on port 1851 at all, in any listing? What listens there does not
>   survive `wsl --shutdown`, a reboot, or closing every Ubuntu window. From
>   `labs/week-14`: `bash report-for-duty.sh`, then start this task again.
> - `sudo ss -tlnp` names no program on the 1851 row either? You left out
>   `sudo`, or the `-p`. Copy the line again.
> - Your bench shows rows this work order does not? Account for them the
>   same way: the address, then `/etc/services`, then root's view.
> - `ps` printed only the header? The pid has changed (re-staging starts the
>   listener afresh). Read it again from `sudo ss -tlnp`.
> - Seal says A3 is open on all addresses? Look again at the 1851 row: the
>   address in front of the colon is not `0.0.0.0`.
> - Seal says A3 belongs to a different row? A3 wants the address of the
>   1851 row, not one of the port-53 rows.
> - Seal says A5 is a pid? The uid is the first column of the `ps` line,
>   under `UID`.

---

## Task 3 — Read the queue *(~35 minutes → Seal M3)*

Your work in this task is to read what the listener is waiting on and write
down what is there: counts, dates, words. Draw no conclusion.

**1. The exchange.** Owners as **numbers** (`-n`):

```sh
ls -ln ~/enginehouse/exchange
```

Expected:

```
total 12
-rw-r--r-- 1 1000 1000 1115 … cancellation-procedure.txt
drwxr-xr-x 2 1000 1000 4096 … held
drwxr-xr-x 2 1000 1000 4096 … outbound-queue
```

Three things, all yours: a procedure, an empty tray called `held`, and a
queue. Look in the queue:

```sh
ls -ln ~/enginehouse/exchange/outbound-queue
```

Expected:

```
[ your bench prints the queue here: one line per dispatch, with its owner
  and group as numbers ]
```

The folder is yours. The papers in it are not: their owner is a number you
have met before, in Task 2.

**2. Count them.**

```sh
ls ~/enginehouse/exchange/outbound-queue/dispatch-*.txt | wc -l
```

Expected:

```
[ your bench prints one number here ]
```

**3. Read them.** Every dispatch begins with a header line. Print the first
line of each (`-q`: no file names between them):

```sh
head -qn 1 ~/enginehouse/exchange/outbound-queue/dispatch-*.txt
```

Expected:

```
[ your bench prints one header line per dispatch here ]
```

Read one dispatch through:

```sh
cat ~/enginehouse/exchange/outbound-queue/dispatch-01.txt
```

Expected:

```
[ your bench prints the whole dispatch here. Read all of it. ]
```

Write down what each header says: its number, its route, and the date it is
held until, exactly as written. The date is the one written *inside* the
paper, after `HOLD UNTIL`; it is not the date `ls -ln` prints, which is only
when your bench staged the file.

**Checkpoint (halfway).** Say, without looking: how many papers are queued,
whose they are, and what one of them says, in a sentence, without
judging it.

**4. Read the procedure.** It is filed beside the queue, and you will carry
it out in Task 4, so read every line now:

```sh
cat ~/enginehouse/exchange/cancellation-procedure.txt
```

Expected:

```
[ your bench prints the procedure here. Read all of it. ]
```

**5. Ask the port.** A listener answers whoever connects. Be its client, as
you were your own in Task 1:

```sh
nc -d 127.0.0.1 1851
```

Expected:

```
[ your bench prints one line here: EXCHANGE LISTENER, then two counts ]
```

(`-d` tells `nc` not to read the keyboard. Without it, `nc` prints the line
and then sits waiting for you to type something to send back; with it, the
listener says its line, hangs up, and `nc` ends.) Your `nc` was handed an
ephemeral port, as in Task 1, and if you run `ss -tan` now you will see a
`TIME-WAIT` row on port 1851 for every time you have asked. Write down both
counts the line gives, in order.

**6. File what you found.** In `check/answers.txt`:

- **`A6:`** — how many dispatches were waiting in `outbound-queue/`
  (step 2). One number.
- **`A7:`** — the date the dispatches are held until, as their first line
  prints it (step 3).
- **`A8:`** — the port's answer (step 5): dispatches queued, then
  acknowledgments received. Two numbers.

**Checkpoint.** You should be able to say what is queued, whose papers they
are, what they are held until, what the procedure tells an apprentice to
do, and what the listener reports, all as quotations and counts.

**7. Claim the seal** — from `labs/week-14`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-14/check'
  ~~~ WAX SEAL of the Guild: 4F300D3E ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-14/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 3** with
the queue's `ls -ln`, the count, every header line, and the port's line.

> **If you're lost, start here (Task 3).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-14`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m3` again.
> - `ls: cannot access '.../outbound-queue/dispatch-*.txt'`? The queue is
>   empty: you have already moved them (Task 4), or the exchange is not
>   staged. Look in `held/`, or from `labs/week-14`:
>   `bash report-for-duty.sh`.
> - `nc -d 127.0.0.1 1851` prints nothing (and, on WSL, does not
>   return: press Ctrl-C)? Nothing is answering on that port: the listener does not survive
>   a shutdown. From `labs/week-14`: `bash report-for-duty.sh`.
> - `nc` printed the line and then waited? You left out the `-d`. Press
>   Ctrl-C and run it again with it.
> - Seal says A7 is the date `ls` prints? A7 is written inside the dispatch,
>   after `HOLD UNTIL`.
> - Seal says A7 is the procedure's date? That one says when the procedure
>   was entered. A7 is the dispatches' own.
> - Seal says A8 says nothing was queued? A8 is the line from **before** you
>   moved anything. Ask the port again only after Task 4.

---

## Task 4 — Cancel it, by the book *(~35 minutes → Seal M4)*

The procedure you read in Task 3 says how a queued transmission is stayed.
Do what it says, in its order, and nothing else. Nothing in it deletes
anything. Neither do you.

**1. Count the dispatches waiting** (the procedure's first step):

```sh
ls ~/enginehouse/exchange/outbound-queue/dispatch-*.txt | wc -l
```

Expected:

```
[ your bench prints one number here: the same as Task 3 step 2 ]
```

**2. Move every dispatch, unaltered, into the held tray:**

```sh
mv ~/enginehouse/exchange/outbound-queue/dispatch-*.txt ~/enginehouse/exchange/held/
ls -ln ~/enginehouse/exchange/outbound-queue ~/enginehouse/exchange/held
```

Expected — `mv` prints nothing; then:

```
[ your bench prints outbound-queue/, now empty, then held/ with one line
  per dispatch, each with the same owner it had in the queue ]
```

Why did that need no keys, when the papers are not yours? Moving a file
changes the **folders** it is listed in, not the file. You own both folders,
and a folder's owner may add and remove names in it (Week 13's triads, on a
directory). The papers themselves are untouched: same owner, same words.
That is why the procedure says **move**: a **copy** (`cp`) would be a new
paper, written by you, and owned by you. Do not copy and do not delete.

**3. File the order.** The procedure wants a cancellation order, giving the
count and the date, one to a line. From the exchange:

```sh
cd ~/enginehouse/exchange
printf 'dispatches held: %s\ndate: %s\n' "$(ls held/dispatch-*.txt | wc -l)" "$(date +%F)" > cancellation-order
cat cancellation-order
```

Expected:

```
[ your bench prints two lines here: the count, then today's date as your
  bench writes it, year-month-day ]
```

(`printf` fills each `%s` with the next word after its pattern: the count of
what is in `held/`, then today's date. The count must be the number step 1
printed: the papers in `held/` are those very ones.)

**Checkpoint (halfway).** Say, without looking: what `mv` changed and what it
did not; why it needed no `sudo`; and what a copy would have got wrong.

**4. Ask the port again:**

```sh
nc -d 127.0.0.1 1851
```

Expected:

```
EXCHANGE LISTENER -- dispatches queued: 0 -- acknowledgments received: 0
```

The listener counts the dispatches in the queue every time someone asks.
There are none left to count.

**5. Count the held tray:**

```sh
ls ~/enginehouse/exchange/held/dispatch-*.txt | wc -l
```

Expected:

```
[ your bench prints one number here ]
```

**6. File what you found.** If you file your answers from a second terminal,
or an editor that takes over this one, that is fine — but come back to
**this** terminal afterwards: step 8 is the last command of the lab, typed
here. In `check/answers.txt`:

- **`A9:`** — dispatches queued, as the port said it after you stayed the
  queue (step 4). One number.
- **`A10:`** — how many papers are in `held/` now (step 5). One number.

**Checkpoint.** You should be able to say what each step of the procedure
did on your bench and which command did it; what the listener counts and
when; and why nothing you did this task can be lost.

**7. Claim the seal** — from `labs/week-14` (you are in `exchange/` now, so
go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m4
```

Expected:

```
make: Entering directory '.../labs/week-14/check'
  ~~~ WAX SEAL of the Guild: 31AD856D ~~~
  (Paste this seal into your logbook under Milestone 4.)
make: Leaving directory '.../labs/week-14/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 4** with
each step of the procedure beside the command that carried it out, the
`ls -ln` of both folders after the move, your cancellation order, and the
port's line after.

> **If you're lost, start here (Task 4).**
> - `make: *** check: No such file or directory`? You are not in
>   `labs/week-14`. Run the P2 `cd` line that matches your setup, then
>   `make -C check m4` again.
> - `mv: cannot stat '.../outbound-queue/dispatch-*.txt'`? There is nothing
>   left in the queue to move: you already moved them. `ls -ln` both
>   folders and carry on.
> - Seal says held/ holds fewer papers than the queue did? Some were
>   deleted, not moved, and a deleted paper is not held. From
>   `labs/week-14`: `bash report-for-duty.sh` stages the exchange afresh
>   with its queue full; then do this task again from step 1, with `mv`.
> - Seal says the papers in held/ are not the queue's own? They were copied
>   and the originals removed. Re-stage, as above, and use `mv`.
> - Seal says no cancellation order is filed, or it has no count or no
>   date? Run step 3 again from `~/enginehouse/exchange`.
> - Seal says the listener did not answer? It did not survive a shutdown.
>   Re-staging starts it afresh **and refills the queue**: do this task
>   again from step 1.
> - Seal says A9 is the count from before? A9 is what the port says now.

**8. The closing command.** You have filed your answers and claimed M4. One
command left. If you opened an editor or a second terminal to fill
`answers.txt`, come back to this one — this is the last command of the lab.
From anywhere:

```sh
tail -n 1 ~/enginehouse/exchange/cancellation-procedure.txt
```

```
[ your bench prints a line here ]
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 14 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The 1851 row of `sudo ss -tlnp`, and the `ps -o uid,pid,comm` line for
  its pid.
- Every dispatch's header line, as `head` printed them.
- The port's line before your cancel and after it.
- The `ls -ln` of `held/` after your cancel.

Three questions to write toward, none of which has an answer in this work
order:

1. The listener can be reached from this machine only, and it answers
   anyone who asks with one line. What does that tell you about what it was
   built to do, and what does it leave unsaid?
2. The queue could be stayed by anyone who read the paper filed beside it,
   and staying it destroyed nothing. What would you want to know about
   whoever filed that paper there?
3. What would you want to know next, and which of your earlier weeks'
   notes might show it?

Write a plain account of what the exchange holds and what you did to it.
The notebook is marked on being kept honestly and quoting exactly, never on
drawing the cleverest conclusion — least of all about people.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the exchange's.

1. In a paragraph: explain to someone who has never used a terminal how
   your own `nc` listener and the listener nobody started each looked in
   `ss`, and why one showed its program to you and the other did not. Use
   **port**, **socket**, **loopback** and **process** correctly at least
   once each. *zyBooks Ch 11.2 (optional).*
2. In two or three sentences: an audit found a listener you could reach
   only from this machine. Would you rather it had been bound to
   `0.0.0.0`, or not running at all? What would you ask before deciding
   which listeners a machine should keep? (There is no answer key.)

## Turn it in

Due **Sunday, 22 November, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted
   in, what it means. M1 wants your own listener's rows in all three states,
   each explained; **M2 wants the audit — every listener on your bench
   accounted for by address, port and program, the one you could not
   account for traced to its uid — which is the graded centre of the
   week**; M3 wants the queue's listing, the count, the headers and the
   port's line; M4 wants each step of the procedure with the command that
   carried it out, both folders after, your order and the port's line after
   — written down **as counts and quotations, with nothing drawn**. Plus
   both reflection prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 14 entry.

Upload both files to the Week 14 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**When your paperwork is in,** you may stand the bench down. From
`labs/week-14`:

```sh
bash report-for-duty.sh --reset
```

Expected:

```
Closing the exchange. One step, via sudo: it stands down the listener
(uid 1849), which is not yours and will not yield to you. sudo
may ask for your password now.
Bench struck. The listener is stood down, and the exchange with it.
~/enginehouse still holds other weeks' papers; they were not touched.
The house roll is untouched -- that entry belongs to the course and not
to this week. (bash ../lib/archive-roll.sh teardown removes it, once, at
the end of term.)
(Run this script again, without --reset, to stage the week afresh.)
```

It removes the whole exchange, the held tray and your order with it. Copy
out anything you want to keep first. Every other week's papers stay exactly
where they are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday, 24
November** — inside the break. Hand it in on Sunday, before you travel.

How the tasks cover the five objectives: Task 1 is objectives 1 and 2 (on
a listener of your own); Task 2 is objectives 3 and 4 (every listener on the
bench); Task 3 is objective 5's reading; Task 4 is objective 5's procedure.
The reflections cover them in your own words.

**Also on this week's docket.**

- **No required reading this week.** zyBooks **Ch 11** (distributed
  systems) is optional; **11.2** (message-based process communication)
  defines port, socket and client-server, the section nearest this week's
  work.
- **Commission IV — *The Exchange Audit*** (zyBooks 12.4, "A Good Sport") is
  due **Friday, 4 December, 11:59 pm, in zyBooks** — not Canvas. It runs
  `netstat -anpt`: install `net-tools` (P1) if you have not. A finished
  `sport.py` may be pointed at your own bench this week for interest; no
  task needs it. The cover is at
  [`commissions/05-the-exchange-audit.md`](../../commissions/05-the-exchange-audit.md).
- **Thanksgiving, 23–27 November: no class, and nothing is due.**
- **Your sealed verdict is due Monday, 30 November, at the start of
  class.** The brief is below.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM -- BEFORE THE ENGINE RESTS.`
> `WAX SEALS: FOUR. THREE SESSIONS. THEN THE BREAK.`
> `THE EXCHANGE: LISTENED TO, AND ANSWERED. THIS PORTER COUNTED THE LINES.`
> — punched chit, affixed by Porter Brassfeather

## The sealed verdict — due Monday 30 November, start of class

*Not graded in this work order. Read it now, so the break is yours to
write it.*

All season you have kept case notes: what you found each week, the command
that showed it, and what you made of it. Your **sealed verdict** turns
those notes into one conclusion about the season's case: a short written
conclusion, citing at least three findings from your own case notes.

**The form.**

- **One page**, handwritten or printed.
- In a **sealed envelope**, with **your name on the outside**.
- Handed in at the **start of class on Monday, 30 November**.

**What it must contain.**

1. **The claim:** name who, in **one sentence**.
2. **Means, motive and opportunity:** how they could have done it, why they
   would have, and when and where they could have.
3. **At least three findings**, each cited by **week and case-notes
   entry**: what you found, in which week, and where in your notes it is
   written down.

**How it is graded.** It is graded as a normal task of Week 15's work
order, and it is graded on **your chain of reasoning and the notes you
cite**, not on landing the answer. A careful verdict that reasons well from
its evidence and is wrong earns more than a lucky guess with nothing behind
it.

**Late or absent.** The usual late rule applies: a flat 20%, and nothing
accepted more than two calendar days after the deadline. For the verdict
that means **before Wednesday 2 December's class begins**, which is when
the reveal begins. If you cannot be there on the thirtieth, hand it in
sealed, or email it to the instructor, before then.

There are no hints here, and none will be given in studio. Write from your
notes.

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap. Everything here is looking, on your
own machine.

- **Your own `sport.py`.** If you have finished *A Good Sport*, run it on a
  staged bench and see which drawer it puts each row in. Compare it with
  your Task 2 audit. Where do the spec's words (internal, external, user
  application) and your own account differ?
- **UDP.** `ss -uln` lists UDP sockets, the message kind. There is no
  LISTEN state for UDP; ask yourself why a protocol with no connections has
  no word for waiting for one.
- **IPv6.** `ss -tln6` and `ss -tln4` split the table by address family.
  `::1` is IPv6's loopback, as `127.0.0.1` is IPv4's.
- **Only the live ones.** `ss -tan state established` shows only
  connections in use, and `ss -tan state time-wait` only the ones the
  Engine is keeping on its books. Ask the exchange's port twice, then run
  the second line, and watch the rows go after about a minute.
- **Fewer columns.** `ss -tlnH` drops the header, ready for a pipeline;
  `ss -tln 'sport = :1851'` filters inside `ss` itself instead of with
  `grep`.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Find out what is listening. Then find out who asked it to."*
