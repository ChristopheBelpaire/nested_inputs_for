defmodule NestedInputsFor.Product.Attribute do
  use Ecto.Schema
  alias NestedInputsFor.Product.Language
  import Ecto.Changeset

  schema "attributes" do
    field :label, :string
    field :value, :string
    belongs_to :language, Language
    timestamps()
  end

  def changeset(attribute, attrs) do
    attribute
    |> cast(attrs, [:label, :value])
  end
end
