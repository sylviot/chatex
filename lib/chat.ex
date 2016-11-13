defmodule Chat.Page do
	@path "web"

	def init(_, request, []) do
		{:ok, request, nil}
	end

	def handle(request, state) do
		{path, _request} = :cowboy_req.path(request)

		{:ok, content} = File.read(@path <> path)
		{:ok, request} = :cowboy_req.reply(200, [{"Content-Type", "text/html"}], content, request)

		{:ok, request, state}
	end

	def terminate(_reason, _request, _state) do
		:ok
	end
end


defmodule Chat do
	@behaviour :application

	def start(_type, _args) do
		args = :cowboy_router.compile(dispatch)

		:cowboy.start_http(
			:my_http_listener, 
			100, 
			[{:port, port}], 
			[{:env, [{:dispatch, args}]}]
		)

		Chat.Server.start_link
	end

	def stop(_reason) do
		:ok
	end


	defp port do
		case :os.getenv("PORT") do
			port_number -> List.to_integer(port_number)
			_ -> 4000
		end	
	end

	defp dispatch do
		[
			{
				:_,
				[
					{"/ws", Chat.Socket, []},
					{:_, Chat.Page, []}
				]
			}
		]
	end
end