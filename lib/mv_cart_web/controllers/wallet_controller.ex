defmodule MvCartWeb.WalletController do
  use MvCartWeb, :controller

  alias MvCart.Sales
  alias MvCart.Guardian

  action_fallback MvCartWeb.FallbackController

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
