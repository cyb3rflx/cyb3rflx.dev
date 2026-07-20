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

> `site/` (Astro + Tailwind CSS v4, project list from the GitHub API at build time)
> is **live** on AWS — private S3 + CloudFront (OAC) + ACM + Route 53, all via
> Terraform. Deploys are currently manual (`aws s3 sync`); the GitHub OIDC role and
> `.github/workflows/` CI/CD are still planned. (A blog is out of scope for now.)

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

Infrastructure is managed with Terraform (never the AWS console). Content is
currently deployed manually: `npm run build`, then `aws s3 sync site/dist/
s3://cyb3rflx-website/` plus a CloudFront invalidation.

_Planned:_ a push to the default branch triggers GitHub Actions, which assumes an AWS
IAM role via OIDC, syncs the build to S3, and invalidates the CloudFront distribution
— no stored AWS keys.

## License

Not licensed for reuse. All rights reserved.
