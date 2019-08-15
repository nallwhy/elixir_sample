defmodule JspaceWeb.Router do
  use JspaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JspaceWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", JspaceWeb.Api, as: :api do
    pipe_through :api

    post "/sign_up", UserController, :sign_up
  end
end
