defmodule MvCart.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias MvCart.Repo

  alias MvCart.Sales.Purchase
  alias MvCart.Sales.WalletTransaction
  alias MvCart.Accounts.Wallet

  @doc """
  Returns the list of purchases.

  ## Examples

      iex> list_purchases()
      [%Purchase{}, ...]

  """
  def list_purchases do
    Repo.all(Purchase)
  end

  def list_user_purchases(user_id) do
    Repo.all(from p in Purchase, where: p.user_id == ^user_id)
  end

  @doc """
  Gets a single purchase.

  Raises `Ecto.NoResultsError` if the Purchase does not exist.

  ## Examples

      iex> get_purchase!(123)
      %Purchase{}

      iex> get_purchase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_purchase!(id), do: Repo.get!(Purchase, id)

  @doc """
  Creates a purchase.

  ## Examples

      iex> create_purchase(%{field: value})
      {:ok, %Purchase{}}

      iex> create_purchase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_purchase(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a purchase.

  ## Examples

      iex> update_purchase(purchase, %{field: new_value})
      {:ok, %Purchase{}}

      iex> update_purchase(purchase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_purchase(%Purchase{} = purchase, attrs) do
    purchase
    |> Purchase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a purchase.

  ## Examples

      iex> delete_purchase(purchase)
      {:ok, %Purchase{}}

      iex> delete_purchase(purchase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchase(%Purchase{} = purchase) do
    Repo.delete(purchase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking purchase changes.

  ## Examples

      iex> change_purchase(purchase)
      %Ecto.Changeset{data: %Purchase{}}

  """
  def change_purchase(%Purchase{} = purchase, attrs \\ %{}) do
    Purchase.changeset(purchase, attrs)
  end

  def top_up_wallet(user_id, amount) when amount > 0 do
    Repo.transaction(fn ->
      wallet = Repo.get_by!(Wallet, user_id: user_id)
      IO.inspect(wallet, label: "Wallet")

      transaction =
        %WalletTransaction{}
        |> WalletTransaction.changeset(%{wallet_id: wallet.id, amount: amount})
        |> Repo.insert()

      IO.inspect(transaction, label: "Transaction")

      transaction
    end)
  end

  def calculate_balance(user_id) do
    wallet = Repo.get_by(Wallet, user_id: user_id)

    case wallet do
      nil ->
        {:error, :not_found}

      _ ->
        balance =
          Repo.aggregate(
            from(t in WalletTransaction, where: t.wallet_id == ^wallet.id),
            :sum,
            :amount
          ) || Decimal.new("0.00")

        {:ok, balance}
    end
  end

  @doc """
  Returns the list of wallet_transactions.

  ## Examples

      iex> list_wallet_transactions()
      [%WalletTransaction{}, ...]

  """
  def list_wallet_transactions do
    Repo.all(WalletTransaction)
  end

  @doc """
  Gets a single wallet_transaction.

  Raises `Ecto.NoResultsError` if the Wallet transaction does not exist.

  ## Examples

      iex> get_wallet_transaction!(123)
      %WalletTransaction{}

      iex> get_wallet_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet_transaction!(id), do: Repo.get!(WalletTransaction, id)

  @doc """
  Creates a wallet_transaction.

  ## Examples

      iex> create_wallet_transaction(%{field: value})
      {:ok, %WalletTransaction{}}

      iex> create_wallet_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet_transaction(attrs \\ %{}) do
    %WalletTransaction{}
    |> WalletTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet_transaction.

  ## Examples

      iex> update_wallet_transaction(wallet_transaction, %{field: new_value})
      {:ok, %WalletTransaction{}}

      iex> update_wallet_transaction(wallet_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_transaction(%WalletTransaction{} = wallet_transaction, attrs) do
    wallet_transaction
    |> WalletTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wallet_transaction.

  ## Examples

      iex> delete_wallet_transaction(wallet_transaction)
      {:ok, %WalletTransaction{}}

      iex> delete_wallet_transaction(wallet_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet_transaction(%WalletTransaction{} = wallet_transaction) do
    Repo.delete(wallet_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet_transaction changes.

  ## Examples

      iex> change_wallet_transaction(wallet_transaction)
      %Ecto.Changeset{data: %WalletTransaction{}}

  """
  def change_wallet_transaction(%WalletTransaction{} = wallet_transaction, attrs \\ %{}) do
    WalletTransaction.changeset(wallet_transaction, attrs)
  end
end
