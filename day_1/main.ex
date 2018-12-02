defmodule Main do
  use Bitwise

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

  defmacro below?(value, min) do
    quote do
      unquote(value) < unquote(min)
    end
  end

  defmacro above?(value, max) do
    quote do
      unquote(value) > unquote(max)
    end
  end

  defguard is_even(value) when band(value, 1) === 0
  defguard is_odd(value) when band(value, 1) === 1

  defguard found(value, min, max) when value === min or value === max

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

  defp receive_loop([], {nil, nil}) do
    await do
      {sender, 0} ->
        spawn(fn -> send(sender, :cont) end)

        {{[], []}, {[], []}}
        |> receive_loop({0, 0})

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp receive_loop(value_list, {min, max}) do
    IO.write('.')

    receive do
      {sender, value} ->

        name =
          value
          |> Integer.to_string()
          |> String.to_atom()

        if Process.whereis(name) do
          send(sender, {:halt, {value, nil}})
        else
          send(sender, :cont)
          new_pid = spawn(fn -> continue(sender) end)

          Process.register(new_pid, name)
          receive_loop(value_list, {min, max})
        end

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end
  
  defp continue(sender) do
    receive do
      _ -> :noop
    end
  end
end

