defmodule JspaceWeb.Api.UserViewTest do
  use JspaceWeb.ViewCase, async: true

  setup do
    user = insert(:user)

    %{user: user}
  end

  test "render user.json", %{user: user} do
    assert %{data: _} = UserView.render("user.json", %{user: user})
  end

  test "render user", %{user: user} do
    assert UserView.render("user", %{user: user}) == %{
             email: user.email,
             name: user.name
           }
  end
end
