defmodule NestedInputsFor.Repo.Migrations.CreateAttributes do
  use Ecto.Migration

  def change do
    create table("attributes") do
      add :label, :string
      add :value, :string
      add :language_id, references(:languages), null: false
      timestamps()
    end
  end
end
