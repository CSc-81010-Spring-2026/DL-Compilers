FILE=dl_compilers
PANDOC=pandoc --shift-heading-level-by=-1 -t slidy -s -H header.html --citeproc -M link-citations=true --bibliography=refs.bib $(FILE).md

# Deploy target. REMOTE is an ssh alias defined in ~/.ssh/config. Any jump-host
# routing (e.g. off-campus) is handled there, not here.
REMOTE?=compsci
DIST?=dist

# All targets are phony — none produce a file named after the target. (Without
# this, `dist` would be skipped once the dist/ directory exists.)
.PHONY: all self-contained dist preview clean open deploy

all:
	$(PANDOC) -o $(FILE).html
self-contained:
	$(PANDOC) --embed-resources -o $(FILE).html
# Build the distributable: self-contained HTML + a source archive of the
# committed tree, both under $(DIST)/ (e.g. for an OER deposit).
dist:
	mkdir -p $(DIST)
	$(PANDOC) --embed-resources -o $(DIST)/$(FILE).html
	@grep -q 'data:text/javascript' $(DIST)/$(FILE).html || { echo "ERROR: slidy.js not embedded (network fetch failed?); removing incomplete $(DIST)/$(FILE).html" >&2; rm -f $(DIST)/$(FILE).html; exit 1; }
	git archive --format=zip -o $(DIST)/$(FILE)-src.zip HEAD
preview: all
	gio open $(FILE).html
clean:
	rm -rf $(FILE).html $(DIST)
open:
	gio open `git remote get-url origin`
deploy: all
	ssh $(REMOTE) "mkdir -p ~/public_html/media/$(FILE)/graphics"
	rsync $(FILE).html $(REMOTE):~/public_html/media/$(FILE)/index.html
	rsync -a --delete-after graphics/ $(REMOTE):~/public_html/media/$(FILE)/graphics/
	echo "Deployed to: http://cs.hunter.cuny.edu/~khatchad/media/$(FILE)"
