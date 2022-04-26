defmodule Botiful.Render  do
  alias Botiful.Render.Engine


 def html(url) do
  {:ok, pid} = Engine.start_link(url)
  {:ok, wait_for_html(pid)}
 end

 defp wait_for_html(pid) do
   case Engine.html(pid) do
      :incomplete ->
        wait_for_html(pid)

      html when is_binary(html) ->
        Engine.stop(pid)
        html
   end
 end

end
