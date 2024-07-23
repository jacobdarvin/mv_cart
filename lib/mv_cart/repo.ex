defmodule MvCart.Repo do
  use Ecto.Repo,
    otp_app: :mv_cart,
    adapter: Ecto.Adapters.Postgres
end
