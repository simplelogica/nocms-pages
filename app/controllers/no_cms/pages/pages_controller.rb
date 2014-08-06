require_dependency "no_cms/pages/application_controller"

module NoCms::Pages
  class PagesController < ApplicationController
    def show
      @page = Page.no_drafts.where(path: "/#{params[:path]}").first
      raise ActionController::RoutingError.new('Not Found') if @page.nil?
      @blocks = @page.blocks.roots.no_drafts

      template = @page.template.blank? ? 'show' : @page.template
      layout = @page.layout.blank? ? 'application' : @page.layout

      render template, layout: layout
    end
  end
end
