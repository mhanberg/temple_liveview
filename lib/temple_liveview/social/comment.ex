defmodule TempleLiveview.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :votes_count, :integer

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:votes_count, :body])
    |> validate_required([:votes_count, :body])
  end
end
