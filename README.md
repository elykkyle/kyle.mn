# Cloud Resume Challenge

## Objective

Utilize technologies commonly used in DevOps to deploy and maintain personal resume website.
I chose to use AWS, Terraform and GitHub actions for my solution.

![diagram of solution](/frontend/src/images/kyle.mn.diagram.png)

## Requirements

- AWS Certification listed on resume ✅
- HTML: Site written in HTML ✅
- CSS: Site styled with CSS ✅
- Hosting: Deployed to Amazon S3 as a static site ✅
- HTTPS: site should load securely ✅
- CDN: Utilize a CDN to distribute site ✅
- DNS: utilize a custom domain name ✅
- JavaScript: Visitor counter displaying # of visitors to site ✅
- Database: Store visitor count to database (DynamoDB) ✅
- API: Utilize API gateway to process requests from frontend ✅
- Python: Execute Lambda function to update database ✅
- Tests: Test python code and website with E2E tests ✅
- IAC: Use IAC tool (e.g. Terraform) to deploy manage all site infrastructure ✅
- Source Control: Utilize GitHub repository for source controle ✅
- CI/CD: Setup GitHub Actions to automate testing and deployment of code ✅

This is the repo for my personal site. Written simply in HTML and CSS.

- Site is hosted on AWS as a static site served from an S3 bucket.
- DNS provided by AWS Route 53.
- HTTPS provided by CloudFront with SSL Cert for domain.
- GitHub Actions automatically syncs changes to repo to S3 bucket and invalidates CloudFront cache.

**Link to project:** <https://kyle.mn/>

![screenshot of kyle.mn](/frontend/src/images/kyle.mn.png)

## How It's Made

**Tech used:** HTML, CSS

Here's where you can go to town on how you actually built this thing. Write as much as you can here, it's totally fine if it's not too much just make sure you write *something*. If you don't have too much experience on your resume working on the front end that's totally fine. This is where you can really show off your passion and make up for that ten fold.

## Lessons Learned

Learned a lot about CSS Grid while developing my site. I'd never really used it before. I found Grid to be incredibly useful, and not nearly as complicated as I had previously thought.
