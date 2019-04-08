# Wonderful Song

This app aims to help musical ensemble leaders to manage their groups.

## Local development environment setup

* Ruby version

After you checkout this project from github, you may need to set the ruby version, which should be 2.6.2. You can do this by running the following command:

```bash
rvm install 2.6.2
rvm use 2.6.2
bundle
```

* Database

In order to run this project locally, you will also need a PostgreSQL database running. The default user and password used in database is your SO user login with a blank password. You may change theses settings in config/database.yml file. If you don't have a PostgreSQL running yet, you may try to run it with Docker with the following command.
```bash
docker run \
  --name wonderful-song-db \
  -e POSTGRES_USER=`echo $USER` \
  -p 5432:5432 \
  -v /var/run/postgresql:/var/run/postgresql \
  -d postgres
```

* Database initialization

After you have a running database you should initialize it with the following commands:

```bash
rails db:create
rails db:migrate
```