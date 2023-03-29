defmodule TempleLiveview.Repo do
  use Ecto.Repo,
    otp_app: :temple_liveview,
    adapter: Ecto.Adapters.Postgres
end
