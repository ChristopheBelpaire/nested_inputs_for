defmodule NestedInputsFor.Repo.Migrations.CreateLanguage do
  use Ecto.Migration

  def change do
    create table("languages") do
      add :name, :string
      add :product_id, references(:languages), null: false
      timestamps()
    end
  end
end
