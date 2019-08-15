alias Jspace.Accounts.User
alias Jspace.Repo
alias Jspace.Crypto

password_hash = "password1!" |> Crypto.hash_password()

1..10
|> Enum.each(fn i ->
  %User{
    email: "test-#{i}@rinobr.com",
    password_hash: password_hash,
    name: "name-#{i}"
  }
  |> Repo.insert!()
end)
