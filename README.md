# cyb3rflx.dev

Personal portfolio and blog for Florian ([cyb3rflx](https://github.com/cyb3rflx)).

Static-first: Astro builds the site, a private S3 bucket stores it, and CloudFront
serves it over HTTPS. Deploys run through GitHub Actions using an OIDC-assumed IAM
role — no stored AWS keys.

## Repository layout

| Path                 | What                                                    |
| :------------------- | :------------------------------------------------------ |
| `site/`              | Astro 7 static site — blog + project showcase           |
| `infra/`             | Terraform — S3, CloudFront (OAC), ACM, Route 53, OIDC   |
| `.github/workflows/` | CI/CD — build → S3 sync → CloudFront invalidation        |
| `CLAUDE.md`          | Guidance for AI-assisted work in this repo              |

> `site/` is scaffolded. `infra/` and `.github/workflows/` are planned.

## Local development

Requires **Node.js ≥ 22.12**.

```sh
cd site
npm install
npm run dev       # http://localhost:4321
npm run build     # static output to site/dist/
npm run preview
```

## Deployment

Push to the default branch triggers GitHub Actions, which assumes an AWS IAM role via
OIDC, syncs the build to S3, and invalidates the CloudFront distribution. All
infrastructure is managed with Terraform — never the AWS console. _(planned)_

## License

Not licensed for reuse. All rights reserved.
