import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rg_demo, RGDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rg_demo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rg_demo, RGDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hBSR3bXro0IfiQ+o2p2ao8YQPp0geepb/1CAqA6Ow3/h/dg0y+jLHVrrJ3tlNyXy",
  server: false

# In test we don't send emails.
config :rg_demo, RGDemo.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
