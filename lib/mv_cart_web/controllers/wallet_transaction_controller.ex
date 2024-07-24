defmodule MvCartWeb.WalletTransactionController do
  use MvCartWeb, :controller

  alias MvCart.Sales
  alias MvCart.Sales.WalletTransaction

  action_fallback MvCartWeb.FallbackController

  def index(conn, _params) do
    wallet_transactions = Sales.list_wallet_transactions()
    render(conn, :index, wallet_transactions: wallet_transactions)
  end

  def create(conn, %{"wallet_transaction" => wallet_transaction_params}) do
    with {:ok, %WalletTransaction{} = wallet_transaction} <- Sales.create_wallet_transaction(wallet_transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/wallet_transactions/#{wallet_transaction}")
      |> render(:show, wallet_transaction: wallet_transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet_transaction = Sales.get_wallet_transaction!(id)
    render(conn, :show, wallet_transaction: wallet_transaction)
  end

  def update(conn, %{"id" => id, "wallet_transaction" => wallet_transaction_params}) do
    wallet_transaction = Sales.get_wallet_transaction!(id)

    with {:ok, %WalletTransaction{} = wallet_transaction} <- Sales.update_wallet_transaction(wallet_transaction, wallet_transaction_params) do
      render(conn, :show, wallet_transaction: wallet_transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet_transaction = Sales.get_wallet_transaction!(id)

    with {:ok, %WalletTransaction{}} <- Sales.delete_wallet_transaction(wallet_transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
