%.html: %.md
	pandoc $< --template template.html \
		  --css template.css        \
		  --css  style.css --toc --toc-depth 4  --from=markdown \
		  --metadata title="SE for super heroes: an AI approach" \
		  --indented-code-classes=lua,numberLines \
	 	  -o $@ 

