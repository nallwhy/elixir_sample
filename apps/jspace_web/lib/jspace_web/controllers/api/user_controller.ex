defmodule JspaceWeb.Api.UserController do
  use JspaceWeb, :controller

  alias Jspace.Accounts

  action_fallback(JspaceWeb.Api.FallbackController)

  def sign_up(conn, params) do
    parse_info = [
      {:email, :string, required: true},
      {:password, :string, required: true},
      {:name, :string}
    ]

    with {:ok, params} <- safe_parse_params(params, parse_info),
         {:ok, user} <- Accounts.sign_up(params) do
      conn
      |> render("user.json", user: user)
    end
  end
end
