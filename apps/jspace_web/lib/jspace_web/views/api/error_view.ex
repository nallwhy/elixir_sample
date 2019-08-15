defmodule JspaceWeb.Api.ErrorView do
  use JspaceWeb, :view

  def render("401.json", _assgins) do
    %{
      error_code: :unauthenticated
    }
  end

  def render("500.json", _assigns) do
    %{
      error_code: :unknown_error
    }
  end

  def render("400.json", %{reason: reason}) do
    %{
      error_code: reason
    }
  end

  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
