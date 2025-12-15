---
title: "IntelliJ IDEA: White Markdown Preview with Dark Theme"
date: 2025-09-19T01:00:00Z
draft: false
tags: ["intellij", "ide", "markdown", "productivity", "development-tools"]
---

*Note: This post preserves and references the solution from [Ivan Aloneguid's original article](https://www.aloneguid.uk/posts/2021/04/intellij-white-markdown/). Full credit goes to the original author for this elegant solution.*

## Quick Solution

If you use IntelliJ IDEA with a dark theme but want a white Markdown preview, here's the simplest fix:

1. Go to **File → Settings → Languages & Frameworks → Markdown**
2. In the "Custom CSS" field, add:

```css
body {
  filter: invert(1);
  background: #fff;
  font-family: 'Segoe UI';
  font-size: 16px;
}

img {
  filter: invert(1);
}
```

3. Click **Apply** and **OK**

## Why This Works

The CSS uses `filter: invert(1)` to flip the dark preview to light. Images are also inverted to preserve their original appearance. You can customize the font family and size to your preference.

This gives you the best of both worlds: keep your dark IDE theme for coding while having a comfortable white background for reading Markdown documentation.

---

**Original Source**: [IntelliJ IDEA - Simplest White Markdown Theme](https://www.aloneguid.uk/posts/2021/04/intellij-white-markdown/) by Ivan Aloneguid