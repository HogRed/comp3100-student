# Week 5 wax-seal checkpoints. Run from labs/week-05:  make -C check m1
#
# (Any string in here that would give an answer away is written BACKWARDS and
# un-reversed at check time with `rev`, exactly as weeks 2-4 do, so a glance
# at this file spoils nothing.)
#
# Every answer is read with `sed -n 's/^AN://p'` so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a [0-9]
# guard, and a blank answer seals the milestone.
#
# m1 and m2 compare the student's own numbers against each other rather than
# against a fixed figure. The unguarded total is nondeterministic by design,
# so there is no expected value to test for -- only a shape (two DISTINCT
# totals, both short of what the looms wove) and then, once guarded,
# exactness against that same student's own counts.
SEAL := bash ../../lib/seal.sh 05

m1:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-05: cp check/answers-template check/answers.txt)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 2 ]; then echo "  (A1 wants BOTH counts -- what loom north wove and what loom south wove -- as two numbers on the one A1 line.)"; exit 1; fi
	@n="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 2 ]; then echo "  (A2 wants the ledger total from TWO separate unguarded runs, as two numbers on the one A2 line. If you have only run it once, run it again.)"; exit 1; fi
	@set -- $$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); woven=$$(($$1 + $$2)); \
	set -- $$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); t1="$$1"; t2="$$2"; \
	if [ "$$woven" -le 0 ]; then echo "  (A1's two counts add up to nothing. Copy them from the run's own first two lines.)"; exit 1; fi; \
	if [ "$$t1" -eq "$$t2" ]; then echo "  (A2 carries the same number twice. Two unguarded runs agreeing to the digit is the one result this task does not produce -- check that you ran it a second time and copied the SECOND total, not the first one twice.)"; exit 1; fi; \
	if [ "$$t1" -ge "$$woven" ] || [ "$$t2" -ge "$$woven" ]; then echo "  (A2 carries a total that is not short of the $$woven entries A1 says the looms wove between them. An unguarded ledger loses entries; it never gains them. Check that you copied the third line of the run and not a loom's own count.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-05: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -f ../starter/twin-looms.c || { echo "  (starter/twin-looms.c is missing. From labs/week-05: git checkout -- starter/twin-looms.c)"; exit 1; }
	@grep -q pthread_mutex_lock ../starter/twin-looms.c || { echo "  (Nothing in starter/twin-looms.c takes the key before the shared line yet. This seal reads the source you actually edited, and a declaration on its own is not a guard: the lock has to be TAKEN before the shared increment. Task 2 prints the three lines.)"; exit 1; }
	@grep -q pthread_mutex_unlock ../starter/twin-looms.c || { echo "  (starter/twin-looms.c takes the key and never gives it back -- a lock with no matching unlock. Check that the unlock is inside the loop, immediately after the shared line, and not commented out.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 2 ]; then echo "  (A3 is measured against A1, and A1 does not yet carry both looms' counts. Fill A1 from Task 1 first, then claim this seal.)"; exit 1; fi
	@n="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 1 ]; then echo "  (A3 is still blank -- the ledger total your GUARDED build printed, as a numeral.)"; exit 1; fi
	@set -- $$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); woven=$$(($$1 + $$2)); \
	total="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$total" -ne "$$woven" ]; then echo "  (A3 is $$total, and A1 says the two looms wove $$woven entries between them. A guarded ledger holds every entry and no more, so those two numbers must agree exactly. If A3 came from a Task 1 run, replace it; if your guarded build really is short, the lock is not around the shared line, or the source was never rebuilt.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-05: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -n "$$(sed -n 's/^A4://p' answers.txt | tr -d '[:space:]')" || { echo "  (A4 is still blank -- the two row labels that differ between the two documents, both on the one A4 line.)"; exit 1; }
	@a4="$$(sed -n 's/^A4://p' answers.txt)"; n=0; \
	if printf '%s' "$$a4" | grep -iqF "$$(printf 'ssol detupmoc' | rev)"; then n=$$(($$n + 1)); fi; \
	if printf '%s' "$$a4" | grep -iqF "$$(printf 'ecnalab tcirtsid' | rev)"; then n=$$(($$n + 1)); fi; \
	if [ "$$n" -eq 0 ]; then echo "  (A4 names neither of the two rows that differ. Narrow the diff to the table itself, then read the two lines it marks. A row's label is the words before the dots -- copy them as the ledger spells them.)"; exit 1; fi; \
	if [ "$$n" -eq 1 ]; then echo "  (A4 names only ONE of the two rows that differ. There are two. Read the narrowed diff again.)"; exit 1; fi
	@sed -n 's/^A5://p' answers.txt | grep -Eq '[0-9]' || { echo "  (A5 carries no figure -- the sum you worked out yourself from the four district figures in the working papers, un-rounded, in numerals.)"; exit 1; }
	@want="$$(printf '060.412' | rev)"; near8="$$(printf '80.412' | rev)"; near6="$$(printf '60.412' | rev)"; \
	got=0; g8=0; g6=0; \
	for x in $$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+\.[0-9]+'); do \
	  if [ "$$x" = "$$want" ]; then got=1; fi; \
	  if [ "$$x" = "$$near8" ]; then g8=1; fi; \
	  if [ "$$x" = "$$near6" ]; then g6=1; fi; \
	done; \
	if [ "$$got" -eq 0 ]; then \
	  if [ "$$g8" -eq 1 ]; then \
	    echo "  (A5 carries a figure copied off one of the two documents rather than one you worked out. Add the four district figures yourself, exactly as the working papers write them -- every digit they give you -- and write the sum down BEFORE you round it.)"; \
	  elif [ "$$g6" -eq 1 ]; then \
	    echo "  (That is the right sum with its last place dropped -- nothing was rounded and nothing is wrong with your addition. The four district figures carry one more decimal place than the ledger row prints, so their sum carries it too. A5 wants the sum AS YOUR ADDITION PRODUCED IT, with every decimal place it has, the last one included; read that place off your paper and copy it in. The sum rounded to the row's precision is a separate number and it belongs in your logbook.)"; \
	  else \
	    echo "  (A5 is not the total the working papers give. Check two things: that you used all four district figures, and that you copied every digit of each one. A single dropped digit is the usual cause.)"; \
	  fi; \
	  exit 1; \
	fi
	@$(SEAL) 3

.PHONY: m1 m2 m3
