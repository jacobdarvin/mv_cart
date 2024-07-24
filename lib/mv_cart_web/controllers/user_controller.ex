defmodule MvCartWeb.UserController do
  use MvCartWeb, :controller

  alias MvCart.Accounts
  alias MvCart.Accounts.User
  alias MvCart.Guardian

  action_fallback MvCartWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> json(%{user: %{id: user.id, email: user.email}, token: token})
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{user: %{id: user.id, email: user.email}, token: token})

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def balance(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "User not authenticated"})

      %{} ->
        conn
        |> put_status(:ok)
        |> json(%{balance: user.balance})
    end
  end
end
