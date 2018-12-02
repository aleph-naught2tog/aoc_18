defmodule ElixirAdvent.Day2 do
  @folder "day_2"
  @filename @folder <> ".txt"

  def run(folder) do
    folder
    |> Path.join(@folder)
    |> Path.join(@filename)
    |> IO.inspect()
  end
end
