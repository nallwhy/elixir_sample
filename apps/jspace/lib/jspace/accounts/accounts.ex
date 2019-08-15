defmodule Jspace.Accounts do
  alias Jspace.Accounts.User
  alias Jspace.Notis.Email

  def sign_up(attrs) do
    with {:ok, user} <- User.create(attrs) do
      Email.welcome_async(user)
      {:ok, user}
    else
      _ -> {:error, :unknown_error}
    end
  end
end
