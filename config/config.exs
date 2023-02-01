import Config

import_config "#{config_env()}.exs"
config :linkwaiter, env: config_env()
