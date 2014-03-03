require_dependency "no_cms/pages/application_controller"

module NoCms::Pages
  class PagesController < ApplicationController
    def show
      @page = Page.where(path: "/#{params[:path]}").first
      raise ActionController::RoutingError.new('Not Found') if @page.nil?
    end
  end
end
