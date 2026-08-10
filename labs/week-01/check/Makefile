# Week 1 wax-seal checkpoints. Run from labs/week-01:  make -C check m1
SEAL := bash ../../lib/seal.sh 01

m1:
	@test -d $$HOME/enginehouse && uname -a >/dev/null && strace -c -o /dev/null ls && gcc --version >/dev/null && man -w 2 read >/dev/null
	@$(SEAL) 1

m2:
	@test -f $$HOME/enginehouse/inbox/punch-card-fragment.txt
	@wc -l < $$HOME/enginehouse/inbox/punch-card-fragment.txt | grep -qx '12'
	@$(SEAL) 2

m3:
	@man -w 2 write >/dev/null && man -w 1 crontab >/dev/null
	@$(SEAL) 3

.PHONY: m1 m2 m3
