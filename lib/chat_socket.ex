defmodule Chat.Socket do
	@behaviour :cowboy_websocket
	@timeout 60000

	def init(_, request, options) do
		{:upgrade, :protocol, :cowboy_websocket}
	end

	def websocket_init(_type, request, _options) do
		{:ok, request, [], @timeout}
	end

	def websocket_terminate(_reason, _request, _state) do
		{:username, username} = List.keyfind(_state, :username, 0)
		{:room, room_name} = List.keyfind(_state, :room, 0)

    result = [action: "leave", username: username, content: "saiu da sala"]

    :gen_server.call(:chat_server, {:leave, room_name, username})
    :gen_server.call(:chat_server, {:online, room_name})
		:gen_server.call(:chat_server, {:talk, room_name, result})

		:ok
	end

	def websocket_handle({:text, message}, request, state) do
		case JSON.decode(message) do
			{:ok, result} -> handle(result["action"], result["data"], request, state)
			_ -> {:ok, request, state}
		end
	end

	def websocket_info({:broadcast, data}, request, state) do
		case JSON.encode(data) do
		   {:ok, reply} -> {:reply, {:text, reply}, request, state}
		end
	end


	defp handle("join", data, request, state) do
		state = List.keystore(state, :username, 0, {:username, data["username"]})
		state = List.keystore(state, :room, 0, {:room, data["room"]})

		result = [action: "join", username: data["username"], content: "entrou na sala"] 

		:gen_server.call(:chat_server, {:join, data["room"], data["username"]})
		:gen_server.call(:chat_server, {:talk, data["room"], result})
		:gen_server.call(:chat_server, {:online, data["room"]})

		{:ok, request, state}
	end

	defp handle("talk", data, request, state) do
		{:room, room_name} = List.keyfind(state, :room, 0)
		{:username, username} = List.keyfind(state, :username, 0)

  	result = [action: "message", username: username, content: data["message"]]
		:gen_server.call(:chat_server, {:talk, room_name, result})

		{:ok, request, state}
	end

	defp handle(_, data, request, state),  do: {:ok, request, state}
end
