# COMP 3100 — Operating Systems

**Fall 2026 · Harding University**
*"The Case Files of the Grand Analytical Engine"*

| | |
|---|---|
| **Course** | COMP 3100 — Operating Systems · 3 credit hours |
| **Term** | Fall 2026 · Aug 17 – Dec 11 |
| **Meets** | Monday / Wednesday / Friday · 1:00 – 1:50 pm · Science 200 |
| **Prerequisites** | COMP 2450; and COMP 2680 **or** (EENG 2400 and EENG 2400L) |
| **Instructor** | Joe Faith, D.Eng. · Science 209 · <jfaith@harding.edu> |
| **Office hours** | Mon / Wed / Fri 9–10 am, 12–1 pm, 2–3 pm · Tue 9 am – 12 pm · Thu 8–9:30 am |
| **Course site** | **Canvas** — announcements, assignments, grades, and the zyBooks and student-repo links |
| **Textbook** | zyBooks — enrollment link and join code in Canvas |
| **Submission** | Weekly work orders → **Canvas** · The five commissions → **zyBooks** |
| **Final exam** | Finals week, Dec 7–11 — slot set by the registrar, announced in class and posted in Canvas |
| **Dates** | [`schedule.md`](schedule.md) — the authoritative list of every due date |

---

## Course description

**From the University catalog.** The historical development and current
functions of operating systems. Topics include process management,
memory management, concurrency, deadlock, and security. Linux is used as
a reference operating system.

*Prerequisites:* COMP 2450; COMP 2680 or EENG 2400 and EENG 2400L.
*Credit hours:* 3.

**What that looks like in practice.**
For most programmers the operating system stays a black box — the thing
that mysteriously makes a program slow, or kills it, or won't let it
open a file. This is the semester that box comes open, and with it the
Linux system you will spend the rest of your career standing on. We
cover what an operating system is and why it exists; system calls and
the boundary between user and kernel mode; processes and how they are
created, scheduled, and reaped; threads, data races, and
synchronization; deadlock; memory management and virtual memory; and
file systems. Weeks 12 through 14 are applied: interprocess
communication with pipes and FIFOs, users and permissions and `setuid`,
and the ports and sockets a machine exposes to the network.

The course is hands-on. Every week you work on a real Ubuntu 24.04
system, with real tools — `strace`, `gdb`, `valgrind`, `pstree`, `ss`,
`mount` — on problems that have real symptoms. All of it aims at one
very practical ability: to walk up to a machine that is misbehaving and
find out why, instead of guessing. You will also complete five
programming projects in Python, assigned and graded through zyBooks,
which are the department's standard COMP 3100 projects.

## A word about the story

This semester is played as a story. You are apprentice engineers in
Brassbridge, England, 1851, and the city-sized mechanical computer you
are learning to keep — the Grand Analytical Engine — has been behaving
oddly. Monday's slides open with an episode. The weekly lab arrives on
Guild letterhead as a **work order**. The running notebook you keep all
semester is called your **case notes**, because that is what a lab
notebook is when the lab has a mystery in it.

Here is the honest part, and it is the important part: **your grade is
never gated on the story.** Every task in every work order is stated in
plain language, with the exact commands and the output you should expect,
and is completely doable by someone with zero interest in Victorian
England. The concepts are ordinary operating-systems concepts. The tools
are the tools working engineers use. The exams are ordinary exams. The
story is there because it makes the tools worth picking up — if you would
rather simply learn Linux, you will learn Linux, and you will earn
exactly the same grade for exactly the same work. And if you do fall for
it, there is a mystery running underneath the whole semester, and the
skills you build each week are what let you solve it.

## Learning outcomes

By the end of this course, you will be able to:

1. **Trace a program's system calls with `strace` and interpret the
   table.** *(Week 2)*
2. **Implement process creation with `fork`/`exec`/`wait`.** *(Week 3)*
3. **Explain scheduling policy effects and set priorities with
   `nice`/`chrt`.** *(Week 4)*
4. **Diagnose a data race and repair it with a mutex.** *(Weeks 5–6)*
5. **Diagnose deadlock's four conditions in a live system.** *(Week 7)*
6. **Measure and fix a memory leak with `valgrind`.** *(Week 9)*
7. **Navigate and repair file-system structures, including mounts and
   permissions.** *(Weeks 11 and 13)*
8. **Audit a system's processes, ports, and logs to explain an
   incident.** *(Weeks 12–14)*

Every work order restates the outcomes it serves, in plain language, at
the top of the page. The pedagogy is never hidden behind the theme.

## Texts and materials

**Required — zyBooks.** Everything you need to enroll — the link, the
course code, and the join code — is posted in Canvas, so that there is
exactly one place to look and it is never out of date. Sign up in the
first week; the Week 1 reading is due before class on Wednesday,
August 19.

- **Chapters 1–8 are required reading**, on the schedule in
  [`schedule.md`](schedule.md). Participation and challenge activities in
  these chapters are 10% of your grade.
- **Chapters 9–11 are optional enrichment.** Weeks 12–14 draw on their
  topics, but the lectures and work orders are self-contained; nothing
  from Ch 9–11 is required reading and nothing there is graded.
- **Chapter 12 holds the five projects** you will submit as the Guild
  Commissions.

**Optional — Andrew S. Tanenbaum, *Modern Operating Systems*, 4th
edition.** An excellent reference and a good read if a topic grabs you.
Nothing is ever assigned from it, and you do not need to buy it.

**Required — a computer that can reach the internet.** No purchase
beyond the zyBook is required. If your own machine cannot run the course
environment, the browser-based path below needs nothing but a browser and
a free GitHub account, and works on anything — a Chromebook, a lab
machine, a borrowed laptop.

## Your Linux environment

Everyone in this class works in the same room: **Ubuntu 24.04**, same
tools, same versions. It costs nothing, and the last row of this table
exists so that nobody has to buy hardware to take this course. You get
there through whichever door fits the machine you already own:

| Your machine | Your path |
|---|---|
| Windows 10 or 11 (any edition, Home included) | **WSL2** — built into Windows |
| macOS 13.3+ (Intel or Apple Silicon) | **Multipass** — a small virtual machine |
| Linux | **Native packages** |
| A Chromebook, a machine you can't install on, or anything that defeats the other three | **GitHub Codespaces** — in the browser |

Follow [`setup/getting-started.md`](../setup/getting-started.md). Total
time for the first setup is about **15 minutes**, most of it download.
Week 1's work order walks you through it and ends with a smoke test, so
have it finished by **Friday, August 21**. If a path fights you, bring
it to office hours or to Wednesday studio — nobody loses points for a
stubborn laptop.

## How a week runs

| When | What happens |
|---|---|
| **Before Wednesday's class** | The week's zyBooks reading is due (participation + challenge activities). |
| **Monday** | Episode deck: the week's story beat (~10 minutes), the concept lecture (~25 minutes), then the briefing for the week's work order. |
| **Wednesday & Friday** | **Studio.** You work the work order on your own machine while the instructor circulates. This is the heart of the course — come, and bring your questions. |
| **Friday, 11:59 pm** | Work order deliverables due on **Canvas**. |

**One exception, all semester:** fall break falls on Friday, October 2, so
**Week 7's deliverables are due Monday, October 5 at 11:59 pm** instead.
Nothing is due over the break. Every other week turns in on Friday; when
in doubt, [`schedule.md`](schedule.md) has the date.

Every work order is built the same way: a short situation, the plain
Objectives it serves, the provisions (starter code and one command to set
your week up), then numbered tasks with a **wax-seal checkpoint** every
few minutes of work. Running a checkpoint's `make` target prints a short
seal token; you paste that token into your logbook as proof the milestone
passed. Each section also carries an "if you're lost, start here" box,
and each work order ends with a "for the curious" extension that is worth
no points and exists purely for fun.

## What you turn in

**Weekly (Canvas):**

- `logbook.md` — the week's lab report from the provided template: what
  you did at each milestone, the seal or output that proves it, and what
  it means, plus two short reflection prompts.
- `case-notes.md` — your running notebook, one short entry per week:
  anything odd you noticed, how you found it, and what you think it
  means. It is graded on being kept honestly and thoughtfully, never on
  reaching the "right" conclusion early.

**Five times a semester (zyBooks):** a Guild Commission — one of the
department's Python projects, unmodified. Dr. Foust's published spec is
authoritative for each; the course adds only a cover page and a place on
the calendar. Assigned and due dates are in
[`schedule.md`](schedule.md).

**Twice (in class):** the Guild Examinations — Exam I on Wednesday,
October 7 (zyBooks Ch 1–5), and Exam II in finals week (Ch 6–8 plus
lighter coverage of the applied weeks). They are written in the Guild's
voice; the questions are ordinary operating-systems questions.

**Once (Monday, November 30):** your **sealed verdict** — a short written
conclusion about the season's case, citing at least three findings from
your own case notes. It is graded as a normal task of Week 15's work
order, and it is graded on your chain of reasoning and the notes you
cite, not on landing the answer.

## Grading

| Component | Weight | How it works |
|---|---|---|
| **Work orders** (weekly labs) | **35%** | Fourteen graded work orders — one per week except exam week — **equally weighted, none dropped**. Each is scored **30% wax seals** (pasted under the right milestones — these are completion checks, and a documented environment fight with my sign-off still earns them) and **70% prose**, on a short rubric: correctness of your findings, quality of your reasoning, and the reflection. |
| **Guild Examinations** | **30%** | Exam I 15% (Week 8) · Exam II 15% (finals week). |
| **Guild Commissions** (5 projects) | **20%** | 4% each, graded in zyBooks per department practice. |
| **zyBooks reading** | **10%** | Chapter 1–8 participation and challenge activities, due before each Wednesday. |
| **Professionalism** | **5%** | Attendance and studio participation, on the published rubric under [Attendance and professionalism](#attendance-and-professionalism). |

**How one work order is scored**, so the 70% prose is not a mystery.
Every week splits the same three ways:

| Part of the work order | Weight |
|---|---|
| **Wax seals** — pasted under the right milestones | **30%** |
| **Milestone narrative** — what you did at each milestone and what it means, in your own words, plus that week's case-notes entry | **40%** |
| **Reflections** — the closing prompts in the logbook, plus the week's short answers where a work order asks for them | **30%** |

Individual assignments may use different raw rubric totals, but every
score is normalized to a 100-point scale in Canvas, and it is the
category weights in the table above — not any one assignment's raw point
total — that determine how much a score moves your course grade.

Your course grade is the weighted sum, rounded once at the end to the
nearest whole percent, on the standard scale:

| Grade | Score |
|---|---|
| A | 90 – 100 |
| B | 80 – 89 |
| C | 70 – 79 |
| D | 60 – 69 |
| F | below 60 |

**No dropped scores. No extra credit, no bonus points — none, for
anyone, at any point in the semester.** This is
not sternness for its own sake: with fourteen equally weighted work
orders, the honest way to protect your grade is to keep turning things
in, and the honest way for me to be fair to all of you is to grade
everyone by the same arithmetic. If something in your life goes sideways,
come talk to me *early* — that conversation is far more useful than any
points scheme.

## Late work

**Work orders and commissions — two days, flat 20%.** Anything turned
in late takes a flat **20% deduction** from its earned score and is
**not accepted more than two calendar days after the deadline**. One
minute late and two days late cost the same 20%; three days late is a
zero. The deduction is flat, not per day, and it does not stack. And a
partial submission on time beats a complete one two days late every
single time — turn in what you have and say in your logbook what is
missing and why.

**The one exception: zyBooks chapter readings are firm.** The weekly
participation and challenge activities are recorded by zyBooks itself
and **close on their posted date without a late window.** No deduction,
no grace, no exceptions — the score zyBooks has at the deadline is the
score. They are open a full week ahead of when they are due, they are
worth 10% of your grade in aggregate, and no single one of them can
hurt you much. Do them Sunday and forget about them.

*(The five Guild Commissions are also submitted in zyBooks, but they are
**not** covered by that rule — they get the ordinary two-day window
above, same as a work order.)*

**When life actually goes wrong.** If illness, a family emergency, or a
university-sponsored absence is going to cost you a deadline, email me
**before the deadline when you can and as soon as you possibly can when
you can't.** Documented situations are handled case by case and
generously, including on the readings, where I can reopen an activity
for you — but I can only do that if I know. The two-day window is not
the mechanism for a real emergency; it is the mechanism for an ordinary
bad week, and it needs no explanation from you at all.

## Attendance and professionalism

Harding's attendance policy, as published in the Student Handbook and
the University catalog, applies in full in this course. **Roll is taken
at every meeting.**

Beyond the formal policy: Wednesday and Friday are studio sessions, and
studio is where the course actually happens. The students who show up
and work the problem with help two seats away finish the semester
noticeably less bruised than the ones who take the work order home
alone. That is the whole reason **5% of your grade is a professionalism
score** — not to punish anyone for getting sick, but to say plainly that
turning up prepared and engaged is part of the work, exactly as it will
be in the job this degree is for.

### How the 5% is scored

The course meets **44 times** — three days a week across the fifteen
teaching weeks, less Friday, October 2 for fall break. Your
professionalism score is out of 100 points, in two parts, and I post a
preview of it right after Exam I so nobody meets it for the first time
in December.

**Attendance — 70 of the 100 points.**

- You get **three unexcused absences for the whole semester, and they
  cost nothing.** Not three per month, not three per half — three, from
  August to December. No reason required, no email needed. Spend them on
  the flu, a dead battery, an interview, a bad week — that is exactly
  what they are for.
- Each unexcused absence **after the third** costs **10 points**.
- **Excused absences never count against you**, and there is no
  participation to "make up": university-sponsored activities,
  documented illness, family emergencies, and religious observance.
  Tell me by email, ahead of time when you can.
- Arriving more than ten minutes late or leaving early is not an
  absence; it is a matter for the engagement rubric below.

**Studio engagement and conduct — 30 of the 100 points.**

| Points | What it looks like |
|---|---|
| **30** | On time, machine open, working the work order. Asks questions out loud and answers other people's. Brings the exact command and the exact output when stuck. Helps a neighbour get unstuck without handing over the answer. |
| **22** | Reliably present and on task. Engages when asked, works steadily, needs no managing. |
| **15** | Present in body. Usually silent or off-task, needs prompting to start, or treats studio as a study hall for another course. |
| **0 – 8** | Chronically late or leaving early, disruptive, or in breach of the collaboration norms below. |

Nothing in this component is a secret and nothing in it is a mood. If
you are present, on time, and working, you have the full 5% — and if
your score is ever heading for the bottom row, you will hear it from me
directly and in writing, in time to do something about it.

## Time expectations

*University statement.* For every course credit hour, the typical
student should expect to spend at least three clock hours per week of
concentrated attention on course-related work, including but not limited
to time attending class, as well as out-of-class time spent reading,
problem solving, reviewing, organizing notes, preparing for upcoming
quizzes/exams, developing and completing projects, and other activities
that enhance learning. Thus, for a three-hour course, a typical student
should expect to spend at least nine hours per week dedicated to the
course.

For this course specifically, that nine hours tends to land as: 2.5
hours in class, about 1.5 hours on the zyBooks reading, and about 2
hours on the week's work order — the numbered tasks themselves are
budgeted at 45 to 85 minutes, and writing the logbook, the week's
case-notes entry, and the two reflections is the rest. Most of the work
order you can do *inside* Wednesday and Friday studio if you use the
time. That leaves roughly three hours a week for the things without a
due date attached — rereading a chapter, going back over a command that
went past you, exam study — and for the commissions, which is exactly
why a week with a commission due runs heavier. The commissions are
assigned three to five weeks ahead for that reason. Check
[`schedule.md`](schedule.md) at the start of the semester and put the
five commission due dates in your own calendar.

## Academic integrity

*University statement.* Honesty and integrity are characteristics that
should describe each one of us as servants of Jesus Christ. As your
instructor, I pledge that I will strive for honesty and integrity in how
I handle the content of this course and in how I interact with each of
you. I ask that you join me in pledging to do the same.

Academic dishonesty will result in penalties up to and including
dismissal from the class with a failing grade and will be reported to
the Director of Academic Affairs. All instances of dishonesty will be
handled according to the procedures delineated in the Harding University
catalog.

I read that the way the university intends it — as a matter of character
rather than a matter of enforcement. The Guild has a motto, *Ex Vapore,
Ordo* ("from steam, order"), and an unwritten companion to it: an
engineer's signature means the engineer did the work.

Concretely, for this course:

- **Talk to each other.** Discussing concepts, sketching an approach on a
  whiteboard, comparing what a command's output means, and helping a
  classmate get unstuck are all encouraged, all semester.
- **Write your own work.** The code you submit and the prose in your
  logbook, case notes, and verdict must be yours — typed by you, in your
  own words, understandable by you if I ask you about it in studio.
- **Never hand over or accept a finished artifact.** Do not send another
  student your solution code, your logbook, or your wax seals, and do not
  post them publicly. And be plain about what a seal is: it is a
  completion marker, not a signature. It proves that a check passed —
  not who ran it. That is exactly why the graded majority of a work
  order is your own writing: the prose is what carries integrity in
  this course, and the prose is the part I actually read.
- **Say where help came from.** A one-line note in your logbook's
  *Sources and help* section — "worked through the `fork` ordering with
  Sam in studio," "used the man page example for `mmap`" — costs you
  nothing and is exactly the habit professional engineers keep.
- **Exams are individual and closed-resource** unless I say otherwise in
  writing.

Suspected violations are handled through the university's academic
integrity process. If you are ever unsure whether something is allowed,
ask me first — that question has never once gotten a student in trouble.

## Use of AI tools

AI assistants are part of the profession you are entering, and this
course treats them as a tool with a right and a wrong place.

**Allowed, and often a good idea:** using an AI assistant to study — to
explain a concept from the reading a second way, to walk through what a
`strace` line means, to quiz you before an exam, or to help you interpret
a compiler or `valgrind` error you are stuck on.

**Not allowed:** any AI use during an exam; generating the code you
submit for a commission or a work order; and generating the **reasoning
sections** of your logbook, case notes, or sealed verdict — the "what it
means," the reflections, and the conclusions must be your own thinking in
your own words. Those sections are the part of the course that becomes
your judgment as an engineer, and outsourcing them is the one shortcut
that actually costs you something real.

**Acknowledge it when you use it.** If an AI tool helped you study or
debug, note it in your logbook the same way you would note help from a
classmate — one line under *Sources and help*, naming the tool and what
you used it for:

> Used an AI assistant to explain what `EAGAIN` means in the Week 2 trace.

That one line is all the citation this course asks for, and it has never
cost a student a single point.

**Using an AI tool on work where this syllabus does not permit it, or
using it where it is permitted without acknowledging it, is academically
dishonest and constitutes a violation of Harding's Academic Integrity
Policy.** If you are ever unsure whether a particular use is allowed,
ask me before you do it rather than after.

## Students with disabilities

*University statement.* It is the policy for Harding University to
accommodate students with disabilities, pursuant to federal and state
law. Therefore, any student with a *documented disability* condition
(e.g. physical, learning, or psychological) who needs to arrange
reasonable accommodations must contact the instructor and the Office of
Disability Services and Educational Access at the *beginning* of each
semester. If the diagnosis of the disability occurs during the academic
year, the student must self-identify with the Office of Disability
Services and Educational Access *as soon as possible* in order to get
academic accommodations in place for the remainder of the semester. The
Office of Disability Services and Educational Access is located in Room
239 in the Student Center, telephone, (501) 279-4019.

If you have an accommodation letter, bring it to me early in the semester
and we will make the arrangements quietly and without fuss. If some part
of the course materials is hard to use — slide contrast, terminal font
size, screen-reader trouble with a lab document — tell me. That is a bug
in my materials, and I would like to fix it.

## Getting help

**Office hours**, in **Science 209** — no appointment needed, no reason
needed, and no question too small:

| Day | Hours |
|---|---|
| Monday | 9:00 – 10:00 am · 12:00 – 1:00 pm · 2:00 – 3:00 pm |
| Tuesday | 9:00 am – 12:00 pm |
| Wednesday | 9:00 – 10:00 am · 12:00 – 1:00 pm · 2:00 – 3:00 pm |
| Thursday | 8:00 – 9:30 am |
| Friday | 9:00 – 10:00 am · 12:00 – 1:00 pm · 2:00 – 3:00 pm |

That is thirteen and a half hours a week, most of it wrapped around our
1:00 class. Use it. If none of it fits your schedule, email me and we
will find a time that does.

Everything else:

- **Email:** <jfaith@harding.edu>. I answer **within 48 hours**, and
  usually a good deal sooner. Weekend email gets answered Monday. Put
  **COMP 3100** in the subject line.
- **Studio (Wednesday and Friday):** the fastest help in the course. Ask
  early and out loud; three other people have the same question.
- **Canvas** carries announcements, assignment shells, grades, and the
  links to zyBooks and the course repository.

When you are stuck, bring the exact command you ran and the exact output
you got. That habit will make you look like a senior engineer within
about a month.

## University statements

**Assessment.** Harding University, since its charter in 1924, has been
strongly committed to providing the best resources and environment for
the teaching-learning process. The board, administration, faculty, and
staff are wholeheartedly committed to full compliance with all Criteria
of Accreditation of the Higher Learning Commission as well as the
standards of many discipline-specific specialty accrediting agencies.
The university values continuous, rigorous assessment at every level for
its potential to improve student learning and achievement and for its
centrality in fulfilling the stated mission of Harding. Thus, a
comprehensive assessment program has been developed that includes both
the academic units and the administrative and educational support units.
Course-specific student learning outcomes contribute to student
achievement of program-specific learning outcomes that support student
achievement of holistic university learning outcomes. All academic units
design annual assessment plans centered on measuring student achievement
of program learning outcomes used to sequentially improve teaching and
learning processes. Additionally, a holistic assessment of student
achievement of university learning outcomes is coordinated by the
university Director of Assessment and Testing used to spur continuous
improvement of teaching and learning.

**Student privacy and class recordings.** This course may involve
audio/video recording of class sessions for educational purposes. By
enrolling in this course, students consent to being recorded during
class sessions, including their voice and image, when participating in
class discussions or activities.

*Student rights regarding recordings:* Students have the right to review
recordings in which they appear. Recordings are considered educational
records protected under FERPA. Students may request accommodation if
they have concerns about being recorded. Recordings may not be shared,
distributed, or posted by students without explicit written permission.

*Use of recordings:* Class recordings are for educational use only and
may be used for students who missed class due to illness or emergency;
student review of course material; accommodation purposes for students
with documented disabilities; instructor review and course improvement;
and, with student consent, in other sections or future offerings of the
course.

*Retention:* Recordings will be retained for 7 years and then
permanently deleted unless required for disciplinary or legal
proceedings.

*Student-initiated recordings:* Students may not record class sessions
without prior written consent from the instructor and all participants.
Unauthorized recording may result in disciplinary action.

**Dress code.** All students must abide by the Student Handbook. A
student may be asked to leave class or other activities if they are not
in keeping with these standards.

## Changes to this syllabus

Anything that changes — a date, a weight, a policy — is announced in
class and on Canvas, and [`schedule.md`](schedule.md) is updated the same
day. That file is always the current truth about dates.

---

*Honourable Guild of Enginewrights · Brassbridge, 1851*
***Ex Vapore, Ordo***
