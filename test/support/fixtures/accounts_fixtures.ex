defmodule MvCart.AccountsFixtures do
  alias MvCart.Repo

  def unique_user_email, do: "some_email_#{System.unique_integer([:positive])}@gmail.com"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: "password"
      })
      |> MvCart.Accounts.create_user_with_wallet()

    user
  end

  def wallet_fixture(_attrs \\ %{}) do
    user = user_fixture()
    Repo.get_by!(MvCart.Accounts.Wallet, user_id: user.id)
  end
end
