defmodule MvCartWeb.UserController do
  use MvCartWeb, :controller

  alias MvCart.Accounts
  alias MvCart.Accounts.User

  action_fallback MvCartWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})

      %User{password_hash: password_hash} = user ->
        if Bcrypt.verify_pass(password, password_hash) do
          conn
          |> put_status(:ok)
          |> render(:show, user: user)
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid email or password"})
        end
    end
  end
end
