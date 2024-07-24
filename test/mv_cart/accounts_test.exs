defmodule MvCart.AccountsTest do
  use MvCart.DataCase

  alias MvCart.Accounts
  alias MvCart.Accounts.User
  alias MvCart.Accounts.Wallet

  import MvCart.AccountsFixtures

  describe "get_user!/1" do
    test "returns user" do
      user = user_fixture()
      assert %User{} = Accounts.get_user!(user.id)
    end

    test "returns error if no user found" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(Ecto.UUID.generate())
      end
    end
  end

  describe "authenticate_user/2" do
    test "returns user when credential is valid" do
      user = user_fixture(%{password: "abcdefg"})
      user_id = user.id

      assert {:ok, %User{id: ^user_id}} = Accounts.authenticate_user(user.email, "abcdefg")
    end

    test "returns error if password is invalid" do
      user = user_fixture(%{password: "abcdefg"})
      assert {:error, :invalid_credentials} = Accounts.authenticate_user(user.email, "hijklmno")
    end
  end

  describe "create_user_with_wallet/1" do
    test "returns user with wallet" do
      params = %{email: "jacob@gmail.com", password: "123456"}
      email = params.email

      assert {:ok, %User{email: ^email}} = Accounts.create_user_with_wallet(params)
    end
  end
end
