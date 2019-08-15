defmodule Jspace.Factory do
  use ExMachina.Ecto, repo: Jspace.Repo

  alias Jspace.Accounts.User
  alias Jspace.Crypto

  def user_factory(attrs) do
    {password, attrs} = attrs |> Map.pop(:password, "password1!")

    %User{
      email: "test-#{sequence(:user_email, & &1)}@healingpaper.com",
      password_hash: Crypto.hash_password(password),
      name: "test-#{sequence(:user_name, & &1)}"
    }
    |> merge_attributes(attrs)
  end
end
