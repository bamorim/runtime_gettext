defmodule RGDemo.Repo do
  use Ecto.Repo,
    otp_app: :rg_demo,
    adapter: Ecto.Adapters.Postgres
end
