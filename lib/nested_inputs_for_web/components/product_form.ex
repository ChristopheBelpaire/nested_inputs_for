defmodule NestedInputsForWeb.ProductForm do
  use Phoenix.LiveView
  alias NestedInputsFor.Product.{Attribute, Language, Product}
  import NestedInputsForWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <h1>Product form</h1>
    <.form for={@form} as={:product} phx-submit={:save} phx-change={:validate}>
      <label>Product name</label>
      <.input field={@form[:name]} type="text" />
      <div class="flex">
        <.inputs_for :let={language_form} field={@form[:languages]}>
          <.input field={language_form[:name]} type="hidden" />
          <div class="flex-initial">
            <%= Ecto.Changeset.get_field(language_form.source, :name) %>
            <br/>
            <.inputs_for :let={attribute_form} field={language_form[:attributes]}>
              <label>Label</label>
              <.input field={attribute_form[:label]} type="text" />
              <label>Value</label>
              <.input field={attribute_form[:value]} type="text" />
            </.inputs_for>
          </div>
        </.inputs_for>
      </div>
      <div phx-click="add_attribute">Add attribute</div>
      <button>Save</button>
    </.form>
    """
  end

  def mount(_params, _, socket) do
    changeset =
      Product.changeset(
        %Product{
          languages: [
            %Language{name: "FR", attributes: []},
            %Language{name: "EN", attributes: []}
          ]
        },
        %{}
      )

    {:ok, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("add_attribute", _params, socket) do
    changeset = socket.assigns.changeset
    udpated_languages =
      Ecto.Changeset.get_field(changeset, :languages)
      |> Enum.map(fn language ->
        Map.put(language, :attributes,  language.attributes ++ [%Attribute{}])
      end)

    changeset = Ecto.Changeset.put_assoc(changeset, :languages, udpated_languages)
    IO.inspect(changeset)
    {:noreply, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("validate", %{"product" => params}, socket) do
    changeset = Product.changeset(socket.assigns.changeset, params)
    {:noreply, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("save", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
