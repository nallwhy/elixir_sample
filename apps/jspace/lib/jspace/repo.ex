defmodule Jspace.Repo do
  use Ecto.Repo,
    otp_app: :jspace,
    adapter: Ecto.Adapters.Postgres
end
