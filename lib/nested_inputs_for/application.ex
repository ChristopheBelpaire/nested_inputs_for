defmodule NestedInputsFor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NestedInputsForWeb.Telemetry,
      # Start the Ecto repository
      NestedInputsFor.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NestedInputsFor.PubSub},
      # Start Finch
      {Finch, name: NestedInputsFor.Finch},
      # Start the Endpoint (http/https)
      NestedInputsForWeb.Endpoint
      # Start a worker by calling: NestedInputsFor.Worker.start_link(arg)
      # {NestedInputsFor.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NestedInputsFor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NestedInputsForWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
