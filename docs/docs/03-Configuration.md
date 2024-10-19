---
slug: /configuration
title: Configuration
---

## Environment variables

You can configure the database at runtime using various environment variables:

- `MINIUM__SERVER__HOST` -
  host on which the database will be listening
  (default: `0.0.0.0`)
- `MINIUM__SERVER__PORTS__S3` -
  port on which the database will be listening
  (default: `10210`)
- `MINIUM__SERVER__PORTS__WEB` -
  port on which the web interface will be available
  (default: `10211`)
- `MINIUM__URLS__WEB` -
  public URL of the web interface
  (default: `http://localhost:10211`)
- `MINIUM__CREDENTIALS__ADMIN__USER` -
  username for the admin user
  (default: `admin`)
- `MINIUM__CREDENTIALS__ADMIN__PASSWORD` -
  password for the admin user
  (default: `password`)
- `MINIUM__CREDENTIALS__READONLY__USER` -
  username for the readonly user
  (default: `readonly`)
- `MINIUM__CREDENTIALS__READONLY__PASSWORD` -
  password for the readonly user
  (default: `password`)
- `MINIUM__CREDENTIALS__READWRITE__USER` -
  username for the readwrite user
  (default: `readwrite`)
- `MINIUM__CREDENTIALS__READWRITE__PASSWORD` -
  password for the readwrite user
  (default: `password`)
