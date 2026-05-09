FILE=dl_compilers
PANDOC_CMD=pandoc --shift-heading-level-by=-1 -t slidy -s -H mermaid.html --citeproc --bibliography=refs.bib $(FILE).md -o $(FILE).html

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
	ssh -J Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu khatchad@compsci.hunter.cuny.edu "rm -rf ~/public_html/media/$(FILE)"
	ssh -J Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu khatchad@compsci.hunter.cuny.edu "mkdir -p ~/public_html/media/$(FILE)"
	scp -J Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu $(FILE).html khatchad@compsci.hunter.cuny.edu:~/public_html/media/$(FILE)/index.html
	scp -J Raffi.Khatchadourian99@eniac.cs.hunter.cuny.edu -rC graphics khatchad@compsci.hunter.cuny.edu:~/public_html/media/$(FILE)
	echo "Deployed to: http://cs.hunter.cuny.edu/~khatchad/media/$(FILE)"
