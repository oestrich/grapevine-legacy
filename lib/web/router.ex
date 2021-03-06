defmodule Web.Router do
  use Web, :router

  @report_errors Application.get_env(:gossip, :errors)[:report]

  if @report_errors do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Web.Plugs.FetchUser
  end

  pipeline :logged_in do
    plug Web.Plugs.EnsureUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Web.Plugs.FetchUser, api: true
  end

  pipeline :api_authenticated do
    plug Web.Plugs.EnsureUser, api: true
  end

  scope "/", Web do
    pipe_through([:browser])

    get "/", PageController, :index

    resources("/games", GameController, only: [:index, :show]) do
      resources("/achievements", AchievementController, only: [:index])
    end

    get("/media", PageController, :media)

    resources("/register", RegistrationController, only: [:new, :create])

    get("/register/reset", RegistrationResetController, :new)
    post("/register/reset", RegistrationResetController, :create)

    get("/register/reset/verify", RegistrationResetController, :edit)
    post("/register/reset/verify", RegistrationResetController, :update)

    resources("/sign-in", SessionController, only: [:new, :create, :delete], singleton: true)
  end

  scope "/", Web do
    pipe_through([:api, :api_authenticated])

    get("/users/me", UserController, :show)
  end

  scope "/", Web do
    pipe_through([:browser, :logged_in])

    resources("/characters", CharacterController, only: []) do
      post("/approve", CharacterController, :approve, as: :action)

      post("/deny", CharacterController, :deny, as: :action)
    end

    resources("/chat", ChatController, only: [:index])
  end

  scope "/oauth", Web.Oauth do
    pipe_through([:browser, :logged_in])

    get("/authorize", AuthorizationController, :new)

    resources("/authorizations", AuthorizationController, only: [:update], singleton: true)
  end

  scope "/oauth", Web.Oauth do
    pipe_through([:api])

    post("/token", TokenController, :create)
  end

  # Catch all last route
  scope "/", Web do
    pipe_through(:browser)

    resources("/", ProfileController, only: [:show])
  end

  if Mix.env() == :dev do
    forward("/emails/sent", Bamboo.SentEmailViewerPlug)
  end
end
