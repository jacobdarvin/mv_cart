defmodule MvCartWeb.Router do
  use MvCartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MvCartWeb.Pipeline.AuthPipeline
  end

  scope "/api", MvCartWeb do
    pipe_through :api

    post "/register", UserController, :create
    post "/login", UserController, :login

    pipe_through :auth

    resources "/products", ProductController, only: [:index, :show]
    get "/purchases", PurchaseController, :index
    post "/purchases", PurchaseController, :create
    get "/balance", UserController, :balance
  end
end
