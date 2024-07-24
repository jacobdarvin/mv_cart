defmodule MvCartWeb.WalletController do
  use MvCartWeb, :controller

  alias MvCart.Accounts
  alias MvCart.Accounts.Wallet

  action_fallback MvCartWeb.FallbackController

  def index(conn, _params) do
    wallets = Accounts.list_wallets()
    render(conn, :index, wallets: wallets)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    with {:ok, %Wallet{} = wallet} <- Accounts.create_wallet(wallet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/wallets/#{wallet}")
      |> render(:show, wallet: wallet)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Accounts.get_wallet!(id)
    render(conn, :show, wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Accounts.get_wallet!(id)

    with {:ok, %Wallet{} = wallet} <- Accounts.update_wallet(wallet, wallet_params) do
      render(conn, :show, wallet: wallet)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Accounts.get_wallet!(id)

    with {:ok, %Wallet{}} <- Accounts.delete_wallet(wallet) do
      send_resp(conn, :no_content, "")
    end
  end
end
