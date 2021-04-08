#
# Makefile for running captures, exporting results, cleaning working directory
#
# 

EXPORTDIR=/afs/inf.ed.ac.uk/group/security/data/detgen
SHELL=/bin/bash

usage:
	@echo "make export           -- copy/update all pcap files to ${EXPORTDIR}"
	@echo "make clean            -- remove all local copies of pcap files"
	@echo "make capture.<name>   -- run capture for all instances of <name>"

capture.%:
	@echo "Running capture for $*..."
	for dir in capture-*-$*; do (echo "Capturing in $$dir"; cd $$dir; ../capture.sh); done

export:
	@echo "Copying data pcap files to ${EXPORTDIR}..."
	rsync -rmv --include='*.pcap' --include='*/' --exclude='*'  ./ "${EXPORTDIR}"

clean:
	find . -name '*.pcap'
	(read -p "DELETE all the pcap files above.  Are you sure? <Y/n> " prompt; if [ "$$prompt" == "Y" ]; then find . -name '*.pcap' -or -type d -empty -delete;fi)

