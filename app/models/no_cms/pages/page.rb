module NoCms::Pages
  class Page < ActiveRecord::Base

    include NoCms::Pages::Concerns::TranslationScopes

    scope :drafts, ->() { where_with_locale(draft: true) }
    scope :no_drafts, ->() { where_with_locale(draft: false) }

    def self.home
      where_with_locale(slug: '').where(parent_id: nil).first
    end

    acts_as_nested_set

    has_and_belongs_to_many :blocks, class_name: "NoCms::Blocks::Block"
    accepts_nested_attributes_for :blocks, allow_destroy: true

    translates :title, :body, :slug, :path, :draft, :css_class, :css_id, :cache_enabled
    accepts_nested_attributes_for :translations

    validates :title, presence: true
    validates :body, presence: true if NoCms::Pages.use_body?
    validates :slug, presence: { allow_blank: true }
    validates :path, presence: true, uniqueness: true

    before_validation :set_slug_and_path

    after_move :rebuild_path

    def set_slug_and_path
      self.slug = title.parameterize if slug.nil? && !title.nil? # If there's no slug then we create it
      self.slug = title.parameterize if slug.blank? && !title.nil? && !parent.nil? # If slug is blank and this page has a parent then we recreate it
      self.slug = title.parameterize if slug.blank? &&  !title.nil? && Page.home && (Page.home != self) # If slug is blank and there's already a home (and it's another page) then we recreate it
      self.rebuild_path if path.nil? || attribute_changed?('slug')
    end

    def rebuild_path
      if self.persisted?
        self.update_attribute :path, "#{parent.path unless parent.nil?}/#{slug}"
        descendants.each(&:rebuild_path)
      else
        self.path = "#{parent.path unless parent.nil?}/#{slug}"
      end
    end

    def self.templates
      @templates ||= (Gem::Specification.all.map(&:gem_dir) + [Rails.root]). # We get all gems and rails paths
        map{ |d| Dir["#{d}/app/views/no_cms/pages/pages/*.html.erb"]}. # We get all page templates
        flatten.map { |f| File.basename(f, '.html.erb') }.uniq.sort # And get their names
    end

    def self.layouts
      return @layouts unless @layouts.blank?
      @layouts = NoCms::Pages::page_layouts if @layouts.blank?
      @layouts = Dir["#{Rails.root}/app/views/layouts/*.html.erb"]. # We get all the files in app/views/layouts
        map { |f| File.basename(f, '.html.erb') }. # Get the name without any extension
        reject {|l| l.starts_with? '_'}. # reject partials
        sort if @layouts.blank? # and sort
      @layouts
    end

  end
end
