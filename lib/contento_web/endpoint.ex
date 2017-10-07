defmodule ContentoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :contento

  socket "/socket", ContentoWeb.UserSocket

  # Load settings into connection
  # This is plugged here to be available when rendering ContentoWeb.ErrorView
  plug ContentoWeb.Plug.Settings

  # Serves static files on "/"
  # Back-office assets are available on "/..."
  # Theme-specific assets are served on "/themes/[THEME_NAME]/..."
  plug Plug.Static,
    at: "/", from: :contento, gzip: false,
    only: ~w(css fonts js images favicon.ico robots.txt themes)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_contento_key",
    signing_salt: "5ppzjE+z"

  plug ContentoWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
