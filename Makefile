FILE=dl_compilers
PANDOC_CMD=pandoc --shift-heading-level-by=-1 -t slidy -s -H header.html --citeproc -M link-citations=true --bibliography=refs.bib $(FILE).md -o $(FILE).html

# Deploy target. Defined in ~/.ssh/config:
#   hunter-compsci       : direct (use on-campus, default).
#   hunter-compsci-jump  : via eniac (use off-campus: make deploy REMOTE=hunter-compsci-jump).
REMOTE?=hunter-compsci

all:
	$(PANDOC_CMD)
self-contained:
	$(PANDOC_CMD) --embed-resources
preview: all
	gio open $(FILE).html
clean:
	rm -rf $(FILE).html
open:
	gio open `git remote get-url origin`
deploy: all
	ssh $(REMOTE) "mkdir -p ~/public_html/media/$(FILE)/graphics"
	rsync $(FILE).html $(REMOTE):~/public_html/media/$(FILE)/index.html
	rsync -a --delete-after graphics/ $(REMOTE):~/public_html/media/$(FILE)/graphics/
	echo "Deployed to: http://cs.hunter.cuny.edu/~khatchad/media/$(FILE)"
