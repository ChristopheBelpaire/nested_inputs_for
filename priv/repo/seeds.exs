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
    %Language{
      name: "French",
      attributes: [
        %Attribute{label: "1", value: "Un"},
        %Attribute{label: "2", value: "Deux"},
        %Attribute{label: "3", value: "Trois"}
      ]
    }
  ]
})
