defmodule ElixirAdvent.Day3 do
  @folder "day_3"
  @filename @folder <> ".txt"

  def run(folder) do
    folder
    |> Path.join(@folder)
    |> Path.join(@filename)
    |> part_one()
  end

  defp part_one(filename) do
    regex = get_regex()
    parser = &parse(regex, &1)
    lines = Utilities.lines(filename)
    |> Enum.map(parser)
    |> IO.inspect()
  end

  defp parse(regex, line) do
    regex
    |> Regex.named_captures(line)
    |> Enum.map(fn {key, value} -> {key, String.to_integer(value)} end)
  end

  defp get_regex() do
    ~r{(?x) # whitespace flag
        \#(?<claim_number> \d++ )
        [^\d]++
        (?<x> \d++ )
        ,
        (?<y> \d++ )
        [^\d]++
        (?<width> \d++ )
        x
        (?<height> \d++ )
      }
  end
end
