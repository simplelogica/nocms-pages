module NoCms
  module Pages
    module PagesHelper
      def render_block block, options = {}
        # If cache is disabled for this block then we disable no matter what the block or the options passed have to say about it. This way, the user in the back has the last word about disabling cache
        options[:cache_enabled] = false unless block.page.cache_enabled
        # If we don't have any option about cache enabled then we ask the block
        options[:cache_enabled] = block.cache_enabled unless options.has_key :cache_enabled

        block_template = "no_cms/pages/blocks/#{block.template}"

        # And now decide if we use cache or not
        if options[:cache_enabled]
          Rails.cache.fetch "#{block_template}/#{block.id}/#{block.updated_at.to_i}" do
            render block_template, block: block
          end
        else
          render block_template, block: block
        end

      end
    end
  end
end
