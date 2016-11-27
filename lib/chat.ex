defmodule Chat.Page do
	@pathbase "web"

	def init(_, request, []) do
		{:ok, request, nil}
	end

	def handle(request, state) do
		{path, _request} = :cowboy_req.path(request)

		{:ok, content} = File.read(@pathbase <> path)
		{:ok, request} = :cowboy_req.reply(200, [{"Content-Type", mime_type(path)}], content, request)

		{:ok, request, state}
	end

	defp mime_type(filename) do
		case Path.extname(filename) do
			".html" -> "text/html"
			".js" -> "application/javascript"
			".css" -> "text/css"
			_ -> "text/plain"
		end
	end

	def terminate(_reason, _request, _state) do
		:ok
	end
end


defmodule Chat do
	@behaviour :application
  @port_default 4000

	def start(_type, _args) do
		args = :cowboy_router.compile(dispatch)

		:cowboy.start_http(
			:my_http_listener, 
			100, 
			[{:port, port()}], 
			[{:env, [{:dispatch, args}]}]
		)

		Chat.Server.start_link
	end

	def stop(_reason) do
		:ok
	end


	defp port do
    port_number = System.argv ++ [""] |> List.first

    cond do
      String.match?(port_number, ~r/^[0-9]+$/) ->  String.to_integer(port_number)
      true -> @port_default
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
