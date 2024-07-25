defmodule MvCartWeb.UserControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.AccountsFixtures
  alias MvCart.Repo
  alias MvCart.Guardian
  alias MvCart.Accounts.User
  alias MvCart.Sales.WalletTransaction
  alias MvCart.Sales
  alias Decimal

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "creates and returns user with token", %{conn: conn} do
      user_params = %{email: unique_user_email(), password: "password"}

      conn = post(conn, ~p"/api/register", user: user_params)

      assert %{"user" => %{"id" => id, "email" => email}, "token" => token} =
               json_response(conn, 201)

      assert email == user_params.email
      assert Repo.get_by(User, id: id)
      assert token
    end
  end

  describe "login" do
    setup :setup_user

    test "returns user and token with valid credentials", %{conn: conn, user: user} do
      login_params = %{email: user.email, password: "password"}

      conn = post(conn, ~p"/api/login", user: login_params)

      assert %{"user" => %{"id" => id, "email" => email}, "token" => token} =
               json_response(conn, 200)

      assert id == user.id
      assert email == user.email
      assert token
    end

    test "returns error with invalid credentials", %{conn: conn} do
      login_params = %{email: "wrong_email@gmail.com", password: "wrong_password"}

      conn = post(conn, ~p"/api/login", user: login_params)
      assert json_response(conn, 401)["error"] == "Invalid credentials"
    end
  end

  describe "balance" do
    setup :setup_user

    test "returns user balance for authenticated user", %{conn: conn, token: token, user: user} do
      # Ensure the wallet association is loaded
      user = Repo.preload(user, :wallet)

      # Insert wallet transactions for testing balance calculation
      Repo.insert!(%WalletTransaction{
        wallet_id: user.wallet.id,
        amount: Decimal.new("100.0")
      })

      # Calculate balance using the Sales context
      {:ok, balance} = Sales.calculate_balance(user.id)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/api/wallets/balance")

      assert json_response(conn, 200)["balance"] == Decimal.to_string(balance)
    end

    test "returns error for unauthenticated user", %{conn: conn} do
      conn = get(conn, ~p"/api/wallets/balance")
      assert json_response(conn, 401)["error"] == "unauthenticated"
    end
  end

  defp setup_user(_context) do
    # Ensure the wallet association is loaded
    user = user_fixture() |> Repo.preload(:wallet)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    %{user: user, token: token}
  end
end
