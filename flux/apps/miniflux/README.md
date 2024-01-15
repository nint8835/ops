# Manual configuration
- Port forward the `db-1` container in the `miniflux` namespace
- Grab the connection URI from the `db-superuser` secret
- Connect locally and run `CREATE EXTENSION hstore;`
