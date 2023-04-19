# Linkwaiter

`Linkwaiter` is a lightweight server designed to manage a compilation of useful external links (blog posts, articles, almost any educative link).
It has a very specific use case of automatically updating a single json file and the corresponding section of my personal blog (TBA).

While this project was written out of necessity, I've taken advantage of it to write and learn Elixir, just for fun.

The http server is implemented in [Plug](https://github.com/elixir-plug/plug), a minimalistic web server library for elixir.

## Dev Instructions
Certain values must be filled in `config/dev.secret.exs` before running this application in dev mode.
Here's a sample file.
```elixir
import Config

config :linkwaiter,
    session_key: "<Session Key>",
    session_salt: "<Session Salt>",
    admin_username: "<Admin Username>",
    admin_password: "<Admin Password>",
    links_json_path: "<Path to links json file>",
    blog_root: "<Path to blog root in local filesystem>",
    basepath: "linkwaiter"
```

Then, install dependencies:
```bash
$ mix deps.get
```

Run the application:
```bash
$ mix run --no-halt
```

Run the application in `iex`:
```bash
$ iex -S mix
```

## Deploying
To build the application for deployment, run:
```bash
$ MIX_ENV=prod mix release
```
Then follow the instructions from the above command to get the server up and running.

On distros with systemd, simply set up a systemd service by copying `service/linkwaiter.service` over to `/etc/systemd/system`. Note that you must fill out the username and the path to the executable first.

Start the service with:
```bash
$ systemctl start linkwaiter
```
