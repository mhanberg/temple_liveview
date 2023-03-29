defmodule TempleLiveview.SocialTest do
  use TempleLiveview.DataCase

  alias TempleLiveview.Social

  describe "comments" do
    alias TempleLiveview.Social.Comment

    import TempleLiveview.SocialFixtures

    @invalid_attrs %{body: nil, votes_count: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Social.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Social.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body", votes_count: 42}

      assert {:ok, %Comment{} = comment} = Social.create_comment(valid_attrs)
      assert comment.body == "some body"
      assert comment.votes_count == 42
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body", votes_count: 43}

      assert {:ok, %Comment{} = comment} = Social.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
      assert comment.votes_count == 43
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_comment(comment, @invalid_attrs)
      assert comment == Social.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Social.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Social.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Social.change_comment(comment)
    end
  end
end
