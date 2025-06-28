# SpellCraft S3 Bucket Module

[![NPM version](https://img.shields.io/npm/v/@c6fc/spellcraft-aws-s3.svg?style=flat)](https://www.npmjs.com/package/@c6fc/spellcraft-aws-s3)
[![License](https://img.shields.io/npm/l/@c6fc/spellcraft-aws-s3.svg?style=flat)](https://opensource.org/licenses/MIT)

A sophisticated module for rapidly producing consistent, secure-by-default buckets with minimal code.

## Features

A module for quickly manifesting secure-by-default AWS S3 buckets in Terraform, requring only the options you want distinct from defaults.

## Exposed module functions

Exposes the following functions to JSonnet through the import module:

### s3.bucket(name, region, options = {})

A simple method with no arguments, executed via JavaScript

#### Returns:

A complex, full-file terraform configuration for a bucket of the chosen configuration.

## Installation

This module depends on providers created by @c6fc/spellcraft-aws-auth. Install both plugins into your SpellCraft project:

```bash
# Create a SpellCraft project if you haven't already
npm install --save @c6fc/spellcraft

# Install and expose this module with default name s3
npx spellcraft importModule @c6fc/spellcraft-aws-s3

# Install and expose @c6fc/spellcraft-aws-auth module with default name awsterraform
npx spellcraft importModule @c6fc/spellcraft-aws-terraform
```

Once installed, you can load the module into your JSonnet files by the name you specified with `importModule`:

```jsonnet
local modules = import "modules";

{
	'providers.tf.json': {
		provider: modules.awsterraform.providerRegions("us-west-2")
	},

	// A bucket with defaults only
	's3-default-bucket.tf.json': modules.s3.bucket("my-bucket-defaults", "us-west-2"),

	// A bucket using 'static-site' defaults
	's3-static-site-bucket.tf.json': modules.s3.bucket("my-bucket-static", "us-west-2", {
		type: 'static-site'
	}),

	// A bucket with some default overrides
	's3-bucket-overrides.tf.json': modules.s3.bucket("my-bucket-overrides", "us-west-2", {
		server_side_encryption: false,
		allow_insecure_access: true
	}),
}
```

## Defaults

Without any `options` specified, this module will manifest an S3 bucket with:
*	Server-side encryption with KMS
*	Require TLS v1.2+ for access
*	S3 Public access block enabled
*	Bucket Owner as Request Payer
*	Versioning Disabled

## Types

This module exposes common S3 bucket configurations as 'types' with standard configurations. Below are the `types` that are available in this module:

### static-site

-	`public_access_block`: false
-	`server_side_encryption`: false,
-	`website`: true
-	`policy_statements`: Add a policy to allow s3:GetObject to any principal on any object.

### log-storage

-	`acl`: log-delivery-write

## Options

Below are computed options. Anything not documented here will be passed directly as an attribute of `aws_s3_bucket`.

### acceleration_status (default: false)

Specifies whether the S3 bucket should be configured with S3 bucket acceleration

Allowed values: `Enabled | Suspended`

### acl (default: false)

A canned ACL to configure on the Bucket. This can only be specified if `object_ownership` is not `BucketOwnerEnforced`.

### allow_insecure_access (default: false)

If true, this module omits a supplementary bucket policy 'Deny' statement that prevents access when not accessed with TLS v1.2+. In other words, `true` allows S3 bucket access over HTTP.

### cors_rule (default: [])

An array of CORS rules objects to define cross-origin resource access. Refer to [aws_s3_bucket_cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) for supported arguments.

### lifecycle_rule (default: [])

An array of lifecycle rules objects. Refer to [aws_s3_bucket_lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) for supported arguments.

### logging (default: "")

Provide the name (not ARN) of another S3 bucket for object access logs.

### object_lock_configuration (default: [])

An array of S3 object lock rules objects. Refer to [aws_s3_bucket_object_lock_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) for supported arguments.

### object_ownership (defaults: "BucketOwnerEnforced")

Specifies the object ownership strategy for files uploaded to the bucket.

Allowed options: `BucketOwnerEnforced | BucketOwnerPreferred | ObjectWriter`

### policy_statements (default: [])

An array of IAM policy statements to apply as the bucket policy. These should match what IAM would accept natively; do not use Terraform's policy objects.

### public_access_block (default: true)

Configures the S3 public access block.

Allowed options: `true | false`

### replication_configuration (default: [])

An array of S3 replication rules objects. Refer to [aws_s3_bucket_replication_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) for supported arguments.

### request_payer (default: "BucketOwner")

Determines who pays for requests to this bucket.

Allowed options: `BucketOwner | Requester`

### server_side_encryption (default: true)

Determines whether to use S3 Server Side Encryption. When true, it will provision a KMS CMK as the SSE strategy. When false, SSE will not be used.

Allowed options: `true | false`

### versioning (default: "Disabled")

Determines whether the bucket will be configured with object versioning enabled.

Allowed options: `Enabled | Suspended | Disabled`

### website (default: {})

Specifies a static website configuration. If options is `true`, it will use a default index document suffix of `index.html` and error document of `error.html`. Alternatively, you can pass an [aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) object.

## Documentation

You can generate JSDoc documentation for this plugin using `npm run doc`. Documentation will be generated in the `doc` folder.