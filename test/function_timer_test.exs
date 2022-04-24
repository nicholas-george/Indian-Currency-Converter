defmodule FunctionTimerTest do
  use ExUnit.Case
  doctest FunctionTimer

  test "Module and function" do
    assert FunctionTimer.timed_fun(InrWord, :inr_word, [999_999_999.09]) |> elem(0) < 100
  end

  test "Captured Fn" do
    assert FunctionTimer.timed_fun(&InrWord.inr_word/1, 97) |> elem(1) == %{
             no: "₹ 97",
             words: "₹ Ninety-seven"
           }
  end
end
