use Mix.Config

config :ImageUnmirrorer, ImageUnmirrorer.Router,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server: true
