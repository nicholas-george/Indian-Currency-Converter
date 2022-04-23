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

  # (&IsPrime.is_prime/1, 97)
  @spec timed_fun(function, any, any) :: {integer, any}
  def timed_fun(f, no) do
    no_opts = if is_list(no), do: no, else: List.wrap(no)
    :timer.tc(fn -> apply(f, no_opts) end)
  end

  # => (IsPrime, :is_prime, [97])
  @spec timed_fun(Module, Function, any) :: {integer, any}
  def timed_fun(m, f, opts) do
    :timer.tc(fn -> Kernel.apply(m, f, opts) end)
  end
end
