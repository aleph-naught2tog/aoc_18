defmodule Main do
  defmacro await(do: block) do
    quote do
      receive do
        unquote(block)
      after
        5000 ->
          IO.puts("no messages in receive")
          exit(:error)
      end
    end
  end

  def run(filename \\ "input.txt")

  def run(filename) do
    part_two(filename)
    |> IO.inspect()
  end

  defp parse_lines(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  defp part_two(filename) do
    lines =
      File.open!(filename, fn pid ->
        pid
        |> IO.stream(:line)
        |> parse_lines()
      end)

    spawn(fn -> receive_loop([], {nil, nil}) end)
    |> send_loop({lines, []}, 0)
  end

  defp send_loop(end_pid, {[], done}, aggregate) do
    send_loop(end_pid, {done, []}, aggregate)
  end

  defp send_loop(end_pid, {to_go, done}, aggregate) do
    [next_value | rest_stack] = to_go

    self_pid = self()

    # send our message
    spawn(fn -> send(end_pid, {self_pid, aggregate}) end)

    # and wait for our response
    await do
      {:halt, {value, counter}} ->
        {value, counter}

      :cont ->
        new_aggregate = aggregate + next_value
        send_loop(end_pid, {rest_stack, done ++ [next_value]}, new_aggregate)

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp receive_loop(value_list, {nil, nil}) do
    await do
      {sender, value} ->
        spawn(fn -> send(sender, :cont) end)
        receive_loop([value | value_list], {value, value})

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp receive_loop(value_list, {min, max}) do
    await do
      {sender, value} when value === min ->
        send(sender, {:halt, {value, 0}})

      {sender, value} when value === max ->
        send(sender, {:halt, {value, 0}})

      {sender, value} when value < min ->
        spawn(fn -> send(sender, :cont) end)
        receive_loop([value | value_list], {value, max})

      {sender, value} when value > max ->
        spawn(fn -> send(sender, :cont) end)
        receive_loop([value | value_list], {min, value})

      {sender, value} ->
        if Enum.member?(value_list, value) do
          send(sender, {:halt, {value, 0}})
        else
          spawn(fn -> send(sender, :cont) end)
          receive_loop([value | value_list], {min, max})
        end

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end
end

Main.run()