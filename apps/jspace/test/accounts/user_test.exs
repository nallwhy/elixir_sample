defmodule Jspace.Accounts.UserTest do
  use Jspace.DataCase, async: true
  alias Jspace.Crypto

  describe "create/1" do
    @attrs %{
      email: "json@healingpaper.com",
      password: "strong password",
      name: "제이슨"
    }

    test "with valid attrs" do
      assert {:ok, new_user} = User.create(@attrs)
      assert same_fields?(new_user, @attrs, [:email, :name])
      assert Crypto.check_password(@attrs.password, new_user.password_hash)
    end

    test "without required attrs" do
      assert_changeset_error(:email, "can't be blank", fn ->
        User.create(%{@attrs | email: nil})
      end)

      assert_changeset_error(:password, "can't be blank", fn ->
        User.create(%{@attrs | password: nil})
      end)
    end
  end

  describe "list_by/1" do
    setup do
      user = insert(:user)
      _other_user = insert(:user)

      %{user: user}
    end

    test "with valid params", %{user: user} do
      assert [new_user] = User.list_by(%{name: user.name})
      assert same_record?(new_user, user)
    end
  end
end
