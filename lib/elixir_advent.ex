defmodule ElixirAdvent do
  alias ElixirAdvent.{Day1, Day2, Day3, Day4}
  @input_folder "input"

  @modules {
    Day1, Day2, Day3, Day4
  }

  def main([]) do
    @modules
    |> Tuple.to_list()
    |> Enum.map(&(apply(&1, :run, [@input_folder])))
  end

  def main([which | _command_line_arguments]) do
    index = String.to_integer(which)
    module = elem(@modules, index - 1)
    module.run(@input_folder)
  end
end
