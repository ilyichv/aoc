defmodule GiftShop do
  # PART 1
  def part_1(input), do: process(input, :part_1)

  # PART 2
  def part_2(input), do: process(input, :part_2)

  defp process(input, part) do
    input
    |> Enum.flat_map(&parse_range/1)
    |> Enum.filter(&is_valid_pattern?(&1, part))
    |> Enum.sum()
  end

  defp parse_range(range) do
    [range_start, range_end] =
      range
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    range_start..range_end
  end

  defp is_valid_pattern?(input, :part_1) do
    digits = Integer.digits(input)
    digits_length = length(digits)
    pattern_length = div(digits_length, 2)
    {first_half, second_half} = Enum.split(digits, pattern_length)
    first_half == second_half
  end

  defp is_valid_pattern?(input, :part_2) do
    digits = Integer.digits(input)

    if length(digits) == 1 do
      false
    else
      1..div(length(digits), 2)
      |> Enum.any?(fn chunk_size ->
        Enum.chunk_every(digits, chunk_size)
        |> Enum.map(&Integer.undigits/1)
        |> MapSet.new()
        |> MapSet.size()
        |> Kernel.==(1)
      end)
    end
  end
end

input = File.read!("2025/inputs/day_2.txt") |> String.replace("\n", "") |> String.split(",")
result_1 = GiftShop.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = GiftShop.part_2(input)
IO.inspect(result_2, label: "PART 2")
