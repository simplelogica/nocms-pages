Rails.application.routes.draw do

  mount NoCMS::Pages::Engine => "/pages"
end
