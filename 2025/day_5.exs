defmodule Cafeteria do
  def part_1(input) do
    input
    |> String.split("\n\n", parts: 2)
    |> count_fresh_ingredients()
  end

  def part_2(input) do
    [ranges, _ingredients] = String.split(input, "\n\n", parts: 2)

    ranges
    |> parse_ranges()
    |> count_inventory()
  end

  defp count_inventory(ranges) do
    ranges
    |> Enum.map(fn {range_start, range_end} -> range_end - range_start + 1 end)
    |> Enum.sum()
  end

  defp count_fresh_ingredients([ranges_input, ingredients_input]) do
    ranges = parse_ranges(ranges_input)

    ingredients_input
    |> parse_ingredients()
    |> Enum.count(&fresh?(&1, ranges))
  end

  defp fresh?(ingredient, ranges) do
    Enum.any?(ranges, fn {range_start, range_end} ->
      range_start <= ingredient and ingredient <= range_end
    end)
  end

  defp parse_ingredients(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  defp parse_ranges(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_range/1)
    |> Enum.sort()
    |> merge_ranges()
  end

  defp merge_ranges(ranges) do
    ranges
    |> Enum.reduce([], fn {start_range, end_range}, acc ->
      case acc do
        [] ->
          [{start_range, end_range}]

        [{prev_start, prev_end} | rest] when start_range > prev_end + 1 ->
          [{start_range, end_range}, {prev_start, prev_end} | rest]

        [{prev_start, prev_end} | rest] ->
          [{prev_start, max(prev_end, end_range)} | rest]
      end
    end)
    |> Enum.reverse()
  end

  defp parse_range(line) do
    [a, b] = String.split(line, "-", parts: 2)
    {String.to_integer(a), String.to_integer(b)}
  end
end

input = File.read!("2025/inputs/day_5.txt")
result_1 = Cafeteria.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = Cafeteria.part_2(input)
IO.inspect(result_2, label: "PART 2")
