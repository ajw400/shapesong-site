# shapesong.com

The small website of the Shapesong app: plain HTML and CSS, no build step, no scripts, no cookies.

## What is where

| Page | File | Address |
|---|---|---|
| Home | `index.html` | https://shapesong.com/ |
| Privacy notice | `privacy/index.html` | https://shapesong.com/privacy |
| Contact and company details | `contact/index.html` | https://shapesong.com/contact |
| Page not found | `404.html` | (any address that does not exist) |

Each page holds the Dutch text first and the English text below it (the part marked `lang="en"`).
`style.css` holds the look for every page. The pictures come from the app's icon and the Play feature graphic.
`hosting/` holds how the site runs on the Hetzner server: nginx in a small container behind the app's kamal-proxy,
which also fetches the certificates. `CNAME` is left from GitHub Pages, the first host.

## Changing a sentence and publishing again

1. Open the page's file in a text editor (TextEdit in plain-text mode, or VS Code).
2. Find the sentence and change only the words between the tags, for example between `<p>` and `</p>`.
   Keep `&amp;` for "&", and leave the tags themselves alone.
3. Save the file, then in Terminal:

   ```
   cd ~/code/ajw400/shapesong-site
   git commit -am "Change the sentence about …"
   git push
   ```

4. Publish it on the server (since 18 November 2026 the site runs on the Hetzner server, beside the app):

   ```
   source ~/.shapesong-deploy.env
   BUNDLE_GEMFILE=~/code/ajw400/hc-wt/december/api/Gemfile bundle exec kamal deploy -c hosting/deploy.yml
   ```

   Reload the page to check (on a phone you may need to reload twice).

## The privacy notice

`privacy/index.html` shows the app's notice word for word, in both languages, from the app repository's
`docs/08-privacy.md` (sections 6 and 7). When the notice gets a new version, change it there first, then
copy the new text here and change the version and date line under each title. The address
https://shapesong.com/privacy is entered in Google Play and App Store Connect, so the file must stay where it is.

## Rules for this site

- No cookies, analytics, trackers, forms, or anything loaded from another site (fonts, scripts, videos, maps).
  If any of that is ever added, the "Deze website / This website" section of the privacy page must change first.
- The site is for parents and teachers. The app is not available yet: say "coming soon", and name no prices.
