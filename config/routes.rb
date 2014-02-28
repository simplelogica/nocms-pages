NoCms::Pages::Engine.routes.draw do

  get '/*path', to: 'pages#show'

end
