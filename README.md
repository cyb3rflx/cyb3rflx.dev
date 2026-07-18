# cyb3rflx.dev

Personal portfolio site for Florian ([cyb3rflx](https://github.com/cyb3rflx)).

Static-first: Astro builds the site, a private S3 bucket stores it, and CloudFront
serves it over HTTPS. Deploys run through GitHub Actions using an OIDC-assumed IAM
role — no stored AWS keys.

## Repository layout

| Path                 | What                                                    |
| :------------------- | :------------------------------------------------------ |
| `site/`              | Astro 7 static portfolio site (Tailwind CSS v4)         |
| `infra/`             | Terraform — S3, CloudFront (OAC), ACM, Route 53, OIDC   |
| `.github/workflows/` | CI/CD — build → S3 sync → CloudFront invalidation        |
| `CLAUDE.md`          | Guidance for AI-assisted work in this repo              |

> `site/` has a built static homepage (Astro + Tailwind CSS v4) with the project
> list fetched from the GitHub API at build time. `infra/` has a Terraform
> remote-state backend and the Route 53 hosted zone; the ACM cert, CloudFront, S3
> site bucket, OIDC, and `.github/workflows/` are still planned. (A blog is out of
> scope for now.)

## Local development

Requires **Node.js ≥ 22.12**.

The build fetches the project list from the GitHub API, so it needs a
`GITHUB_TOKEN` in `site/.env` (a GitHub PAT — no scopes required for public repos).

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
