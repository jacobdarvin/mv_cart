defmodule MvCartWeb.WalletJSON do
  alias MvCart.Accounts.Wallet

  @doc """
  Renders a list of wallets.
  """
  def index(%{wallets: wallets}) do
    %{data: for(wallet <- wallets, do: data(wallet))}
  end

  @doc """
  Renders a single wallet.
  """
  def show(%{wallet: wallet}) do
    %{data: data(wallet)}
  end

  defp data(%Wallet{} = wallet) do
    %{
      id: wallet.id,
      user_id: wallet.user_id
    }
  end
end
