# Microsoft Store listing copy

Copy for the AudioShare listing in Partner Center, product
[9MX0W331FVWF](https://partner.microsoft.com/zh-cn/dashboard/products/9MX0W331FVWF/overview).

One file per listing language, named after the locale Partner Center uses.
Each file holds the three fields the listing form asks for:

- **Display name** — max 50 characters.
- **Description** — max 3000 characters.
- **What's new** — max 3000 characters.

## Which languages ship

The 2.3.0 listing is defined for **five** languages only:

| Locale | Copy |
| --- | --- |
| `en-us` | [en-us.md](en-us.md) |
| `zh-cn` | [zh-cn.md](zh-cn.md) |
| `fr-fr` | [fr-fr.md](fr-fr.md) |
| `ja-jp` | [ja-jp.md](ja-jp.md) |
| `es-es` | [es-es.md](es-es.md) |

Markets without a listing of their own fall back to the English one, so the
other 23 files in this folder stay unpublished for now. They are kept because
the copy is already written and translating more of them later is a copy-paste
job, not a writing job.

This is a listing decision only. The MSIX package still ships the app in all
28 languages, because those are the app's own UI translations and have
nothing to do with how many languages the store page is written in.

## Applying it

1. Open the product, go to **Store listing**, and pick the listing language.
2. Paste the matching field from the file for that locale.
3. For the screenshots, upload the two marketing images for that locale from
   `docs/store-shots/`. The English images work for every Latin-script
   listing, the Chinese ones for the Chinese listing.
4. Leave the privacy policy URL alone — it already points at the published
   policy and covers every version from 2.2.2 onwards.
5. Open **Packages** and upload `dist/audioshare-<version>.msix`.
6. Press **Submit for certification**.

## Adding a listing language

Partner Center lets a listing be copied from an existing one. Add the new
locale under **Store listing > Add language**, then paste the fields from the
matching file here and upload its screenshots.

## Note on the copy

These descriptions were written by Claude, like the app translations they
describe. They are accurate to the code, but a native speaker should read them
before they go live.
