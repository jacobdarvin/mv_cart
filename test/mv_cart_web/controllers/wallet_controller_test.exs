defmodule MvCartWeb.WalletControllerTest do
  use MvCartWeb.ConnCase

  import MvCart.AccountsFixtures
  alias MvCart.Repo
  alias MvCart.Guardian
  alias MvCart.Sales.WalletTransaction
  alias MvCart.Sales
  alias Decimal

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "top up" do
    setup :setup_user

    test "returns error for unauthenticated user", %{conn: conn} do
      conn = post(conn, ~p"/api/wallets/top_up", wallet: %{"amount" => "100.0"})
      # Adjusted to match the actual error message
      assert json_response(conn, 401)["error"] == "unauthenticated"
    end

    test "top up wallet for authenticated user", %{conn: conn, token: token, user: user} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post(~p"/api/wallets/top_up", wallet: %{"amount" => "100.0"})

      assert json_response(conn, 201)["message"] == "Top-up successful"

      # Verify that the wallet transaction has been created
      wallet_transaction =
        Repo.get_by(WalletTransaction, wallet_id: user.wallet.id, amount: Decimal.new("100.0"))

      assert wallet_transaction
    end
  end

  describe "calculate balance" do
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
      # Adjusted to match the actual error message
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
