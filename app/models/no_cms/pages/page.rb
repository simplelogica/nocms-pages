module NoCMS::Pages
  class Page < ActiveRecord::Base

    validates :title, :body, presence: true

    translates :title, :body

  end
end
