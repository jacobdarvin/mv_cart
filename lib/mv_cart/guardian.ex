defmodule MvCart.Guardian do
  use Guardian, otp_app: :mv_cart

  alias MvCart.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    _ -> {:error, :resource_not_found}
  end
end
