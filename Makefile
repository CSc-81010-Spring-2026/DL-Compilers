FILE=dl_compilers
PANDOC_CMD=pandoc --shift-heading-level-by=-1 -t slidy -s -H header.html --citeproc -M link-citations=true --bibliography=refs.bib $(FILE).md -o $(FILE).html

# Deploy target. Default works on any machine with SSH access to compsci.
# Off-campus, route through eniac:
#   make deploy JUMP_HOST=Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu
REMOTE?=khatchad@compsci.hunter.cuny.edu
JUMP_HOST?=
SSH_J=$(if $(JUMP_HOST),-J $(JUMP_HOST),)
RSYNC_E=$(if $(JUMP_HOST),-e "ssh -J $(JUMP_HOST)",)

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
	ssh $(SSH_J) $(REMOTE) "mkdir -p ~/public_html/media/$(FILE)/graphics"
	rsync $(RSYNC_E) $(FILE).html $(REMOTE):~/public_html/media/$(FILE)/index.html
	rsync $(RSYNC_E) -a --delete-after graphics/ $(REMOTE):~/public_html/media/$(FILE)/graphics/
	echo "Deployed to: http://cs.hunter.cuny.edu/~khatchad/media/$(FILE)"
