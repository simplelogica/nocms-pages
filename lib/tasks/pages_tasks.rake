namespace :no_cms do

  namespace :pages do

    desc 'Task for migrating blocks from NoCms::Pages::Block model to NoCms::Blocks::Block'
    task :migrate_blocks => :environment do
      NoCms::Pages::Page.all.each {|p| p.blocks.clear }
      root_blocks = NoCms::Pages::Deprecated::Block.dump
      root_blocks.each do |root_block|
        import_block root_block
      end
    end

    def import_block block
      return if block[:page].nil?

      # Due to globalize we have to send the default translation via the object attributes
      # instead of using the translation_attributes
      default_translation = block[:translations][I18n.locale]
      other_translations = block[:translations].reject{|locale, _| locale == I18n.locale }

      new_block = block[:page].blocks.build position: block[:position],
        translations_attributes: other_translations.map {|locale, translation|
          {
            locale: locale,
            layout: translation[:layout],
            draft: translation[:draft],
            fields_info: translation[:fields_info].to_hash
          }
        },
        layout: default_translation[:layout],
        draft: default_translation[:draft],
        fields_info: default_translation[:fields_info].to_hash

      new_block.translations.each(&:save!)

      new_block.children = block[:children].map{|b| import_block b}
      new_block.save!

      block[:page].blocks << new_block
      new_block
    end

  end

end
