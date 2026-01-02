---
slug: /usage
title: Usage
---

## Users

There are currently two users (besides `admin`):

- `readonly` user with read-only access to all buckets
- `readwrite` user with read-write access to all buckets

Default password for all users is `password`.

## Interacting with the storage

You can use any S3 compatible client to interact with the storage.
[`s5cmd`](https://github.com/peak/s5cmd) is a nice one.

For example, to list all files in the `default` bucket, you can run:

```sh
S3_ENDPOINT_URL='http://localhost:10210' \
    AWS_ACCESS_KEY_ID='readonly' \
    AWS_SECRET_ACCESS_KEY='password' \
    s5cmd ls s3://default/
```

## Web UI

You can access the web UI in your browser at port `10211`.
You can log in with any of the existing users and perform basic operations there.
