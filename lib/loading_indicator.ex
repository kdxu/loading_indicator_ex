defmodule LoadingIndicator do
  @spinner ["-", "\\", "|", "/"]

  def run(to) do
    1..to
    |> Stream.map(fn _ -> :timer.sleep(50) end)
    |> Stream.transform(fn -> %{device: :stderr, num: 0} end, &spin/2, &finish/1)
    |> Stream.run()
  end

  defp spin(e, %{device: device, num: num}) do
    {[e], write_device(device, num)}
  end

  defp finish(%{device: device}) do
    IO.write(device, "\n")
  end

  defp write_device(device, num) do
    IO.write(device, "\r" <> Enum.at(@spinner, rem(num, 4)))
    %{device: device, num: num + 1}
  end
end
