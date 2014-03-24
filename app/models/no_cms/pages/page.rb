module NoCms::Pages
  class Page < ActiveRecord::Base

    include Concerns::TranslationScopes

    scope :drafts, ->() { where_with_locale(draft: true) }
    scope :no_drafts, ->() { where_with_locale(draft: false) }

    acts_as_nested_set

    has_many :blocks, inverse_of: :page, class_name: 'NoCms::Pages::Block'
    accepts_nested_attributes_for :blocks, allow_destroy: true

    translates :title, :body, :slug, :path, :draft

    validates :title, :body, presence: true
    validates :slug, presence: { allow_blank: true }
    validates :path, presence: true, uniqueness: true

    before_validation :set_slug_and_path

    after_move :rebuild_path

    def set_slug_and_path
      self.slug = title.parameterize if slug.nil? && !title.nil?
      self.rebuild_path if path.nil? || attribute_changed?('slug')
    end

    def rebuild_path
      self.update_attribute :path, "#{ancestors.map(&:path).join}/#{slug}"
      descendants.each(&:rebuild_path)
    end

    def self.templates
      @templates ||= (Gem::Specification.all.map(&:gem_dir) + [Rails.root]). # We get all gems and rails paths
        map{ |d| Dir["#{d}/app/views/no_cms/pages/pages/*.html.erb"]}. # We get all page templates
        flatten.map { |f| File.basename(f, '.html.erb') }.uniq.sort # And get their names
    end

  end
end
