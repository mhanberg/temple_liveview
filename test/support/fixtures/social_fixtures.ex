defmodule TempleLiveview.SocialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TempleLiveview.Social` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        votes_count: 42
      })
      |> TempleLiveview.Social.create_comment()

    comment
  end
end
