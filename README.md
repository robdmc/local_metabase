# Local Metabase
This project uses docker to create a locally running instance of metabase.

This instance will have a built-in connection to any postgres instance running on your localhost.
You can also point it to any other database you'd like.

## Commands you can run
To see everything you can do run:
```bash
make help
```

## How do I
* Install and get started
  ```
  make bootstrap
  ```

* Run metabase
  ```
  make metabase
  ```

* Blow away and recover from backup file.
  ```
  make nuke
  make bootstrap
  make restore
  ```

* Run metabase in daemon mode
  ```
  make metabase_daemon
  ```

* Dump a backup of the internal metabase state (backup your queries)
  ```
  make backup
  ```

* Restore your metabase state from backup file
  ```
  make restore
  ```
  
