# Wildfire

To install Erlang and Elixir using asdf:
  * Download and install `asdf` itself from [`here`](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
  * Run `asdf install` on the command line from the project directory to install the versions specified in the project's tool versions file

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The data baing sent across the websocket is currently only displayed in the javascript console, which can be seen in the browser's developer tools.