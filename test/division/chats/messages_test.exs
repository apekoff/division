defmodule Division.MessagesTest do
  use Division.DataCase

  alias Division.Chats
  alias Division.Accounts
  alias Division.Network.Node

  describe "messages" do
    alias Division.Chats.Message
    setup [:create_user, :create_chat]

    def message_fixture(user, chat) do
      {:ok, message} = valid_attrs(user, chat) |> Chats.create_message()

      message
    end

    def fixture(:user) do
      {:ok, user} =
        %Node{}
        |> Node.changeset(%{"name" => "goomba", "type" => "person"})
        |> Repo.insert()
      user
    end

    def fixture(:chat) do
      {:ok, chat} = Chats.create_chat(%{"name" => "Leprosorium"})
      chat
    end

    defp valid_attrs(user, chat) do
      %{content: "some content", producer_id: user.id, consumer_id: chat.id}
    end

    defp create_user(_) do
      user = fixture(:user)
      {:ok, user: user}
    end

    defp create_chat(_) do
      chat = fixture(:chat)
      {:ok, chat: chat}
    end

    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    test "create_message/1 with valid data creates a message", %{user: user, chat: chat} do
      assert {:ok, %Message{} = message} = Chats.create_message(valid_attrs(user, chat))
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message", %{user: user, chat: chat} do
      message = message_fixture(user, chat)
      assert {:ok, %Message{} = message} = Chats.update_message(message, @update_attrs)
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset", %{user: user, chat: chat} do
      message = message_fixture(user, chat)
      assert {:error, %Ecto.Changeset{}} = Chats.update_message(message, @invalid_attrs)
    end

    test "change_message/1 returns a message changeset", %{user: user, chat: chat} do
      message = message_fixture(user, chat)
      assert %Ecto.Changeset{} = Chats.change_message(message)
    end
  end
end
