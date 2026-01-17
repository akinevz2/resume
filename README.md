# Resume Template

A pandoc HTML resume template using winxp.css for styling.

## Usage

```bash
cd resume
make
```

Or manually:

```bash
pandoc resume.md -o resume.html --template=template.html --css=winxp.css/winxp.css --standalone --self-contained
```

## Structure

- `template.html` - Pandoc HTML template
- `winxp.css/` - winxp.css stylesheet (cloned from GitHub)
- `resume.md` - Your resume content in Markdown
- `Makefile` - Build automation

## Initial Setup

Clone the winxp.css repository:

```bash
cd resume
git clone https://github.com/akinevz2/winxp.css.git winxp.css
```

## Keeping winxp.css Updated

To sync your fork with the upstream repository:

```bash
cd winxp.css
git remote add upstream https://github.com/botoxparty/XP.css.git
git fetch upstream
git merge upstream/master
git push origin main
```
