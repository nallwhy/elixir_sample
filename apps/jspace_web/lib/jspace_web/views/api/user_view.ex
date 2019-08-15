defmodule JspaceWeb.Api.UserView do
  use JspaceWeb, :view

  def render("user.json", %{user: user}) do
    %{
      data: render_one(user, __MODULE__, "user")
    }
  end

  def render("user", %{user: user}) do
    user
    |> Map.take([
      :email,
      :name
    ])
  end
end
