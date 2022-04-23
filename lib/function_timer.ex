defmodule FunctionTimer do
  @moduledoc """
  Provides two functions `timed_fun/2` and `timed_fun/3` to time any passed function. Function:
    - can be passed as captured using `timed_fun/2`
    - can be passed as Module, Function using `timed_fun/3`

  ## Example
    # To pass a captured function
    iex> FunctionTimer.timed_fun(&InrWord.inr_word/1, 97) |> elem(1)
    true

    # To pass a Module, Function
    iex> FunctionTimer.timed_fun(InrWord, :inr_word, [97]) |> elem(1)
    true

  """

  @doc """
    # To pass a captured function

      iex(1)> FunctionTimer.timed_fun(&InrWord.inr_word/1, 97) |> elem(1)
      %{no: "₹ 97", words: "₹ Ninety-seven"}
  """
  @spec timed_fun(function, any, any) :: {integer, any}
  def timed_fun(f, no) do
    no_opts = if is_list(no), do: no, else: List.wrap(no)
    :timer.tc(fn -> apply(f, no_opts) end)
  end

  @doc """
    # To pass a Module, Function

      iex(4)> FunctionTimer.timed_fun(InrWord, :inr_word, [97]) |> elem(1)
      %{no: "₹ 97", words: "₹ Ninety-seven"}
  """
  @spec timed_fun(Module, function, any) :: {integer, any}
  def timed_fun(m, f, opts) do
    :timer.tc(fn -> apply(m, f, opts) end)
  end
end
