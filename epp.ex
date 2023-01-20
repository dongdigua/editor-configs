#! /usr/bin/elixir

defmodule EmacsPreProcess do
  def process(file) do
    File.read!(file)
    |> String.split("\n")
    |> proc_loop(false, [])
    |> Enum.join("\n")
    |> IO.puts()
  end

  def proc_loop([], _, acc), do: Enum.reverse acc

  def proc_loop([h | t], chunk_p, acc) do
    if chunk_p do
      if h == ";;;endif" do
        proc_loop(t, false, acc)
      else
        proc_loop(t, chunk_p, [h | acc])
      end
    else
      if h == ";;;ifdef dump" do
        proc_loop(t, true, acc)
      else
        proc_loop(t, chunk_p, acc)
      end
    end
  end
end

EmacsPreProcess.process(".emacs")
