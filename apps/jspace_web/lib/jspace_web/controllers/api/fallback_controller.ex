defmodule JspaceWeb.Api.FallbackController do
  use JspaceWeb, :controller

  alias JspaceWeb.Api.ErrorView

  def call(conn, {:error, :unknown_error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render("500.json")
  end

  def call(conn, {:error, :unauthenticated}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, reason}) do
    # 400
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", reason: reason)
  end
end
