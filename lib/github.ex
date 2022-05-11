defmodule GitHub do
  @moduledoc """
  This module uses Tesla to use the Github API and output
  the info of a repository.
  """
  # notice there is no `use Tesla`
  def user_repos(client, login) do
    # pass `client` argument to `Tesla.get` function
    Tesla.get(client, "/users/" <> login <> "/repos")
  end

  def issues(client) do
    Tesla.get(client, "/issues")
  end

  # build dynamic client based on runtime arguments
  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "token: " <> token}]}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end

  def all_repos(user_name, client) do
    {:ok, response} = client |> user_repos(user_name)
    Enum.map(response.body, fn repo -> Map.fetch(repo, "name") |> elem(1) end)
  end

  def repo_info(client, user_name, repo_name) do
    {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name)
    name = Map.fetch(response.body, "name") |> elem(1)

    {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name <> "/commits")
    commits = length(response.body)

    {:ok, response} =
      Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name <> "/languages")
    languages = Enum.map(response.body, fn {k, _} -> k end) |> Enum.join(" ")

    {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name)
    owner = Map.fetch(response.body, "owner") |> elem(1) |> Map.fetch("login") |> elem(1)

    %{name: name, commits: commits, languages: languages, owner: owner}
  end
end
