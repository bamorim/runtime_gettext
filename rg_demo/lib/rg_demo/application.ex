defmodule RGDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Load the runtime gettext overrides
    RuntimeGettextPO.load_po_files(Application.app_dir(:rg_demo, "priv/runtime_gettext"))

    children = [
      # Start the Ecto repository
      RGDemo.Repo,
      # Start the Telemetry supervisor
      RGDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RGDemo.PubSub},
      # Start the Endpoint (http/https)
      RGDemoWeb.Endpoint
      # Start a worker by calling: RGDemo.Worker.start_link(arg)
      # {RGDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RGDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RGDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
