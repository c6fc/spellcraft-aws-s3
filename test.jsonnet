/*
	`npm run test` and `npm run cli` always links the current module as 'foo'.
	
	This file should manifest all the exposed features of your module
	so users can see examples of how they are used, and the output they
	generate.
*/

local s3 = import "s3.libsonnet";

{
	's3_default.tf.json': s3.bucket("test-bucket-default", "us-east-1"),
	's3_static-site.tf.json': s3.bucket("test-bucket-static-site", "us-east-1", {
		type: "static-site"
	}),
	's3_log-storage.tf.json': s3.bucket("test-bucket-log-storage", "us-east-1", {
		type: "log-storage"
	}),
}