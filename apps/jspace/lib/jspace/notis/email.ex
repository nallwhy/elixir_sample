defmodule Jspace.Notis.Email do
  import Jspace.CommonHelper, only: [defasync: 2]

  def welcome(user) do
    "send welcome email to #{user.email}" |> IO.inspect()
  end

  defasync(:welcome, 1)
end
