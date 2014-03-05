module NoCms::Pages
  class Page < ActiveRecord::Base

    acts_as_nested_set

    has_many :blocks, inverse_of: :page, class_name: 'NoCms::Pages::Block'
    accepts_nested_attributes_for :blocks

    translates :title, :body, :slug, :path

    validates :title, :body, :slug, presence: true

    before_validation :set_slug_and_path
    after_move :rebuild_path

    def set_slug_and_path
      self.slug = title.parameterize if slug.blank? && !title.nil?
      self.rebuild_path if path.blank?
    end

    def rebuild_path
      self.update_attribute :path, "#{ancestors.map(&:path).join}/#{slug}"
    end

    def self.templates
      Dir[Rails.root.join('app', 'views', 'no_cms', 'pages', 'pages', '*.html.erb').to_s]. # We get all page templates
        map { |f| File.basename(f, '.html.erb') }.uniq.sort # And get their names
    end

  end
end
