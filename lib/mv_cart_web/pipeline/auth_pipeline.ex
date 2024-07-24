defmodule MvCartWeb.Pipeline.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :mv_cart,
    module: MvCart.Guardian,
    error_handler: MvCartWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
