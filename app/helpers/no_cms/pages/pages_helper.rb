module NoCms
  module Pages
    module PagesHelper
      def render_page_block page, block, options = {}
        # If cache is disabled for all pages or is disabled for this block
        # then we disable no matter what the block or the options passed have to say about it.
        # This way, the user in the back has the last word about disabling cache and the NoCms::Pages engine
        # control the cache over the NoCms::Block engine
        options[:cache_enabled] = false if !NoCms::Pages.cache_enabled || !page.cache_enabled
        render_block block, options
      end
    end
  end
end
