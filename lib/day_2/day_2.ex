defmodule ElixirAdvent.Day2 do
  @folder "day_2"
  @filename @folder <> ".txt"

  def run(folder) do
    filename = folder
    |> Path.join(@folder)
    |> Path.join(@filename)

    {left, right} = part_one(filename)

    IO.puts("-----")
    IO.inspect({left, right}, label: "part_one, #{left * right}")
    IO.puts("-----")
    part_two(filename)
    |> IO.inspect(label: "part_two")
    IO.puts("-----")
  end

  defp part_one(filename) do
    values = filename
    |> Utilities.lines()
    |> Enum.map(&count/1)

    twice = Enum.count(values, &Enum.member?(&1, 2))
    three_times = Enum.count(values, &Enum.member?(&1, 3))
    {twice, three_times}
  end

  defp count(a) do
    String.to_charlist(a)
    |> Enum.group_by(fn v -> v end)
    |> Enum.reject(fn {_,v} -> length(v) < 2 end)
    |> Enum.map(fn {_,v} -> length(v) end)
    |> Enum.dedup()
  end

  defp part_two(filename) do
    [one, two] = filename
    |> Utilities.lines(&String.to_charlist/1)
    |> roll()
    |> Enum.reject(fn v -> length(v) === 0 end)
    |> Enum.map(&to_string/1)

    String.myers_difference(one, two)
    |> Enum.filter(fn {key, _value} -> key === :eq end)
    |> Enum.map(fn {_, value} -> value end)
    |> Enum.reduce(fn l, r -> r <> l end)
  end

  defp roll(lines) do
    lines
    |> Enum.map(fn line ->
      lines
      |> Enum.filter(fn other_line ->
        count = count_dissimilar_characters(line, other_line)
        count === 1
      end)
    end)
    |> Enum.dedup()
  end

  defp count_dissimilar_characters(line, other_line) do
    line
    |> Enum.zip(other_line)
    |> Enum.reject(&compare_chars/1)
    |> Enum.count()
  end

  defp compare_chars({char, other_char}) do
    char === other_char
  end
end
