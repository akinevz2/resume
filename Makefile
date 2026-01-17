.PHONY: all clean preview watch setup clone-winxp update-winxp commit install

all: resume.html

setup: clone-winxp

clone-winxp:
	@if [ -d "winxp.css" ]; then \
		echo "winxp.css already exists"; \
	else \
		echo "Cloning winxp.css..."; \
		git clone https://github.com/akinevz2/winxp.css.git winxp.css; \
	fi

update-winxp:
	@if [ ! -d "winxp.css" ]; then \
		echo "Error: winxp.css not found. Run 'make setup' first."; \
		exit 1; \
	fi
	@cd winxp.css && \
	if ! git remote | grep -q "^upstream$$"; then \
		echo "Adding upstream remote..."; \
		git remote add upstream https://github.com/botoxparty/XP.css.git; \
	fi && \
	echo "Fetching upstream changes..." && \
	git fetch upstream && \
	echo "Merging upstream/master..." && \
	git merge upstream/master && \
	echo "Pushing to origin..." && \
	git push origin main

commit:
	git add -A && git commit

resume.html: resume.md template.html
	@if [ ! -d "winxp.css" ]; then \
		echo "Error: winxp.css directory not found. Please run:"; \
		echo "  make clone-winxp"; \
		exit 1; \
	fi
	pandoc resume.md \
		-o resume.html \
		--template=template.html \
		--css=winxp.css/winxp.css \
		--standalone \
		--embed-resources

clean:
	rm -f resume.html resume.pdf

pdf: resume.html
	wkhtmltopdf resume.html resume.pdf

preview: resume.html
	@echo "Starting preview server..."
	@npx -y serve -l 8000 .

watch:
	@echo "Watching for changes..."
	@while true; do \
		inotifywait -e modify resume.md template.html 2>/dev/null && \
		make resume.html && \
		echo "Rebuilt resume.html"; \
	done

install: resume.html
	@echo "Installing resume to frontend..."
	@mkdir -p ../frontend/public
	@cp resume.html ../frontend/public/resume.html
	@echo "Resume installed to frontend/public/resume.html"
