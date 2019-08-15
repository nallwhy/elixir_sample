defmodule JspaceWeb.Api.UserControllerTest do
  use JspaceWeb.ConnCase, async: true

  @attrs %{
    "email" => "json@healingpaper.com",
    "password" => "password1!",
    "name" => "제이슨"
  }

  describe "POST /sign_up" do
    test "with valid params", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :sign_up), @attrs)

      email = @attrs["email"]
      assert %{"email" => ^email} = json_response(conn, 200)["data"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :sign_up), %{@attrs | "password" => nil})

      assert json_response(conn, 400)["error_code"] == "api_required_params_not_provided"
    end
  end
end
