module NoCms
  module Pages
    class ApplicationController < ::ApplicationController
      helper NoCms::Blocks::BlocksHelper
    end
  end
end
