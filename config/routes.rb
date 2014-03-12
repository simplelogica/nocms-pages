NoCms::Pages::Engine.routes.draw do

  get '*path', to: 'pages#show', constraints: NoCms::Pages::Routes::PageFoundConstraint
  root to: 'pages#show', path:''

end
