defmodule NestedInputsFor.Product.Product do
  use Ecto.Schema
  alias NestedInputsFor.Product.Language
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    has_many :languages, Language
    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name])
    |> cast_assoc(:languages)
  end
end
