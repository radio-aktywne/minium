---
slug: /configuration
title: Configuration
---

## Environment variables

You can configure the database at runtime using various environment variables:

- `MEDIATUNES__SERVER__HOST` -
  host on which the database will be listening
  (default: `0.0.0.0`)
- `MEDIATUNES__SERVER__PORTS__S3` -
  port on which the database will be listening
  (default: `40000`)
- `MEDIATUNES__SERVER__PORTS__WEB` -
  port on which the web interface will be available
  (default: `40001`)
- `MEDIATUNES__URLS__WEB` -
  public URL of the web interface
  (default: `http://localhost:40001`)
- `MEDIATUNES__CREDENTIALS__ADMIN__USER` -
  username for the admin user
  (default: `admin`)
- `MEDIATUNES__CREDENTIALS__ADMIN__PASSWORD` -
  password for the admin user
  (default: `password`)
- `MEDIATUNES__CREDENTIALS__READONLY__USER` -
  username for the readonly user
  (default: `readonly`)
- `MEDIATUNES__CREDENTIALS__READONLY__PASSWORD` -
  password for the readonly user
  (default: `password`)
- `MEDIATUNES__CREDENTIALS__READWRITE__USER` -
  username for the readwrite user
  (default: `readwrite`)
- `MEDIATUNES__CREDENTIALS__READWRITE__PASSWORD` -
  password for the readwrite user
  (default: `password`)
