.PHONY: serve build clean new

# Local dev server with drafts and live reload
serve:
	hugo server -D

# Production build, same flags as the GitHub Actions workflow
build:
	hugo --gc --minify

clean:
	rm -rf public resources/_gen

# Usage: make new SLUG=my-post-name
new:
	@test -n "$(SLUG)" || { echo "usage: make new SLUG=my-post-name"; exit 1; }
	hugo new posts/$(shell date +%Y)/$(shell date +%m)/$(SLUG).md
