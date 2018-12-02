defmodule Utilities do
  def lines(filename) do
    File.open!(filename, fn pid ->
      pid
      |> IO.stream(:line)
      |> Enum.map(&String.trim/1)
      |> Enum.into([])
    end)
  end

  def lines(filename, parse_action) do
    File.open!(filename, fn pid ->
      pid
      |> IO.stream(:line)
      |> Enum.map(&String.trim/1)
      |> Enum.map(parse_action)
      |> Enum.into([])
    end)
  end
end
