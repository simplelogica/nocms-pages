module NoCms::Pages::Routes
  class PageFoundConstraint

    # A filter URL must NOT have a qualification as the first of its path filters
    def self.matches?(request)
      @page = NoCms::Pages::Page.no_drafts.where(path: "/#{request.params[:path]}").exists?
    end
  end
end
