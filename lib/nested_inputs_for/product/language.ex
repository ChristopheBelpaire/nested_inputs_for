defmodule NestedInputsFor.Product.Language do
  use Ecto.Schema
  alias NestedInputsFor.Product.{Attribute, Product}
  import Ecto.Changeset

  schema "languages" do
    field :name, :string
    belongs_to :product, Product
    has_many :attributes, Attribute, on_replace: :delete
    timestamps()
  end

  def changeset(language, attrs) do
    language
    |> cast(attrs, [:name])
    |> cast_assoc(:attributes)
  end
end
