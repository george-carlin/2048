defmodule TwoOhFourEight.Game.Grid.Row do
  # A chunk is an obstacle-free section of row.
  defmodule Chunk do
    def shift(chunk) do
      original_length = length(chunk)

      chunk
      |> compact()
      |> merge()
      |> zero_pad(original_length)
    end

    # removes all zeroes
    defp compact(chunk) do
      for tile <- chunk, tile != 0, do: tile
    end

    # merges all elements leftwards.
    defp merge(chunk), do: merge(chunk, [])

    defp merge([], acc) do
      Enum.reverse(acc)
    end

    defp merge([n], acc) do
      merge([], [n | acc])
    end

    defp merge([val, val | tail], acc) do
      merge(tail, [val*2 | acc])
    end

    defp merge([val | tail], acc) do
      merge(tail, [val | acc])
    end

    defp zero_pad(chunk, max_length) do
      zeroes = Stream.cycle([0]) |> Enum.take(max_length - length(chunk))
      chunk ++ zeroes
    end
  end

  @obstacle -1

  # We only define a leftward shift; all other grid moves are performed by
  # flipping and/or transposing the grid, shifting left then flipping/
  # transposing back.
  def shift(row) do
    row
    |> split()
    |> Enum.map(&Chunk.shift/1)
    |> Enum.intersperse([@obstacle])
    |> List.flatten()
  end

  defp split(row) do
    row
    |> Enum.reverse()
    |> split([[]])
  end

  defp split([], chunks) do
    chunks
  end

  defp split([@obstacle | tail], chunks) do
    split(tail, [[] | chunks])
  end

  defp split([n | tail], [current_chunk | chunks]) do
    split(tail, [[n | current_chunk] | chunks])
  end
end
