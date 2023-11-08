defmodule Basilisk.Git do
  alias Basilisk.Git

  @version Application.compile_env(:basilisk, :version)

  def commit_sha() do
    "git"
    |> System.cmd(["rev-parse", "HEAD"])
    |> elem(0)
    |> String.trim()
    |> String.slice(0, 7)
  end

  def commits_from_latest() do
    "git"
    |> System.cmd(["rev-list", "#{@version}..HEAD", "--count"])
    |> elem(0)
  end

  def version() do
    case Git.commits_from_latest() do
      "0\n" -> @version
      commits -> "#{@version}+#{commits}"
    end
  end
end
