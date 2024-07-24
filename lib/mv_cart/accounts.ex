defmodule MvCart.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MvCart.Repo

  alias MvCart.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    case user do
      nil ->
        {:error, :invalid_credentials}

      %User{} = user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def update_user_balance(%User{id: _id, balance: balance} = user, total_cost) do
    new_balance = Decimal.sub(balance, total_cost)

    user
    |> User.changeset(%{balance: new_balance})
    |> Repo.update()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
