FILE=dl_compilers
PANDOC_CMD=pandoc --shift-heading-level-by=-1 -t slidy -s -H header.html --citeproc -M link-citations=true --bibliography=refs.bib $(FILE).md -o $(FILE).html

# SSH jump host for off-campus deploys. Override with `make deploy JUMP_HOST=`
# (empty) when on the internal network to connect directly to compsci.
JUMP_HOST?=Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu
SSH_J=$(if $(JUMP_HOST),-J $(JUMP_HOST),)
REMOTE=khatchad@compsci.hunter.cuny.edu

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
	ssh $(SSH_J) $(REMOTE) "rm -rf ~/public_html/media/$(FILE)"
	ssh $(SSH_J) $(REMOTE) "mkdir -p ~/public_html/media/$(FILE)"
	scp $(SSH_J) $(FILE).html $(REMOTE):~/public_html/media/$(FILE)/index.html
	scp $(SSH_J) -rC graphics $(REMOTE):~/public_html/media/$(FILE)
	echo "Deployed to: http://cs.hunter.cuny.edu/~khatchad/media/$(FILE)"
