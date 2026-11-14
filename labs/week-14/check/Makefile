# Week 14 wax-seal checkpoints. Run from labs/week-14:  make -C check m1
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
#     Copy the pipeline exactly if you add a seal. (A3 is the one exception:
#     it holds an address, four numbers with dots between them, so it is
#     read as an address, and says so. A2 and A7 carry words as well.)
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', so a glance at this file
#     spoils nothing: the exchange's port and address, the archive account's
#     uid and group, the State word, and the line the Sport spec draws at
#     32768. The dispatch count is written the same way, but a single digit
#     reads the same reversed, so for that one the reversal hides nothing.
#     Paths in the exchange and the listener's program name are not
#     reversed: the work order teaches every one of them openly.
#
#  4. A seal must never be satisfiable on a bench that never staged the
#     week. Every seal first requires the exchange to exist, with a message
#     routing to report-for-duty.sh. m2 and m4 also require the listener at
#     work: something listening on the exchange's port, and (m4) answering.
#     Liveness is asked of ss, ps and the port itself, never with kill -0:
#     you may not signal another account's process.
#
#  5. No seal needs root, and no seal changes anything. Nothing here moves a
#     dispatch, writes to the exchange or signals the listener. m4 asks the
#     port for its one line (bash's own /dev/tcp, this machine only), which
#     is exactly what the work order has you do with nc.
#
#  6. No seal matches a person's name, and none reads the procedure's words.
#     They compare numbers, an address, a State word and a date, and count
#     the papers in two folders. That is all.
#
# Every DERIVED value is computed at check time from the student's own
# bench, never stored here: the address the port is open on (ss), the
# listener's uid and pid (ps), the count of dispatches in the queue and in
# held/ (ls), who owns the held papers (find), the hold date (the first
# dispatch's own header), the cancellation order's count, and what the port
# says now. The constants left are canon, written backwards below; the
# instructor-side bench check guards them against drift in
# report-for-duty.sh.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.

EXCH     := $$HOME/enginehouse/exchange
QUEUE    := $(EXCH)/outbound-queue
HELD     := $(EXCH)/held
ORDER    := $(EXCH)/cancellation-order
LISTENER := aether-listener

PORT_R   := 1581
ADDR_R   := 1.0.0.721
UID_R    := 9481
GID_R    := 001
LOW_R    := 86723
STATE_R  := batse
STATEW_R := dehsilbatse
NDISP_R  := 5

SEAL := bash ../../lib/seal.sh 14

m1:
	@test -d "$(EXCH)" || { echo "  (There is no exchange on this bench, so nothing has been staged to seal. From labs/week-14: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-14: cp check/answers-template check/answers.txt, fill in A1 and A2, then make -C check m1 again.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A1 wants ONE number: the port your own nc -l listened on. Just the port, not the address in front of it. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1 | sed 's/^0*//')"; x="$${x:-0}"; \
	if [ "$${#x}" -gt 5 ]; then echo "  (A1 is bigger than any port can be: a port is a number from 1 to 65535. Copy the port your own nc -l listened on. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	port="$$(printf '%s' '$(PORT_R)' | rev)"; low="$$(printf '%s' '$(LOW_R)' | rev)"; \
	if [ "$$x" -eq "$$port" ]; then echo "  (A1 is the port of the listener you did NOT start. A1 wants the port of your own: the one you chose in Task 1 step 3 and gave to nc -l. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$x" -gt 65535 ]; then echo "  (A1 is bigger than any port can be: a port is a number from 1 to 65535. Copy the port your own nc -l listened on. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$x" -lt "$$low" ]; then echo "  (A1 is below 32768. A port that low is where a machine keeps its services, and the Sport spec counts a listener there as a service, not a user program. Choose a free port of your own at 32768 or above, check it with ss first, listen on it, and copy that number. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi
	@a2="$$(sed -n 's/^A2://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a2" | tr -d '[:space:]')" ]; then echo "  (A2 is still blank -- the word ss printed in the State column for your connection while the client was connected. Task 1 step 5. Then make -C check m1 again.)"; exit 1; fi; \
	w=" $$(printf '%s' "$$a2" | grep -oE '[a-z]+' | tr '\n' ' ')"; \
	case "$$w" in *" $$(printf '%s' '$(STATE_R)' | rev) "*|*" $$(printf '%s' '$(STATEW_R)' | rev) "*) exit 0 ;; esac; \
	case "$$w" in *" listen "*) echo "  (A2 is the State of a socket that is waiting for someone to connect. A2 wants the State of the connection itself, while terminal B was connected: run ss -tn with the client still connected, as Task 1 step 5 shows, and read the first column. Then make -C check m1 again.)"; exit 1 ;; esac; \
	case "$$w" in *" time "*|*" wait "*) echo "  (A2 is the State a connection is left in AFTER it has closed. A2 wants the State while it was open: run ss -tn with the client still connected, Task 1 step 5. Then make -C check m1 again.)"; exit 1 ;; esac; \
	echo "  (A2 is not the word ss printed in the State column for your connection. Run ss -tn while the client in terminal B is still connected, find the two rows with your port, and copy the first word. Task 1 step 5. Then make -C check m1 again.)"; exit 1
	@$(SEAL) 1

m2:
	@test -d "$(EXCH)" || { echo "  (There is no exchange on this bench, so nothing has been staged to seal. From labs/week-14: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-14: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@port="$$(printf '%s' '$(PORT_R)' | rev)"; \
	row="$$(ss -Htln 2>/dev/null | awk -v p="$$port" '{ n = split($$4, a, ":"); if (a[n] == p) print $$4 }' | head -n 1)"; \
	if [ -z "$$row" ]; then echo "  (Nothing on this bench is listening where the exchange's listener should be. It is a living process, and it does not survive wsl --shutdown, a reboot, or closing every Ubuntu window. From labs/week-14: bash report-for-duty.sh stages it afresh -- then make -C check m2 again.)"; exit 1; fi; \
	if [ -z "$$(ps -o uid= -C $(LISTENER) 2>/dev/null)" ]; then echo "  (No process named $(LISTENER) is running on this bench. From labs/week-14: bash report-for-duty.sh stages it afresh -- then make -C check m2 again.)"; exit 1; fi
	@a3="$$(sed -n 's/^A3://p' answers.txt)"; \
	if [ -z "$$(printf '%s' "$$a3" | tr -d '[:space:]')" ]; then echo "  (A3 is still blank -- the address the listener nobody started is bound to, as ss prints it in the Local Address column, without the port. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	port="$$(printf '%s' '$(PORT_R)' | rev)"; \
	want="$$(ss -Htln 2>/dev/null | awk -v p="$$port" '{ n = split($$4, a, ":"); if (a[n] == p) print $$4 }' | head -n 1)"; want="$${want%:*}"; \
	ip="$$(printf '%s' "$$a3" | grep -oE '[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+' | head -n 1)"; \
	if [ -z "$$ip" ]; then case "$$a3" in *'*'*|*'::'*) ip="0.0.0.0" ;; esac; fi; \
	if [ "$$ip" = "0.0.0.0" ]; then echo "  (A3 says the listener is open on ALL of this machine's addresses: 0.0.0.0, or a star, or ::. That would let other machines reach it. Read its row again in ss -tln: the address in front of the port is a narrower one. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	if [ -z "$$ip" ]; then echo "  (A3 does not carry an address: four numbers with dots between them, as ss prints them in front of the colon. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$ip" = "$$want" ] && [ "$$want" = "$$(printf '%s' '$(ADDR_R)' | rev)" ]; then exit 0; fi; \
	if ss -Htln 2>/dev/null | awk '{ print $$4 }' | sed 's/%[^:]*:/:/' | grep -qF -- "$$ip:"; then echo "  (A3 is the address of a different row: something else listens there. A3 wants the address of the listener nobody on this bench started -- the row whose port has no entry in /etc/services. Task 2 steps 2 and 3. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A3 is not the address the listener nobody started is bound to. Find its row in ss -tln and copy what stands in front of the colon. Task 2 step 3. Then make -C check m2 again.)"; exit 1
	@n="$$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A4 wants ONE number: the port that listener is bound to. Not the address as well. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$(printf '%s' '$(PORT_R)' | rev)" ]; then exit 0; fi; \
	if [ "$$x" -eq 53 ]; then echo "  (A4 is port 53. /etc/services names it: the domain name service, the bench's own housekeeping. A4 wants the port nobody on this bench can account for. Task 2 step 2. Then make -C check m2 again.)"; exit 1; fi; \
	a1="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ -n "$$a1" ] && [ "$$x" -eq "$$a1" ]; then echo "  (A4 is your own port from Task 1. A4 wants the port of the listener you did NOT start. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A4 is not the port of the listener nobody on this bench started. Read its row in ss -tln: the number after the last colon. Task 2 step 3. Then make -C check m2 again.)"; exit 1
	@n="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A5 wants ONE number: the uid that the listener runs as, as ps -o uid prints it. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	uid="$$(printf '%s' '$(UID_R)' | rev)"; \
	lu="$$(ps -o uid= -C $(LISTENER) 2>/dev/null | tr -d ' ' | head -n 1)"; \
	if [ "$$x" -eq "$$uid" ] && [ "$$lu" = "$$uid" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(id -u)" ]; then echo "  (A5 carries your own uid. The listener is not yours: that is why your ss showed no process on its row. Read the UID column of ps for its pid. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$x" -eq 0 ]; then echo "  (A5 carries uid 0, root. sudo ran ss as root so that you could SEE the process; the listener itself runs as someone else. Read the UID column of ps for its pid. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	for p in $$(ps -o pid= -C $(LISTENER) 2>/dev/null); do if [ "$$x" -eq "$$p" ]; then echo "  (A5 carries the listener's pid -- its process id, which changes every time it is started. A5 wants the uid it runs as: the UID column of ps. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; done; \
	if [ "$$x" -eq "$$(printf '%s' '$(GID_R)' | rev)" ] || [ "$$x" -eq "$$(id -g)" ]; then echo "  (A5 carries a group number. ls -ln prints the owner first and the group second; ps -o uid prints only the owner. A5 wants the owner. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A5 is not the uid the listener runs as. Take its pid from sudo ss -tlnp, then run ps -o uid,pid,comm -p with that pid, exactly as Task 2 step 5 shows, and copy the UID column. Then make -C check m2 again.)"; exit 1
	@$(SEAL) 2

m3:
	@test -d "$(EXCH)" || { echo "  (There is no exchange on this bench, so there is no queue to read. From labs/week-14: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-14: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@nq="$$(ls "$(QUEUE)" 2>/dev/null | grep -c '^dispatch-.*[.]txt$$')"; nh="$$(ls "$(HELD)" 2>/dev/null | grep -c '^dispatch-.*[.]txt$$')"; \
	if [ "$$(($$nq + $$nh))" -ne "$$(printf '%s' '$(NDISP_R)' | rev)" ]; then echo "  (The queue and held/ together do not hold the papers that were staged. Something has been removed. From labs/week-14: bash report-for-duty.sh stages the exchange afresh -- then make -C check m3 again.)"; exit 1; fi
	@n="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A6 wants ONE number: how many dispatches were waiting in outbound-queue/. Task 3 step 2. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$(printf '%s' '$(NDISP_R)' | rev)" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(ls -A "$(EXCH)" | grep -cv '^cancellation-order$$')" ]; then echo "  (A6 counts what is in exchange/ itself. A6 wants the dispatches inside outbound-queue/, one folder down. Task 3 step 2. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A6 is not how many dispatches were waiting in outbound-queue/. Count the dispatch files there with ls and wc -l, exactly as Task 3 step 2 shows. Then make -C check m3 again.)"; exit 1
	@a7="$$(sed -n 's/^A7://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a7" | tr -d '[:space:]')" ]; then echo "  (A7 is still blank -- the date the dispatches are held until, as their first line prints it. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	h="$$(head -n 1 "$(QUEUE)/dispatch-01.txt" 2>/dev/null || head -n 1 "$(HELD)/dispatch-01.txt" 2>/dev/null)"; \
	hold="$$(printf '%s' "$$h" | sed -n 's/.*HOLD UNTIL \([^,]*\).*/\1/p')"; \
	wantn="$$(printf '%s' "$$hold" | grep -oE '[0-9]+' | sed 's/^0*//' | tr '\n' ' ')"; \
	wantm="$$(printf '%s' "$$hold" | awk '{ print tolower($$3) }')"; \
	gotn="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed 's/^0*//' | tr '\n' ' ')"; \
	if [ -n "$$wantn" ] && [ "$$gotn" = "$$wantn" ] && printf '%s' "$$a7" | grep -qF -- "$$wantm"; then exit 0; fi; \
	if [ "$$gotn" = "1851 10 30 " ]; then echo "  (A7 is the date the procedure was entered, its third line. A7 wants the date the dispatches are HELD UNTIL, from a dispatch's own first line. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	if printf '%s' "$$a7" | grep -q 'nov'; then echo "  (A7 is the date ls prints beside each file -- the day this bench staged it. A7 wants the date written INSIDE a dispatch, on its first line, after HOLD UNTIL. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A7 is not the hold date as a dispatch's first line prints it. Copy the words after HOLD UNTIL and before the comma: a weekday, a day, a month and a year. Task 3 step 3. Then make -C check m3 again.)"; exit 1
	@n="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A8 wants TWO numbers from the one line the port answered with: dispatches queued, then acknowledgments received. Task 3 step 5. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	nd="$$(printf '%s' '$(NDISP_R)' | rev)"; \
	if [ "$$x" -eq "$$nd" ] && [ "$$y" -eq 0 ]; then exit 0; fi; \
	if [ "$$x" -eq 0 ] && [ "$$y" -eq "$$nd" ]; then echo "  (A8 has the two numbers the wrong way round: dispatches queued first, then acknowledgments received, in the order the line prints them. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$x" -eq 0 ]; then echo "  (A8 says nothing was queued. That is what the port says AFTER the queue is stayed, in Task 4. A8 is the line from Task 3, before you moved anything. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A8's numbers are not the two the port printed in Task 3 step 5: dispatches queued, then acknowledgments received. Ask it again with nc -d and copy both. Then make -C check m3 again.)"; exit 1
	@$(SEAL) 3

m4:
	@test -d "$(EXCH)" || { echo "  (There is no exchange on this bench, so there is no queue to stay. From labs/week-14: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-14: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@nq="$$(ls "$(QUEUE)" 2>/dev/null | grep -c '^dispatch-.*[.]txt$$')"; \
	if [ "$$nq" -ne 0 ]; then echo "  (outbound-queue/ still holds $$nq dispatch file(s): the queue is not stayed. Move every dispatch into held/, exactly as Task 4 step 2 shows. Then make -C check m4 again.)"; exit 1; fi; \
	nd="$$(printf '%s' '$(NDISP_R)' | rev)"; \
	nh="$$(ls "$(HELD)" 2>/dev/null | grep -c '^dispatch-.*[.]txt$$')"; \
	if [ "$$nh" -ne "$$nd" ]; then echo "  (held/ holds $$nh dispatch file(s), and the queue held more than that. A held dispatch is moved, never destroyed: one that was deleted is not held, and the procedure forbids it. From labs/week-14: bash report-for-duty.sh stages the exchange afresh with its queue full. Then stay it again by MOVING the papers, Task 4 step 2, and make -C check m4 again.)"; exit 1; fi; \
	uid="$$(printf '%s' '$(UID_R)' | rev)"; \
	if [ "$$(find "$(HELD)" -maxdepth 1 -name 'dispatch-*.txt' ! -user "$$uid" 2>/dev/null | wc -l | tr -d ' ')" -ne 0 ]; then echo "  (The papers in held/ are not the queue's own papers: their owner is not the one ls -ln showed in outbound-queue/. A copy is yours; the original is not. The procedure says MOVE them, unaltered. From labs/week-14: bash report-for-duty.sh stages the exchange afresh, then use mv, Task 4 step 2, and make -C check m4 again.)"; exit 1; fi
	@test -f "$(ORDER)" || { echo "  (No cancellation order is filed at ~/enginehouse/exchange/cancellation-order. The procedure's step 3 wants one. Task 4 step 3. Then make -C check m4 again.)"; exit 1; }
	@nd="$$(printf '%s' '$(NDISP_R)' | rev)"; \
	c="$$(sed -n 's/^dispatches held://p' "$(ORDER)" | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$c" != "$$nd" ]; then echo "  (The cancellation order does not give the count, on a line that begins dispatches held: -- the number you counted before you moved anything. Task 4 step 3. Then make -C check m4 again.)"; exit 1; fi; \
	if [ -z "$$(sed -n 's/^date://p' "$(ORDER)" | tr -d '[:space:]')" ]; then echo "  (The cancellation order has no date, on a line that begins date: -- the day you held them. Task 4 step 3. Then make -C check m4 again.)"; exit 1; fi
	@port="$$(printf '%s' '$(PORT_R)' | rev)"; \
	line="$$(timeout 3 bash -c 'exec 3<>"/dev/tcp/127.0.0.1/$$1" && cat <&3' sh "$$port" 2>/dev/null)"; \
	q="$$(printf '%s' "$$line" | sed -n 's/.*dispatches queued: \([0-9]*\).*/\1/p')"; \
	if [ -z "$$q" ]; then echo "  (The exchange's listener did not answer. It is a living process, and it does not survive wsl --shutdown, a reboot, or closing every Ubuntu window. From labs/week-14: bash report-for-duty.sh stages it afresh -- which also refills the queue, so stay it again, Task 4 -- then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$q" -ne 0 ]; then echo "  (The listener still counts $$q dispatch(es) queued. Ask it again with nc -d, Task 4 step 4, and look in outbound-queue/. Then make -C check m4 again.)"; exit 1; fi; \
	n="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A9 wants ONE number: dispatches queued, as the port says it AFTER the queue is stayed. Task 4 step 4. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$q" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$(printf '%s' '$(NDISP_R)' | rev)" ]; then echo "  (A9 is the count from BEFORE the queue was stayed -- that one is A8. A9 is what the port says now. Ask it again, Task 4 step 4. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A9 is not what the port says now. Ask it with nc -d, exactly as Task 4 step 4 shows, and copy the number after dispatches queued. Then make -C check m4 again.)"; exit 1
	@n="$$(sed -n 's/^A10://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A10 wants ONE number: how many papers are in held/ now. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A10://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	nh="$$(ls "$(HELD)" 2>/dev/null | grep -c '^dispatch-.*[.]txt$$')"; \
	if [ "$$x" -eq "$$nh" ]; then exit 0; fi; \
	if [ "$$x" -eq 0 ]; then echo "  (A10 is the count of outbound-queue/, now empty. A10 wants held/: count the papers there with ls and wc -l, Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A10 is not how many papers are in held/ now. Count them with ls and wc -l, exactly as Task 4 step 5 shows. Then make -C check m4 again.)"; exit 1
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
