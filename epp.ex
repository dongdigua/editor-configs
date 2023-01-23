#! /usr/bin/elixir

defmodule EmacsPreProcess do
  def cmd() do
    argv = System.argv()
    case length(argv) do
      0 ->
        IO.puts "epp <file> <dump|excl>"
      1 ->
        IO.puts "epp <file> <dump|excl>"
      2 ->
        keyword = hd(tl(argv))
        if keyword == "dump" or keyword == "excl" do
          process(hd(argv), keyword)
        else
          IO.puts "?"
        end
      3 ->
        IO.puts "too many arguments"
    end
  end

  def process(file, keyword) do
    File.read!(file)
    |> String.split("\n")
    |> proc_loop(false, [], keyword)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def proc_loop([], _, acc, _), do: Enum.reverse acc

  def proc_loop([h | t], chunk_p, acc, keyword) do
    if chunk_p do
      if h == ";;;endif #{keyword}" do
          proc_loop(t, false, acc, keyword)
      else
        case keyword do
          "dump" -> proc_loop(t, chunk_p, [h | acc], keyword)
          "excl" -> proc_loop(t, chunk_p, acc, keyword)
        end
      end
    else
      if h == ";;;ifdef #{keyword}" do
        proc_loop(t, true, acc, keyword)
      else
        case keyword do
          "dump" -> proc_loop(t, chunk_p, acc, keyword)
          "excl" -> proc_loop(t, chunk_p, [h | acc], keyword)
        end
      end
    end
  end
end

EmacsPreProcess.cmd()
