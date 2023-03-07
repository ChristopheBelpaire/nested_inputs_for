Mix.install([{:ecto, git: "https://github.com/elixir-ecto/ecto.git", branch: "master"}])

defmodule Product do
  use Ecto.Schema
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

defmodule Language do
  use Ecto.Schema
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

defmodule Attribute do
  use Ecto.Schema
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

defmodule Main do
  def error() do
    changeset =
      Product.changeset(%Product{}, %{
        "languages" => %{
          "0" => %{
            "attributes" => %{
              "0" => %{"label" => "", "value" => ""},
              "1" => %{"label" => "", "value" => "k"}
            },
            "name" => "FR"
          },
          "1" => %{"name" => "EN"}
        },
        "name" => ""
      })

    index = 1
    selected_language = "FR"

    udpated_languages =
      Ecto.Changeset.get_change(changeset, :languages)
      |> Enum.map(fn language ->
        if(Ecto.Changeset.get_field(language, :name) == selected_language) do
          attributes = Ecto.Changeset.get_field(language, :attributes)

          language
          |> Ecto.Changeset.put_assoc(
            :attributes,
            List.delete_at(attributes, index)
          )
        else
          Ecto.Changeset.change(language)
        end
      end)

    updated_changeset = Ecto.Changeset.put_assoc(changeset, :languages, udpated_languages)

    Ecto.Changeset.get_field(updated_changeset, :languages)
    |> IO.inspect()
  end

  def ok() do
    changeset =
      Product.changeset(%Product{}, %{
        "languages" => %{
          "0" => %{"name" => "FR"},
          "1" => %{"name" => "EN"}
        },
        "name" => ""
      })

    index = 1
    languages = Ecto.Changeset.get_field(changeset, :languages)

    updated_changeset =
      Ecto.Changeset.put_assoc(changeset, :languages, List.delete_at(languages, index))

    Ecto.Changeset.get_field(updated_changeset, :languages)
    |> IO.inspect()
  end
end

IO.puts("Delete in normal input for, working : ")
Main.ok()
IO.puts("Delete in nested input for, not working and warning: ")
Main.error()
