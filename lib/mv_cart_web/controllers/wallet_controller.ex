defmodule MvCartWeb.WalletController do
  use MvCartWeb, :controller

  alias MvCart.Accounts
  alias MvCart.Accounts.Wallet
  alias MvCart.Sales
  alias MvCart.Guardian

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

  def top_up(conn, %{"wallet" => %{"amount" => amount}}) do
    user = Guardian.Plug.current_resource(conn)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User not authenticated"})

      %{} ->
        amount = Decimal.new(amount)

        case Sales.top_up_wallet(user.id, amount) do
          {:ok, _transaction} ->
            conn
            |> put_status(:created)
            |> json(%{message: "Top-up successful"})

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
    end
  end

  def calculate_balance(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User not authenticated"})

      %{} ->
        case Sales.calculate_balance(user.id) do
          {:ok, balance} ->
            conn
            |> put_status(:ok)
            |> json(%{balance: balance})

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
    end
  end
end
