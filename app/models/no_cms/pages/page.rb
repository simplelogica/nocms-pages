module NoCMS::Pages
  class Page < ActiveRecord::Base

    has_many :blocks, inverse_of: :page

    translates :title, :body, :slug

    validates :title, :body, :slug, presence: true

    before_validation :set_slug

    def set_slug
      self.slug = title.parameterize if slug.blank? && !title.nil?
    end

  end
end
