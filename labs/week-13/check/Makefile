# Week 13 wax-seal checkpoints. Run from labs/week-13:  make -C check m1
#
# The house rules, all learned the hard way, all non-negotiable:
#
#  1. No backticks anywhere in a recipe's echo. A backtick inside an echo is
#     command substitution, and an earlier week's build caught one printing a
#     VALID wax seal inside a FAILURE message. There is not a single backtick
#     in this file; keep it that way.
#
#  2. Every numeric answer is parsed the same way, in every seal that reads
#     it:   sed -n 's/^AN://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'
#     Copy the pipeline exactly if you add a seal. (A8 is the one exception:
#     it holds dates, so it is read as year-month-day, and says so.)
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', so a glance at this file
#     spoils nothing: the two mode strings, the owner's uid, the field
#     numbers and the name of the key whose lines Task 4 counts. The two
#     constant counts are written the same way, but a single digit reads the
#     same reversed, so for those the reversal hides nothing.
#     Paths in the registry, and the words the work order teaches openly, are
#     not reversed.
#
#  4. A seal must never be satisfiable on a bench that never staged the
#     week. Every seal first requires the registry's Warden's log to exist,
#     with a message routing to report-for-duty.sh. m2 also requires the
#     spare key to be as staged (owned by the archive account, setuid).
#
#  5. No seal needs root, and no seal changes anything. Nothing here runs the
#     spare key, runs sudo, writes to the registry or signals a process: the
#     seals read the registry's papers (all world-readable) and ask stat, ls
#     and find about the spare key.
#
#  6. No seal matches a person's name. They count lines, compare numbers,
#     mode strings and dates, and assert one count. That is all. Answers are
#     never a name, and none of them is read for one.
#
# Every DERIVED value is computed at check time from the student's own
# bench, never stored here: their uid and gid (id), the key's mode string
# and owner (ls, stat), how many setuid files sit under their home (find),
# the count of the archive key's lines and the log's two end dates (the log
# itself). The constants left are canon, written backwards below (single
# digits excepted, as in 3); the
# instructor-side bench check guards them against drift in
# report-for-duty.sh.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.

REG   := $$HOME/enginehouse/registry
AUTH  := $(REG)/auth-ledger.log
KEY   := $(REG)/.spare-key

UID_R     := 9481
SHELLF_R  := 7
GIDF_R    := 4
MODE640_R := -----r-wr-
MODEKEY_R := x-rx-rswr-
MODE644_R := --r--r-wr-
MODE600_R := -------wr-
MODE755_R := x-rx-rxwr-
OCT640_R  := 046
CNT_A_R   := 6
CNT_B_R   := 0
NAME_R    := yek-eraps
TOPKEY_R  := retsam-ecitnerppa

SEAL := bash ../../lib/seal.sh 13

m1:
	@test -f "$(AUTH)" || { echo "  (There is no registry on this bench, so nothing has been staged to seal. From labs/week-13: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-13: cp check/answers-template check/answers.txt, fill in A1 to A3, then make -C check m1 again.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A1 wants TWO numbers: your uid, then your primary gid, the two at the front of the id line. Not the list of groups after them. Task 1 step 1. Then make -C check m1 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	u="$$(id -u)"; g="$$(id -g)"; \
	if [ "$$x" -eq "$$u" ] && [ "$$y" -eq "$$g" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$g" ] && [ "$$y" -eq "$$u" ]; then echo "  (A1 has the two numbers the wrong way round: id prints the uid first, then the gid. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A1's numbers are not your uid and primary gid on THIS bench. Run id and copy the two numbers at the front of its line: uid=, then gid=. Task 1 step 1. Then make -C check m1 again.)"; exit 1
	@a2="$$(sed -n 's/^A2://p' answers.txt)"; \
	if [ -z "$$(printf '%s' "$$a2" | tr -d '[:space:]')" ]; then echo "  (A2 is still blank -- the mode string of the file you chmod 640'd, ten characters, then its octal mode. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	ms="$$(printf '%s' "$$a2" | grep -oE '[-dlrwxsStT]{10}' | head -n 1)"; \
	oc="$$(printf '%s' "$$a2" | sed 's/[-dlrwxsStT]\{10\}//' | tr -d ',' | grep -oE '[0-9]+' | sed 's/^0*//' | tr '\n' ' ')"; \
	if [ -z "$$ms" ]; then echo "  (A2 does not carry a mode string: the ten characters ls -l prints at the start of the line, the type letter first, e.g. a dash and then nine more. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$ms" = "$$(printf '%s' '$(MODE644_R)' | rev)" ]; then echo "  (A2's mode string is the one for 644: a file that still lets everyone read it. Run chmod 640 on your file, then ls -l it again. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$ms" = "$$(printf '%s' '$(MODE600_R)' | rev)" ]; then echo "  (A2's mode string is the one for 600: the file before its group was given read. Finish the chmod, so the group reads and no one else does, then ls -l it again. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$ms" != "$$(printf '%s' '$(MODE640_R)' | rev)" ]; then echo "  (A2's mode string is not the one for a file at 640: owner read and write, group read, others nothing. Run chmod 640 on your file and copy what ls -l prints, all ten characters. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$oc" = "$$(printf '%s' '$(OCT640_R)' | rev) " ]; then exit 0; fi; \
	echo "  (A2's mode string is right, but its octal is not 640. Owner is 4+2, group is 4, others is 0: write the three digits, in that order, or ask stat with the format %a. Task 1 step 4. Then make -C check m1 again.)"; exit 1
	@n="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A3 wants TWO numbers: the field number of the login shell in /etc/passwd, then the field number of the primary gid. Task 1 step 2. Then make -C check m1 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	sh="$$(printf '%s' '$(SHELLF_R)' | rev)"; gf="$$(printf '%s' '$(GIDF_R)' | rev)"; \
	if [ "$$x" -eq "$$sh" ] && [ "$$y" -eq "$$gf" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$gf" ] && [ "$$y" -eq "$$sh" ]; then echo "  (A3 has the two field numbers the wrong way round: the login shell first, then the gid. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$y" -eq 3 ]; then echo "  (A3's second number is the uid field. The gid is the next field along. Count the numbered walk in Task 1 step 2 again. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A3's numbers are not the field numbers of the login shell and the primary gid in /etc/passwd. Walk one line of it field by field, as Task 1 step 2 shows, and count. Then make -C check m1 again.)"; exit 1
	@$(SEAL) 1

m2:
	@test -f "$(AUTH)" || { echo "  (There is no registry on this bench, so nothing has been staged to seal. From labs/week-13: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-13: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@k="$$(stat -c '%u %a' "$(KEY)" 2>/dev/null || echo none)"; \
	if [ "$$k" != "$$(printf '%s' '$(UID_R)' | rev) 4755" ]; then echo "  (The spare key is not on this bench as it was staged. From labs/week-13: bash report-for-duty.sh stages the registry afresh -- then make -C check m2 again.)"; exit 1; fi
	@a4="$$(sed -n 's/^A4://p' answers.txt)"; \
	if [ -z "$$(printf '%s' "$$a4" | tr -d '[:space:]')" ]; then echo "  (A4 is still blank -- the spare key's type and permissions as ls -l prints them, then the uid that owns it. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	ms="$$(printf '%s' "$$a4" | grep -oE '[-dlrwxsStT]{10}' | head -n 1)"; \
	if [ -z "$$ms" ]; then echo "  (A4 does not carry the key's mode string: the ten characters ls -l prints at the start of its line. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	want="$$(ls -l "$(KEY)" | cut -c1-10)"; \
	if [ "$$ms" = "$$(printf '%s' '$(MODE755_R)' | rev)" ]; then echo "  (A4's mode string has no s in it: it is the string of an ordinary executable. Read the key's own line in ls -l: the s sits where the owner's x would be. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$ms" != "$$want" ]; then echo "  (A4's mode string is not the spare key's, as ls -l prints it. Run ls -l on the key itself and copy all ten characters. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	n="$$(printf '%s' "$$a4" | sed 's/[-dlrwxsStT]\{10\}//' | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A4 wants the mode string and ONE number: the uid that owns the key, as ls -n prints it. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	x="$$(printf '%s' "$$a4" | sed 's/[-dlrwxsStT]\{10\}//' | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$(printf '%s' '$(UID_R)' | rev)" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(id -u)" ]; then echo "  (A4 carries your own uid. The key is not yours: the owner is the first number after the link count in ls -ln, and it is not you. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$x" -eq 0 ]; then echo "  (A4 carries uid 0, root: that owns passwd, sudo and su in step 1. Read the owner of the spare key, in ls -ln. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$x" -eq "$$(id -g)" ] || [ "$$x" -eq 100 ]; then echo "  (A4 carries a group number. ls -ln prints the owner first and the group second; A4 wants the owner. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A4's uid is not the owner of the spare key. Read the first of the two numbers after the link count in ls -ln. Task 2 step 4. Then make -C check m2 again.)"; exit 1
	@n="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A5 wants TWO numbers: your euid as id -u prints it straight after you run the spare key, then the uid sudo id prints for the one command. Task 2 steps 2 and 5. Then make -C check m2 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	u="$$(id -u)"; owner="$$(printf '%s' '$(UID_R)' | rev)"; \
	if [ "$$x" -eq "$$owner" ] || [ "$$x" -eq 0 ]; then echo "  (A5 says your euid changed when you ran the spare key. It did not: the kernel ignores the setuid bit on a script, so the key ran with your own uid. Run the key, then id -u, exactly as Task 2 step 5 shows, and read the number. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$x" -ne "$$u" ]; then echo "  (A5's first number is not your euid after running the key. It is the number id -u prints on YOUR bench, straight after the key runs. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	cntb="$$(printf '%s' '$(CNT_B_R)' | rev)"; \
	if [ "$$y" -eq "$$cntb" ]; then exit 0; fi; \
	if [ "$$y" -eq "$$u" ] && [ "$$u" -ne 0 ]; then echo "  (A5's second number is your own uid. sudo id should report root's: run it with sudo in front, as Task 2 step 2 shows, and copy that. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A5's second number is not the uid sudo id prints. Run sudo id, read the number after uid=, and copy it. Task 2 step 2. Then make -C check m2 again.)"; exit 1
	@$(SEAL) 2

m3:
	@test -f "$(AUTH)" || { echo "  (There is no registry on this bench, so there is no log to read. From labs/week-13: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-13: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@a6="$$(sed -n 's/^A6://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a6" | tr -d '[:space:]')" ]; then echo "  (A6 is still blank -- how many files find under your home lists, then the name of the one under registry/. Task 2 step 4. Then make -C check m3 again.)"; exit 1; fi; \
	nm="$$(printf '%s' '$(NAME_R)' | rev)"; \
	if ! printf '%s' "$$a6" | grep -qF -- "$$nm"; then echo "  (A6 does not carry the name of the setuid file under registry/, as ls or find prints it. Task 2 step 4. Then make -C check m3 again.)"; exit 1; fi; \
	n="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A6 wants ONE number, the count of files find lists under your home, and the file's name. Task 2 step 4. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	want="$$(find "$$HOME" -perm -4000 2>/dev/null | wc -l | tr -d ' ')"; \
	if [ "$$x" -eq "$$want" ]; then exit 0; fi; \
	echo "  (A6's number is not how many files find under YOUR home lists with -perm -4000. Run find, with your home as the place to look, and count its lines. Not the whole bench: that is step 5. Task 2 step 4. Then make -C check m3 again.)"; exit 1
	@n="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A7 wants ONE number: how many lines of the Warden's log carry key=1849. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	uid="$$(printf '%s' '$(UID_R)' | rev)"; \
	if [ "$$x" -eq "$$(grep -c "key=$$uid " "$(AUTH)")" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(grep -c 'SESSION-OPEN' "$(AUTH)")" ]; then echo "  (A7 counts only the lines that open a session. A7 wants every line of the log that carries that key, whatever its last word. Count them with grep -c on the key itself. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$x" -eq "$$(grep "key=$$uid " "$(AUTH)" | grep -c 'PRESENT')" ]; then echo "  (A7 counts only the lines that end PRESENT. A7 wants every line of the log that carries that key, whatever its last word. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A7's number is not how many lines of the log carry that key. Run grep -c on key=1849 exactly as Task 3 step 3 shows and copy the number. Then make -C check m3 again.)"; exit 1
	@ds="$$(sed -n 's/^A8://p' answers.txt | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | tr '\n' ' ')"; \
	if [ -z "$$ds" ]; then echo "  (A8 wants two dates, written as the log writes them: year-month-day, like 1851-03-02. Task 3 step 4. Then make -C check m3 again.)"; exit 1; fi; \
	first="$$(grep -v '^#' "$(AUTH)" | cut -d' ' -f1 | sort | sed -n 1p)"; \
	last="$$(grep -v '^#' "$(AUTH)" | cut -d' ' -f1 | sort | sed -n '$$p')"; \
	if [ "$$ds" = "$$first $$last " ]; then exit 0; fi; \
	if [ "$$ds" = "$$last $$first " ]; then echo "  (A8 has the two dates the wrong way round: the earliest first, then the latest. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A8's dates are not the earliest and the latest in the Warden's log. Sort the dates and take the first and the last line, as Task 3 step 4 shows. Leave out the two header lines that begin with a hash. Then make -C check m3 again.)"; exit 1
	@$(SEAL) 3

m4:
	@test -f "$(AUTH)" || { echo "  (There is no registry on this bench, so there is no log to cross-check. From labs/week-13: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-13: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@test -f "$(REG)/visitor-ledger-1851.txt" || { echo "  (The porters' visitor book is not in the registry. From labs/week-13: bash report-for-duty.sh stages it afresh -- then make -C check m4 again.)"; exit 1; }
	@n="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A9 wants ONE number: how many of the log's session openings fall inside a documented visit. Task 4 step 4. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	cnta="$$(printf '%s' '$(CNT_A_R)' | rev)"; uid="$$(printf '%s' '$(UID_R)' | rev)"; \
	if [ "$$x" -eq "$$cnta" ] && [ "$$(grep -c 'SESSION-OPEN' "$(AUTH)")" -eq "$$cnta" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(grep -c "key=$$uid " "$(AUTH)")" ]; then echo "  (A9 counts every line of that key. A9 counts only the session OPENINGS, and only those inside a visit. Task 4 step 4. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$x" -eq "$$(grep -vc '^#' "$(REG)/visitor-ledger-1851.txt")" ]; then echo "  (A9 is the number of visits in the porters' book. A9 counts the log's session openings that fall inside one. Task 4 step 4. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$x" -lt "$$cnta" ]; then echo "  (A9 is not right yet. Check marks.txt holds both the IN lines and the OUT lines, then sort it together with opens.txt and count again. Task 4 steps 3 and 4. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A9 is not the number of session openings that fall inside a documented visit. Count the SEEN lines that sit after an IN and before the next OUT, as Task 4 step 4 does. Then make -C check m4 again.)"; exit 1
	@n="$$(sed -n 's/^A10://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A10 wants ONE number: how many times the key shown most often in the log falls inside a documented visit. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A10://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$(printf '%s' '$(CNT_B_R)' | rev)" ]; then exit 0; fi; \
	top="$$(printf '%s' '$(TOPKEY_R)' | rev)"; \
	if [ "$$x" -eq "$$(grep -c "key=$$top " "$(AUTH)")" ]; then echo "  (A10 is how many times that key appears in the log at all. A10 counts only its lines that fall inside a visit: on a visit day, between that day's IN and OUT. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A10 is not right yet. Read the windows again: a line counts only if its day is a visit day AND its time lies between that day's IN and OUT. Sort marks.txt with the key's lines and look, as Task 4 step 5 shows. Then make -C check m4 again.)"; exit 1
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
