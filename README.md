# joe-hill.me

Personal landing page and resume. Served from two environments:

| Environment | URL | Hosting |
|---|---|---|
| Primary | https://joe-hill.me | AWS CloudFront + S3 |
| Mirror | https://local.joe-hill.me | Proxmox homelab / MinIO |

Each environment shows a small banner linking to the other.

## Stack

Pure HTML, CSS, and vanilla JavaScript — no framework, no build tool dependencies. The `build.sh` script injects an environment-specific banner into the static files before deployment.

## Local development

Open `src/index.html` directly in a browser, or use any static file server:

```bash
npx serve src
```

## Building

```bash
./build.sh aws    # outputs to dist/ with AWS banner
./build.sh local  # outputs to dist/ with local mirror banner
```

## Deployment

Deployments are automated via GitHub Actions on push to `master`. Two jobs run in parallel:

- **deploy-aws** — builds for `aws`, syncs `dist/` to S3, invalidates CloudFront
- **deploy-local** — builds for `local`, syncs `dist/` to homelab MinIO via the exposed MinIO API

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user with S3 write + CloudFront invalidation permissions |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret key |
| `AWS_S3_BUCKET` | S3 bucket name (e.g. `joe-hill.me`) |
| `AWS_CF_DISTRIBUTION_ID` | CloudFront distribution ID (from Terraform output) |
| `MINIO_ENDPOINT` | MinIO API URL exposed via Nginx (e.g. `https://minio-api.joe-hill.me`) |
| `MINIO_ACCESS_KEY` | MinIO access key |
| `MINIO_SECRET_KEY` | MinIO secret key |
| `MINIO_BUCKET` | MinIO bucket name |

## AWS Infrastructure

Managed with Terraform in [`terraform/`](terraform/).

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After `apply`, grab the `cloudfront_distribution_id` and `s3_bucket_name` outputs and add them as GitHub Secrets.

> **Note:** Your domain registrar's nameservers must point to the Route 53 hosted zone for `joe-hill.me` before DNS records will resolve.

## Local infrastructure (homelab)

1. **MinIO bucket** — create a bucket for the site files
2. **MinIO access key** — create a key scoped to that bucket (read/write)
3. **Nginx Proxy Manager** — add a proxy host for `minio-api.joe-hill.me` → MinIO container port 9000, with SSL via Let's Encrypt
4. **Route 53** — add an `A` record for `local.joe-hill.me` pointing to your home IP (use a DDNS solution if your IP is dynamic)
5. **Nginx Proxy Manager** (serving the site) — add a proxy host for `local.joe-hill.me` → MinIO static hosting port, with SSL
