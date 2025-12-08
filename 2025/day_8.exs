defmodule Playground do
  def part_1(input) do
    boxes = parse_input(input)
    pairs = generate_pairs(boxes) |> Enum.take(1000)

    build_circuits(boxes, pairs)
    |> get_circuit_sizes()
    |> Enum.take(3)
    |> Enum.product()
  end

  def part_2(input) do
    boxes = parse_input(input)
    pairs = generate_pairs(boxes)

    build_single_circuit(boxes, pairs)
    |> part_2_result(boxes)
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_coordinate/1)
    |> Enum.with_index()
  end

  defp parse_coordinate(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  defp generate_pairs(boxes) do
    for {box1, i} <- boxes,
        {box2, j} <- boxes,
        i < j do
      distance = squared_distance(box1, box2)
      {distance, i, j}
    end
    |> Enum.sort()
  end

  defp squared_distance({x1, y1, z1}, {x2, y2, z2}) do
    (x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2
  end

  defp build_circuits(boxes, pairs) do
    initial_state = %{
      parents: Map.new(Enum.to_list(0..(length(boxes) - 1)), fn i -> {i, i} end),
      sizes: Map.new(Enum.to_list(0..(length(boxes) - 1)), fn i -> {i, 1} end)
    }

    Enum.reduce(pairs, initial_state, fn {_distance, node1, node2}, state ->
      {state, _merged} = union(state, node1, node2)
      state
    end)
  end

  defp build_single_circuit(boxes, pairs) do
    total_boxes = length(boxes)

    initial_state = %{
      parents: Map.new(Enum.to_list(0..(total_boxes - 1)), fn i -> {i, i} end),
      sizes: Map.new(Enum.to_list(0..(total_boxes - 1)), fn i -> {i, 1} end),
      left: total_boxes
    }

    Enum.reduce_while(pairs, initial_state, fn {_distance, node1, node2}, state ->
      {new_state, merged?} = union(state, node1, node2)

      new_state =
        if merged?,
          do: update_in(new_state.left, &(&1 - 1)),
          else: new_state

      if new_state.left == 1 do
        {:halt, {node1, node2}}
      else
        {:cont, new_state}
      end
    end)
  end

  defp find(state, node) do
    parent = state.parents[node]

    if(parent == node) do
      {state, node}
    else
      {new_state, root} = find(state, parent)
      updated = put_in(new_state.parents[node], root)
      {updated, root}
    end
  end

  defp union(state, node1, node2) do
    {state, root1} = find(state, node1)
    {state, root2} = find(state, node2)

    if root1 == root2 do
      {state, false}
    else
      size1 = Map.fetch!(state.sizes, root1)
      size2 = Map.fetch!(state.sizes, root2)

      new_state =
        cond do
          size1 >= size2 ->
            state
            |> put_in([:parents, root2], root1)
            |> update_in([:sizes, root1], &(&1 + size2))

          true ->
            state
            |> put_in([:parents, root1], root2)
            |> update_in([:sizes, root2], &(&1 + size1))
        end

      {new_state, true}
    end
  end

  defp get_circuit_sizes(state) do
    state.parents
    |> Map.keys()
    |> Enum.map(fn box ->
      {_state, root} = find(state, box)
      root
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
  end

  defp part_2_result({node1, node2}, boxes) do
    {{x1, _, _}, _} = Enum.at(boxes, node1)
    {{x2, _, _}, _} = Enum.at(boxes, node2)

    x1 * x2
  end
end

input = File.read!("2025/inputs/day_8.txt")
result_1 = Playground.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = Playground.part_2(input)
IO.inspect(result_2, label: "PART 2")

# What I found useful for resolution
# https://en.wikipedia.org/wiki/Kruskal%27s_algorithm
# https://en.wikipedia.org/wiki/Disjoint-set_data_structure
