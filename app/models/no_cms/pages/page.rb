module NoCms::Pages
  class Page < ActiveRecord::Base

    include Concerns::TranslationScopes

    scope :drafts, ->() { where_with_locale(draft: true) }
    scope :no_drafts, ->() { where_with_locale(draft: false) }

    def self.home
      where_with_locale(slug: '').where(parent_id: nil).first
    end

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
      self.slug = title.parameterize if slug.nil? && !title.nil? # If there's no slug then we create it
      self.slug = title.parameterize if slug.blank? && !parent.nil? # If slug is blank and this page has a parent then we recreate it
      self.slug = title.parameterize if slug.blank? && Page.home && (Page.home != self) # If slug is blank and there's already a home (and it's another page) then we recreate it
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
