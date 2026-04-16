output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — needed for cache invalidations in CI/CD"
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name — used in GitHub Actions deploy step"
  value       = aws_s3_bucket.site.id
}

output "site_url" {
  description = "Primary site URL"
  value       = "https://${var.domain}"
}
