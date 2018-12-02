defmodule Main do
  def run(filename \\ "input.txt") do
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

    spawn(fn -> receive_loop() end)
    |> send_loop({lines, []}, 0, 0)
  end

  defp send_loop(end_pid, {[], done}, aggregate, counter) do
    send_loop(end_pid, {done, []}, aggregate, counter)
  end

  defp send_loop(end_pid, {[next_value | rest_stack], done}, aggregate, counter) do
    self_pid = self()
    spawn(fn -> send(end_pid, {self_pid, aggregate}) end)

    receive do
      {:halt, value} ->
        {value, counter}

      :cont ->
        counter = counter + 1
        new_aggregate = aggregate + next_value

        send_loop(
          end_pid,
          {rest_stack, done ++ [next_value]},
          new_aggregate,
          counter
        )

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp to_key(value) do
    value
    |> Integer.to_string()
    |> String.to_atom()
  end

  defp receive_loop() do
    receive do
      {sender, value} ->
        name = to_key(value)

        if Process.whereis(name) do
          send(sender, {:halt, value})
        else
          send(sender, :cont)

          new_pid = spawn(&block/0)

          Process.register(new_pid, name)
          
          receive_loop()
        end

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp block() do
    receive do
      _ -> :noop
    end
  end
end

