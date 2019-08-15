# Since configuration is shared in umbrella projects, this file
# should only configure the :jspace_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :jspace_web,
  ecto_repos: [Jspace.Repo],
  generators: [context_app: :jspace]

# Configures the endpoint
config :jspace_web, JspaceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KV7sTvrKoj6EKtEfKIDInGZFwJwanJ1GvtvCYVzbpTP0dXLADZL8XLNSjPfsAed9",
  render_errors: [view: JspaceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JspaceWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
