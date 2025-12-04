defmodule PrintingDepartment do
  def part_1(input) do
    input
    |> parse_grid()
    |> count_isolated_positions()
  end

  def part_2(input) do
    input
    |> parse_grid()
    |> remove_isolated_positions()
  end

  defp remove_isolated_positions(grid, acc \\ 0) do
    picked = Enum.filter(grid, &isolated?(&1, grid)) |> MapSet.new()

    case MapSet.size(picked) do
      0 ->
        acc

      count ->
        grid
        |> MapSet.difference(picked)
        |> remove_isolated_positions(acc + count)
    end
  end

  defp count_isolated_positions(grid) do
    Enum.count(grid, &isolated?(&1, grid))
  end

  defp parse_grid(input) do
    for {line, x} <- Enum.with_index(input),
        {char, y} <- line |> String.graphemes() |> Enum.with_index(),
        char == "@" do
      {x, y}
    end
    |> MapSet.new()
  end

  defp isolated?(pos, grid) do
    pos
    |> neighbors()
    |> Enum.count(&MapSet.member?(grid, &1))
    |> Kernel.<(4)
  end

  defp neighbors({x, y}) do
    for dx <- -1..1,
        dy <- -1..1,
        {dx, dy} != {0, 0} do
      {x + dx, y + dy}
    end
  end
end

input = File.read!("2025/inputs/day_4.txt") |> String.split("\n")
result_1 = PrintingDepartment.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = PrintingDepartment.part_2(input)
IO.inspect(result_2, label: "PART 2")
