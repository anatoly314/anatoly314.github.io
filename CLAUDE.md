# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hugo-based personal blog (anatoly.dev) using the PaperMod theme. Hosted on GitHub Pages with automatic deployment via GitHub Actions.

## Commands

```bash
# Development server (includes drafts)
hugo server -D

# Production build
hugo --gc --minify

# Create new blog post
hugo new posts/YYYY/MM/post-name.md
```

## Architecture

### Content Structure
- `content/posts/YYYY/MM/*.md` - Blog posts organized by year/month
- `content/projects/*.md` - Project pages that link to related posts via `tag` front matter
- `content/pages/*.md` - Static pages (about)

### Layout Customizations
Custom layouts override PaperMod theme defaults:
- `layouts/_default/list.html` - Modified post list with tag display in post previews
- `layouts/projects/list.html` - Card-based project listing sorted by `priority` param
- `layouts/projects/single.html` - Project detail page showing related posts by matching `tag`

### Styling
- `assets/css/extended/theme-vars-override.css` - Theme color overrides
- `static/css/projects.css` - Project-specific styles
- `static/layout/tags.css` - Tag styling for post lists

## Content Conventions

### Blog Post Front Matter
```yaml
---
title: "Post Title"
date: 2025-08-23T10:00:00Z
draft: false
tags: ["tag1", "tag2"]
---
```

### Project Front Matter
```yaml
---
title: "Project Name"
date: 2025-01-01T10:00:00Z
draft: false
description: "Project summary"
tag: "project-tag"      # Links to posts with this tag
priority: 100           # Higher = appears first in list
---
```

## Deployment

Push to `master` triggers GitHub Actions workflow (`.github/workflows/hugo.yml`) which:
1. Builds with Hugo extended v0.152.2
2. Deploys to GitHub Pages

PaperMod requires Hugo >= 0.146.0 - check `HUGO_VERSION` in workflow if updating.
