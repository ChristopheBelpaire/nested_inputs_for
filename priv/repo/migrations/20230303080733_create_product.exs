defmodule NestedInputsFor.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table("products") do
      add :name,    :string, size: 40
      timestamps()
    end
  end
end
