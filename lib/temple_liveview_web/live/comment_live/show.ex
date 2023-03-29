defmodule TempleLiveviewWeb.CommentLive.Show do
  use TempleLiveviewWeb, :live_view

  alias TempleLiveview.Social

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment, Social.get_comment!(id))}
  end

  defp page_title(:show), do: "Show Comment"
  defp page_title(:edit), do: "Edit Comment"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Comment <%= @comment.id %>
      <:subtitle>This is a comment record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/comments/#{@comment}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit comment</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Votes count"><%= @comment.votes_count %></:item>
      <:item title="Body"><%= @comment.body %></:item>
    </.list>

    <.back navigate={~p"/comments"}>Back to comments</.back>

    <.modal
      :if={@live_action == :edit}
      id="comment-modal"
      show
      on_cancel={JS.patch(~p"/comments/#{@comment}")}
    >
      <.live_component
        module={TempleLiveviewWeb.CommentLive.FormComponent}
        id={@comment.id}
        title={@page_title}
        action={@live_action}
        comment={@comment}
        patch={~p"/comments/#{@comment}"}
      />
    </.modal>
    """
  end
end
