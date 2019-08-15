# Since configuration is shared in umbrella projects, this file
# should only configure the :jspace application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :jspace,
  ecto_repos: [Jspace.Repo]

import_config "#{Mix.env()}.exs"
