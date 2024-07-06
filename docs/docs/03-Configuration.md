---
slug: /configuration
title: Configuration
---

## Environment variables

You can configure the database at runtime using various environment variables:

- `DATATUNES__SERVER__HOST` -
  host on which the database will be listening
  (default: `0.0.0.0`)
- `DATATUNES__SERVER__PORTS__S3` -
  port on which the database will be listening
  (default: `40000`)
- `DATATUNES__SERVER__PORTS__WEB` -
  port on which the web interface will be available
  (default: `40001`)
- `DATATUNES__URLS__WEB` -
  public URL of the web interface
  (default: `http://localhost:40001`)
- `DATATUNES__CREDENTIALS__ADMIN__USER` -
  username for the admin user
  (default: `admin`)
- `DATATUNES__CREDENTIALS__ADMIN__PASSWORD` -
  password for the admin user
  (default: `password`)
- `DATATUNES__CREDENTIALS__READONLY__USER` -
  username for the readonly user
  (default: `readonly`)
- `DATATUNES__CREDENTIALS__READONLY__PASSWORD` -
  password for the readonly user
  (default: `password`)
- `DATATUNES__CREDENTIALS__READWRITE__USER` -
  username for the readwrite user
  (default: `readwrite`)
- `DATATUNES__CREDENTIALS__READWRITE__PASSWORD` -
  password for the readwrite user
  (default: `password`)
- `DATATUNES__BUCKETS__MEDIA` -
  name of the bucket where raw media files are stored
  (default: `media`)
- `DATATUNES__BUCKETS__METADATA` -
  name of the bucket where metadata is stored
  (default: `metadata`)
