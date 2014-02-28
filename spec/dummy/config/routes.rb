Rails.application.routes.draw do

  mount NoCms::Pages::Engine => "/"
end
