.PHONY: all clean preview watch setup clone-xp update-xp commit install template.html

all: resume.html

setup: clone-xp
clone-xp:
	@if [ -d "xp.css" ]; then \
		echo "xp.css already exists"; \
	else \
		echo "Cloning xp.css..."; \
		git clone https://github.com/akinevz2/xp.css.git xp.css; \
	fi

update-xp:
	@if [ ! -d "xp.css" ]; then \
		echo "Error: xp.css not found. Run 'make setup' first."; \
		exit 1; \
	fi
	@cd xp.css && \
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
	@if [ ! -d "xp.css/dist" ]; then \
		echo "Error: xp.css/dist directory not found. Please run:"; \
		echo "  cd xp.css && npm install && npm run build"; \
		exit 1; \
	fi
	pandoc resume.md \
		-o resume.html \
		--template=./template.html \
		--css=xp.css/dist/XP.css \
		--standalone \
		--self-contained

clean:
	rm -f resume.html resume.pdf

pdf: resume.html
	wkhtmltopdf resume.html resume.pdf

open: resume.html
	@echo "Starting preview server..."
	@cp resume.html index.html
	@npx -y serve -l 8087 

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
