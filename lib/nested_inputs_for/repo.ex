defmodule NestedInputsFor.Repo do
  use Ecto.Repo,
    otp_app: :nested_inputs_for,
    adapter: Ecto.Adapters.Postgres
end
