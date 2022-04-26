defmodule BotifulTest do
  use ExUnit.Case
  doctest Botiful

  test "greets the world" do
    assert Botiful.hello() == :world
  end
end
