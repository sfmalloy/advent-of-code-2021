# registers defined as [w, x, y, z]
defmodule Computer do
  def run(program, ipt) do
    run(program, [0, 0, 0, 0], ipt)
  end

  defp run([""], reg, _) do
    reg
  end

  defp run([curr | rest], reg, ipt) do
    {reg, ipt} = eval(String.split(curr, " "), reg, ipt)
    run(rest, reg, ipt)
  end

  defp eval(["inp", r], [w, x, y, z], [curr_ipt | rest]) do
    reg = case r do
      "w" -> [curr_ipt, x, y, z]
      "x" -> [w, curr_ipt, y, z]
      "y" -> [w, x, curr_ipt, z]
      "z" -> [w, x, y, curr_ipt]
    end
    {reg, rest}
  end

  defp eval(["add", a, b], reg, ipt) do
    res = arg(a, reg) + arg(b, reg)
    {updated_reg(a, res, reg), ipt}
  end

  defp eval(["mul", a, b], reg, ipt) do
    res = arg(a, reg) * arg(b, reg)
    {updated_reg(a, res, reg), ipt}
  end

  defp eval(["div", a, b], reg, ipt) do
    res = div(arg(a, reg), arg(b, reg))
    {updated_reg(a, res, reg), ipt}
  end

  defp eval(["mod", a, b], reg, ipt) do
    res = rem(arg(a, reg), arg(b, reg))
    {updated_reg(a, res, reg), ipt}
  end

  defp eval(["eql", a, b], reg, ipt) do
    res = if arg(a, reg) == arg(b, reg) do 1 else 0 end
    {updated_reg(a, res, reg), ipt}
  end

  defp arg(a, [w, x, y, z]) do
    case a do
      "w" -> w
      "x" -> x
      "y" -> y
      "z" -> z
      _ -> String.to_integer(a)
    end
  end

  defp updated_reg(key, val, reg) do
    case {key, reg} do
      {"w", [_, x, y, z]} -> [val, x, y, z]
      {"x", [w, _, y, z]} -> [w, val, y, z]
      {"y", [w, x, _, z]} -> [w, x, val, z]
      {"z", [w, x, y, _]} -> [w, x, y, val]
    end
  end
end


{:ok, ipt} = File.read("inputs/Day24.in")
prog = String.split(ipt, "\n")
#                              0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10
IO.inspect(Computer.run(prog, [1, 1, 1, 4, 1, 1, 9, 8, 1, 1, 1, 3, 1, 1]))
# ,  1,  9,  7,  9

# subprogs =
#   ipt
#   |> String.split("inp w\n")
#   |> tl()
#   |> Enum.map(
#     fn prog ->
#       subprog = String.split(prog, "\n")
#       ["inp w", "inp z" | subprog]
#     end)
# IO.inspect(subprogs)

# defmodule Solve do
#   def run([prog | subprogs], w_inputs \\ [], z_inputs \\ [0], memo \\ %{}) do
#     for i <- 9..1\\-1 do

#     end
#     memo
#   end

#   def run([""], w_inputs, z_inputs, memo) do
#     # Map.put(memo, {w_inputs, z}, z)
#     # z
#   end
# end

# [w, x, y, z] = Computer.run(prog, [9, 9, 6, 9, 9, 9, 9, 9, 2, 7])
# defmodule Solve do
#   def guess(prog, lst, [{upper, lower} | limit_tail], parent) do
#     for i <- (upper)..(lower)//-1 do
#       guess(prog, lst ++ [i], limit_tail, parent)
#     end
#     nil
#   end

#   def guess(prog, lst, [], parent) do
#     [_, _, _, z] = Computer.run(prog, lst)
#     z
#   end
# end

# for i <- 1..9 do
#   spawn_link(
#     Solve,
#     :guess,
#     [
#       prog,
#       [],
#       [
#         {1, 1},
#         {7, 7},
#         {6, 6},
#         {9, 9},
#         {9, 9},
#         {i, i},
#         {9, 1},
#         {9, 1},
#         {9, 1},
#         {9, 1},
#         {9, 1},
#         {9, 1},
#         {9, 1},
#         {9, 1}
#       ],
#       parent
#     ]
#   )
# end

# receive do
#   {:yo, {lst, z}} -> IO.inspect(lst, label: "z=#{z}")
# end




# IO.puts("#{w} #{x} #{y} #{z}")
# IO.puts("#{rem(z, 26) - 5}")
# Solve.guess(prog, [9, 9, 6, 9, 9, 9, 8])


# x = %{}
# x = Map.put(x, {1, 2}, 2)
# IO.inspect(x)

# l = fn lst -> if length(list) == 5 do IO.puts("done") else l() end end
