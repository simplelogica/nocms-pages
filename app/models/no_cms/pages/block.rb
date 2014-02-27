module NoCMS::Pages
  class Block < ActiveRecord::Base

    belongs_to :page

    translates :layout

    validates :page, :layout, presence: true

  end
end
