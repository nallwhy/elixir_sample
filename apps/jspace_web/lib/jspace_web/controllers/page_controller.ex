defmodule JspaceWeb.PageController do
  use JspaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
