defmodule NestedInputsForWeb.ProductForm do
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
          <.input field={language_form[:name]} type="hidden" />
          <div class="flex-initial">
            <%= Ecto.Changeset.get_field(language_form.source, :name) %>
            <br/>
            <.inputs_for :let={attribute_form} field={language_form[:attributes]}>
              <div>
                <label  class="inline-block">Label</label>
                <.input field={attribute_form[:label]} type="text" class="inline-block"/>
                <label  class="inline-block">Value</label>
                <.input field={attribute_form[:value]} type="text"  class="inline-block"/>
                <button type="button" class="btn-blue" phx-click="delete_attribute" phx-value-index={attribute_form.index} phx-value-language={Ecto.Changeset.get_field(language_form.source, :name)}>X</button>
              </div>
            </.inputs_for>
            <br/>
            <button type="button" class="btn-blue" phx-click="add_attribute" phx-value-language={Ecto.Changeset.get_field(language_form.source, :name)}>Add attribute</button>

          </div>
        </.inputs_for>
      </div>
      <br/>
      <button class="btn-blue">Save</button>
    </.form>
    """
  end

  def mount(_params, _, socket) do
    changeset =
    # Repo.all(Product)
    # |> Repo.preload(languages: :attributes)
    # |> hd()
    # |> Product.changeset(%{})

      Product.changeset(
        %Product{
          languages: [
            %Language{name: "FR", attributes: [
              %Attribute{label: "Label FR 1", value: "Value FR 1"},
              %Attribute{label: "Label FR 2", value: "Value FR 2"}
            ]},
            %Language{name: "EN", attributes: [
              %Attribute{label: "Label EN 1", value: "Value EN 1"},
              %Attribute{label: "Label EN 2", value: "Value EN 2"}
            ]}
          ]
        },
        %{}
      )

    {:ok, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end

  def handle_event("add_attribute", %{"language" => clicked_language}, socket) do
    changeset = socket.assigns.changeset
    udpated_languages =
      Ecto.Changeset.get_field(changeset, :languages)
      |> Enum.map(fn language ->
        if(language.name == clicked_language) do
          Ecto.Changeset.change(language)
          |> Ecto.Changeset.put_assoc(:attributes, language.attributes ++ [%Attribute{}])
        else
          Ecto.Changeset.change(language)
        end
      end)
    changeset = Ecto.Changeset.put_assoc(changeset, :languages, udpated_languages)
    {:noreply, assign(socket, %{form: to_form(changeset), changeset: changeset})}
  end


  def handle_event("delete_attribute", %{"index" => index, "language" => clicked_language}, socket) do
    changeset = socket.assigns.changeset
    index = String.to_integer(index)
    udpated_languages =
      Ecto.Changeset.get_field(changeset, :languages)
      |> Enum.map(fn language ->
        if(language.name == clicked_language) do
          Ecto.Changeset.change(language)
          |> Ecto.Changeset.put_assoc(:attributes, List.delete_at(language.attributes, index))
        else
          Ecto.Changeset.change(language)
        end
      end)
    changeset = Ecto.Changeset.put_assoc(changeset, :languages, udpated_languages)
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
