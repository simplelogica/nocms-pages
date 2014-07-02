module NoCms
  module Pages
    module PagesHelper
      def render_block block, options = {}
        options[:cache_enabled] ||= block.cache_enabled

        block_template = "no_cms/pages/blocks/#{block.template}"

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
