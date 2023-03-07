defmodule NestedInputsForWeb.LanguageForm do
  use Phoenix.LiveView
  alias NestedInputsFor.Product.{Attribute, Language, Product}
  alias NestedInputsFor.Repo
  import NestedInputsForWeb.CoreComponents

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Product form</h1>
    <.form for={@form} as={:product} phx-submit={:save} phx-change={:validate}>
      <label>Product name</label>
      <.input field={@form[:name]} type="text" />
      <div class="flex">
        <.inputs_for :let={language_form} field={@form[:languages]}>
          <.input field={language_form[:name]} />
          <button
            type="button"
            class="btn-blue"
            phx-click="delete_language"
            phx-value-index={language_form.index}
          >
            X
          </button>
          <br />
        </.inputs_for>
      </div>
      <button type="button" class="btn-blue" phx-click="add_language">Add language</button>

      <br />
      <button class="btn-blue">Save</button>
    </.form>
    """
  end

  def mount(_params, _, socket) do
    changeset = init_product()
    {:ok, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("add_language", _params, socket) do
    changeset = socket.assigns.changeset
    languages = Ecto.Changeset.get_field(changeset, :languages)

    updated_changeset =
      Ecto.Changeset.put_assoc(changeset, :languages, languages ++ [%Language{}])

    {:noreply, assign(socket, %{form: to_form(updated_changeset), changeset: updated_changeset})}
  end

  def handle_event("delete_language", %{"index" => index}, socket) do
    changeset = socket.assigns.changeset
    index = String.to_integer(index)

    languages = Ecto.Changeset.get_field(changeset, :languages)

    updated_changeset =
      Ecto.Changeset.put_assoc(changeset, :languages, List.delete_at(languages, index))

    {:noreply, assign(socket, %{form: to_form(updated_changeset), changeset: updated_changeset})}
  end

  def handle_event("validate", %{"product" => params}, socket) do
    IO.inspect(params)
    changeset = Product.changeset(init_product(), params)
    {:noreply, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("save", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def init_product() do
    Product.changeset(%Product{}, %{languages: []})
  end

  def preload(language) do
    if Ecto.assoc_loaded?(language.attributes), do: language.attributes, else: []
  end
end
