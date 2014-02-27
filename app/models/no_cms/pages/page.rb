module NoCMS::Pages
  class Page < ActiveRecord::Base

    has_many :blocks, inverse_of: :page

    translates :title, :body

    validates :title, :body, presence: true

  end
end
