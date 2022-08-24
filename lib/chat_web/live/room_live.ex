defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    if connected?(socket), do: ChatWeb.Endpoint.subscribe(topic)

    {:ok, assign(socket, room_id: room_id, topic: topic, messages: ["Akash joined the chat"], temporary_assigns: [messages: []])}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: event, payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end
end
