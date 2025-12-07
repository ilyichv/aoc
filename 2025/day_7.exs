defmodule Laboratories do
  def part_1(input) do
    input
    |> parse_grid()
    |> solve()
  end

  def part_2(input) do
    input
    |> parse_grid()
    |> solve_timelines()
  end

  defp solve_timelines(grid) do
    start = find_start(grid)
    count_timelines(grid, start, :down, MapSet.new(), %{})
  end

  defp count_timelines(grid, pos, direction, visited, cache) do
    beam = {pos, direction}

    cond do
      MapSet.member?(visited, beam) ->
        {0, cache}

      Map.has_key?(cache, beam) ->
        {cache[beam], cache}

      true ->
        visited = MapSet.put(visited, beam)
        new_pos = move(pos, direction)

        {result, cache} =
          case Map.get(grid, new_pos, nil) do
            nil ->
              {1, cache}

            "." ->
              count_timelines(grid, new_pos, :down, visited, cache)

            "^" ->
              {left, cache} = count_timelines(grid, new_pos, :left, visited, cache)
              {right, cache} = count_timelines(grid, new_pos, :right, visited, cache)
              {left + right, cache}
          end

        {result, Map.put(cache, beam, result)}
    end
  end

  defp solve(grid) do
    start = find_start(grid)
    simulate(grid, [{start, :down}], MapSet.new(), 0)
  end

  defp simulate(_, [], _, split_count), do: split_count

  defp simulate(grid, [{pos, direction} | tail], visited, split_count) do
    new_pos = move(pos, direction)

    if MapSet.member?(visited, new_pos) do
      simulate(grid, tail, visited, split_count)
    else
      new_visited = MapSet.put(visited, new_pos)

      case Map.get(grid, new_pos, nil) do
        nil ->
          simulate(grid, tail, new_visited, split_count)

        "." ->
          simulate(grid, [{new_pos, :down} | tail], new_visited, split_count)

        "^" ->
          new_beams = [{new_pos, :left}, {new_pos, :right}]
          simulate(grid, new_beams ++ tail, new_visited, split_count + 1)
      end
    end
  end

  defp find_start(grid) do
    {pos, _char} = Enum.find(grid, fn {_pos, char} -> char == "S" end)
    pos
  end

  defp parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} -> {{row, col}, char} end)
    end)
    |> Map.new()
  end

  defp move({row, col}, :down), do: {row + 1, col}
  defp move({row, col}, :left), do: {row, col - 1}
  defp move({row, col}, :right), do: {row, col + 1}
end

input = File.read!("2025/inputs/day_7.txt")
result_1 = Laboratories.part_1(input)
IO.inspect(result_1, label: "PART 1")
{result_2, _} = Laboratories.part_2(input)
IO.inspect(result_2, label: "PART 2")
