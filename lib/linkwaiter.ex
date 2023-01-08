defmodule Linkwaiter do
  def basepath do
    Application.fetch_env!(:linkwaiter, :basepath)
  end

  # NOTE: url must start with "/"
  def put_basepath(url) do
    "/" <> basepath() <> url
  end
end
