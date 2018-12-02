defmodule Mix.Tasks.Runner do
  use Mix.Task

  def run(args) do
    ElixirAdvent.main(args)
  end
end
