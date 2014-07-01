module NoCms
  module Pages
    module PagesHelper
      def render_block block
        render "no_cms/pages/blocks/#{block.template}", block: block
      end
    end
  end
end
