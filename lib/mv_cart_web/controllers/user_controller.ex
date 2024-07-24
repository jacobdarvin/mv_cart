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

  def login(_conn, _params) do
  end
end
