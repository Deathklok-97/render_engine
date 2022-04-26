# Botiful

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `botiful` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:botiful, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/botiful](https://hexdocs.pm/botiful).

DOCKER SETUP:
docker run -it --shm-size 2G -p 1330:1330 -p 1331:1331 chroxy

HTML RENDER:
Botiful.Render.html("https://www.midwayusa.com")