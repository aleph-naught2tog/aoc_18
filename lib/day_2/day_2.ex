defmodule ElixirAdvent.Day2 do
  @folder "day_2"
  @filename @folder <> ".txt"

  def run(folder) do
    filename = folder
    |> Path.join(@folder)
    |> Path.join(@filename)
    |> IO.inspect()

    {left, right} = part_one(filename)
    |> IO.inspect()

    IO.inspect(left * right)
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
    values =
    String.to_charlist(a)
    |> Enum.group_by(fn v -> v end)
    |> Enum.reject(fn {_,v} -> length(v) < 2 end)
    |> Enum.map(fn {_,v} -> length(v) end)
    |> Enum.dedup()
  end
end
