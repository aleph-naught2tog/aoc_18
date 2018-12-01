defmodule Main do
  def run(filename \\ "input.txt")

  def run(filename) do
    part_one(filename)
    part_two(filename)
  end

  defp part_one(filename) do
    File.open!(filename, fn pid ->
      pid
      |> IO.stream(:line)
      |> parse_lines()
      |> Enum.sum()
    end)
    |> IO.inspect()
  end

  defp parse_lines(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(String.length(&1) === 0))
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
  end

  defp part_two(filename) do
    lines =
      File.open!(filename, fn pid ->
        pid
        |> IO.stream(:line)
        |> parse_lines()
      end)
    # lines = parse_lines(~w{+3 +3 +4 -2 -4}) # -> 10
    # lines = parse_lines(~w{-6 +3 +8 +5 -6}) # -> 5
    # lines = parse_lines(~w{+7 +7 -2 -7 -4}) # -> 14
      
    spawn(fn -> receive_loop([]) end)
    |> send_loop({lines, []}, 0)
    |> IO.inspect()
  end

  defp send_loop(end_pid, {[], done}, sum) do
    IO.puts("----")
    send_loop(end_pid, {done, []}, sum)
  end

  defp send_loop(end_pid, {to_go, done}, aggregate) do
    IO.puts("length: #{length(to_go)}, #{length(done)}, #{aggregate}")
    [next_value | rest_stack] = to_go

    self_pid = self()
    spawn(fn -> send(end_pid, {self_pid, aggregate}) end)

    receive do
      {:halt, value} ->
        value

      :cont ->
        new_aggregate = aggregate + next_value
        send_loop(end_pid, {rest_stack, done ++ [next_value]}, new_aggregate)

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    after
      5000 ->
        IO.puts("no messages in send")
        exit(:error)
    end
  end

  defp receive_loop(value_list) when is_list(value_list) do
    receive do
      {sender, value} ->
        IO.inspect(value_list)

        if Enum.member?(value_list, value) do
          send(sender, {:halt, value})
        else
          spawn(fn -> send(sender, :cont) end)
          receive_loop([value | value_list])
        end

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    after
      5000 ->
        IO.puts("no messages in receive")
        exit(:error)
    end
  end
end

Main.run()

