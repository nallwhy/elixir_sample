# Since configuration is shared in umbrella projects, this file
# should only configure the :jspace application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :jspace, Jspace.Repo,
  username: "postgres",
  password: "postgres",
  database: "jspace_dev",
  hostname: "localhost",
  pool_size: 10
