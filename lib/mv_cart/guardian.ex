defmodule MvCart.Guardian do
  use Guardian, otp_app: :mv_cart

  alias MvCart.Accounts
  alias MvCart.Repo

  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    user =
      Accounts.get_user!(id)
      |> Repo.preload(:wallet)

    {:ok, user}
  end
end
