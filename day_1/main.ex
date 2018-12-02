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
    await do
      {sender, 0} ->
        send(sender, {:halt, {0, 0}})

      {sender, value} when found(value, min, max) ->
        send(sender, {:halt, {value, 0}})

      {sender, value} ->
        cond do
          below?(value, min) ->
            spawn(fn -> send(sender, :cont) end)

            value_list
            |> add(value)
            |> receive_loop({value, max})

          above?(value, max) ->
            spawn(fn -> send(sender, :cont) end)

            value_list
            |> add(value)
            |> receive_loop({min, value})

          true ->
            if member?(value_list, value) do
              send(sender, {:halt, {value, 0}})
            else
              spawn(fn -> send(sender, :cont) end)

              value_list
              |> add(value)
              |> receive_loop({min, max})
            end
        end

      _other ->
        IO.puts("unexpected message, raising")
        exit(:error)
    end
  end

  defp add({{_neg_even, _neg_odd} = neg, pair}, value) when above?(value, 0) do
    index = rem(value, 2)
    list = elem(pair, index)
    {neg, put_elem(pair, index, [value | list])}
  end

  defp add({pair, {_pos_even, _pos_odd} = pos}, value) when below?(value, 0) do
    index = abs(rem(value, 2))
    list = elem(pair, index)
    {pos, put_elem(pair, index, [value | list])}
  end

  defp member?({_neg, {_, positive}}, value) when is_odd(value) and above?(value, 0) do
    Enum.member?(positive, value)
  end

  defp member?({_neg, {positive, _}}, value) when is_even(value) and above?(value, 0) do
    Enum.member?(positive, value)
  end

  defp member?({{_, negative}, _pos}, value) when is_odd(value) and below?(value, 0) do
    Enum.member?(negative, value)
  end

  defp member?({{negative, _}, _pos}, value) when is_even(value) and below?(value, 0) do
    Enum.member?(negative, value)
  end
end

