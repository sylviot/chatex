defmodule Chat.Server do
	use GenServer
	
	def start_link do
		GenServer.start_link(__MODULE__, :ok, [name: :chat_server])
	end

	def init(:ok) do
		{:ok, []}
	end

	def handle_call({:join, room_name, username}, {_from, _reference}, rooms) do
		{room_name, room} = List.keyfind(rooms, room_name, 0, {room_name, HashSet.new})

		room = HashSet.put(room, {_from, username})
		rooms = List.keystore(rooms, room_name, 0, {room_name, room})

		{:reply, {:ok, rooms}, rooms}
	end

  def handle_call({:online, room_name}, {_form, _reference}, rooms) do
    {room, users} = List.keyfind(rooms, room_name, 0, {room_name, HashSet.new})

    users_online = HashSet.to_list(users)
                    |> Enum.map( fn ({pid, username}) -> username end)

    Enum.each(users, fn({pid, pid_user_name}) ->
      send pid, {:broadcast, [action: "online", content: users_online]}
    end)

    {:reply, {:ok, rooms}, rooms}
  end

	def handle_call({:talk, room_name, data}, {_from, _reference}, rooms) do
		{room, users} = List.keyfind(rooms, room_name, 0)

		Enum.each(users, fn({pid, pid_user_name}) ->
      send pid, {:broadcast, data}
		end)

		{:reply, :ok, rooms}
	end

	def handle_call({:leave, room_name, username}, {_from, _reference}, rooms) do
    {room, users} = List.keyfind(rooms, room_name, 0)

    users = HashSet.delete(users, {_from, username})
    rooms = List.keystore(rooms, room_name, 0, {room, users})

    {:reply, :ok, rooms}
	end
end
