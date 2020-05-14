.PHONY: help install check test headers pull push site create over

SHELL=bash
WANT=gawk git tmux vim lua pandoc ncdu
SITE=../sehero.github.io

help: ## help
	@bash etc/help.sh $(MAKEFILE_LIST)

install: setup base tools website tex #fun ## install

setup:;   brew update
base:;    @sh etc/brew.sh gawk lua  
tools:;	  @sh etc/brew.sh git vim tmux htop mc tree ncdu 
fun:; 	  @sh etc/brew.sh cmatrix bsdames-osx 
website:; @sh etc/brew.sh  pandoc pandoc-citeproc 
tex: 
	@brew cask install basictex  # for text generation
	@brew cask upgrade 

check: ## look for missing executables
	@bash etc/missing.sh $(WANT)
	
test: ## test
	cd test; sh all.sh

headers: ## reset .md headers
	@find . -name '*.md'   \
	| grep -v ./doc.etc.doc \
	| bash etc/headers.sh

pull: ## download from Git
	@git pull

push: ## upload changes to Git
	@git commit -am "pushing"
	@git push
	@git status

CODE=$(shell ls src/*.lua | gawk '{sub(/^src/,"$(SITE)/src"); sub(/\.lua$$/,".html"); print}')
MD=$(shell   ls doc/*.md  | gawk '{sub(/^doc/,"$(SITE)/doc"); sub(/\.md$$/, ".html"); print}')

site:  create  #$(CODE) $(MD) over ## build site

create: $(SITE)
	@mkdir -p $(SITE)/src
	@mkdir -p $(SITE)/doc
	@cp -R doc/etc/ $(SITE)
	@touch $(SITE)/.nojekyll

over: $(SITE)/index.html
	@- cd $(SITE); make 

PAN=                     \
  -s                      \
  --mathjax                \
  --from=markdown           \
  --table-of-contents        \
  -V numberLines=true         \
  --template=doc/default.html5 \
  --indented-code-classes=lua,numberLines  

$(SITE)/index.html:  etc/index.md
	@pandoc $< -V path="" --metadata title="$(notdir $<)" $(PAN) -o $@

$(SITE)/src/%.html:  src/*.lua
	@gawk -f etc/2md.awk $< \
	| pandoc -V path="../" --metadata title="$(notdir $<)" $(PAN) -o $@

$(SITE)/doc/%.html:  doc/*.md
	@pandoc $< -V path="../" --metadata title="$(notdir $<)" $(PAN) -o $@
