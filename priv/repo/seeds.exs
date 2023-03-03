# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NestedInputsFor.Repo.insert!(%NestedInputsFor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias NestedInputsFor.Repo

alias NestedInputsFor.Product.{Product, Language, Attribute}

Repo.insert!(%Product{
  name: "a product",
  languages: [
      %Language{name: "French",
      attributes: [
        %Attribute{label: "Couleur",
        value: "Noir"}
      ]
    },
    %Language{name: "English",
    attributes: [
      %Attribute{label: "Color",
      value: "Black"}
    ]
  }]
})
