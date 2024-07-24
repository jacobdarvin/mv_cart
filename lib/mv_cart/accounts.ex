defmodule MvCart.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MvCart.Repo

  alias MvCart.Accounts.User
  alias MvCart.Accounts.Wallet

  def get_user!(id), do: Repo.get!(User, id)

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

  def create_user_with_wallet(attrs \\ %{}) do
    Repo.transaction(fn ->
      user = create_user!(attrs)
      create_wallet!(user.id)
      user
    end)
  end

  defp create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  defp create_wallet!(user_id) do
    %Wallet{}
    |> Wallet.changeset(%{user_id: user_id})
    |> Repo.insert!()
  end
end
