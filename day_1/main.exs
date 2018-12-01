defmodule Main do
  def run(filename \\ "input.txt")

  def run(filename) do
    {repeated_sum, times_through_loop} = part_two(filename)
  end

  defp part_one(filename) do
    File.open!(filename, fn pid ->
      pid
      |> IO.stream(:line)
      |> parse_lines()
      |> Enum.sum()
    end)
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
    
    spawn(fn -> receive_loop([], 0) end)
    |> send_loop({lines, []}, 0)
  end

  defp send_loop(end_pid, {[], done}, sum) do
    send_loop(end_pid, {done, []}, sum)
  end

  defp send_loop(end_pid, {to_go, done}, aggregate) do
    [next_value | rest_stack] = to_go

    self_pid = self()
    spawn(fn -> send(end_pid, {self_pid, aggregate}) end)

    receive do
      {:halt, {value, counter}} ->
        {value, counter}

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

  defp receive_loop(value_list, counter) when is_list(value_list) do
    receive do
      {sender, value} ->
        if Enum.member?(value_list, value) do
          send(sender, {:halt, {value, counter}})
        else
          spawn(fn -> send(sender, :cont) end)
          receive_loop([value | value_list], counter + 1)
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

