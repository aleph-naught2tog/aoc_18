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
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(String.length(&1) === 0))
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()
    end)
    |> IO.inspect()
  end
  
  defp part_two(filename) do
    
  end
end

Main.run()