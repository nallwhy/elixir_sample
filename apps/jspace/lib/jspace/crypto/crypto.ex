defmodule Jspace.Crypto do
  defdelegate add_password_hash(password), to: Argon2, as: :add_hash
  defdelegate check_password(password, hash), to: Argon2, as: :check_pass
  defdelegate hash_password(password), to: Argon2, as: :hash_pwd_salt
end
