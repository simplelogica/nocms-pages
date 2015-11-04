NoCms::Pages.configure do |config|

  # By default we use blocks to create the content of the page. If we just want a big textarea to insert the content we must set use_body to true
  config.use_body = true

  # By default we use all the layouts in the app/views/layouts from the app
  # config.page_layouts = ['application', ...]

end
