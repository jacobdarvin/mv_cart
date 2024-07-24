defmodule MvCart.Repo.Migrations.RemoveBalanceFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :balance
    end
  end
end
