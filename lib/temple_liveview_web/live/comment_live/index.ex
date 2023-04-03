defmodule TempleLiveviewWeb.CommentLive.Index do
  use TempleLiveviewWeb, :live_view

  alias TempleLiveview.Social
  alias TempleLiveview.Social.Comment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :comments, Social.list_comments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comment")
    |> assign(:comment, Social.get_comment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Comments")
    |> assign(:comment, nil)
  end

  @impl true
  def handle_info({TempleLiveviewWeb.CommentLive.FormComponent, {:saved, comment}}, socket) do
    {:noreply, stream_insert(socket, :comments, comment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = Social.get_comment!(id)
    {:ok, _} = Social.delete_comment(comment)

    {:noreply, stream_delete(socket, :comments, comment)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <.title>
        Listing Comments
      </.title>
      <:actions>
        <.link patch={~p"/comments/new"}>
          <.button>New Comment</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="comments"
      rows={@streams.comments}
      row_click={fn {_id, comment} -> JS.navigate(~p"/comments/#{comment}") end}
    >
      <:col :let={{_id, comment}} label="Votes count"><%= comment.votes_count %></:col>
      <:col :let={{_id, comment}} label="Body"><%= comment.body %></:col>
      <:action :let={{_id, comment}}>
        <div class="sr-only">
          <.link navigate={~p"/comments/#{comment}"}>Show</.link>
        </div>
        <.link patch={~p"/comments/#{comment}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, comment}}>
        <.link
          phx-click={JS.push("delete", value: %{id: comment.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="comment-modal"
      show
      on_cancel={JS.patch(~p"/comments")}
    >
      <.live_component
        module={TempleLiveviewWeb.CommentLive.FormComponent}
        id={@comment.id || :new}
        title={@page_title}
        action={@live_action}
        comment={@comment}
        patch={~p"/comments"}
      />
    </.modal>
    """
  end

  def title(assigns) do
    temple do
      div class: "border-2 border-emerald-500 rounded m-2 p-2" do
        div do: "🤫 i'm inside the temple"
        slot @inner_block
      end
    end
  end
end
