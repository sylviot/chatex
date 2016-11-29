defmodule Chat.Test do
  use ExUnit.Case, async: true

  test "nice project", do: assert !!"Nice project?"


  @room_name "geral"
  @user_name "username"
  
  test "join/leave on server" do
    assert {:ok, rooms} = :gen_server.call(:chat_server, {:join, @room_name, @user_name})

    assert List.keymember?(rooms, @room_name, 0)

    assert {:ok, rooms} = :gen_server.call(:chat_server, {:leave, @room_name, @user_name})

    {room_name, users} = List.keyfind(rooms, @room_name, 0)

    assert Enum.empty?(users)
  end

  test "online on server" do
    :gen_server.call(:chat_server, {:join, @room_name, @user_name})

    assert {:ok, rooms} = :gen_server.call(:chat_server, {:online, @room_name})

    {room_name, users} = List.keyfind(rooms, @room_name, 0)
    users = HashSet.to_list(users) |> Enum.map( fn {pid, name} -> name end)
    
    assert @room_name == room_name
    assert [@user_name] == users
    
    :gen_server.call(:chat_server, {:leave, @room_name, @user_name})
  end
end
