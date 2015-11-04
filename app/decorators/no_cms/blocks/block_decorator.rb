NoCms::Blocks::Block.class_eval do

  after_create :set_default_position

  has_and_belongs_to_many :pages, class_name: 'NoCms::Pages::Page'

  def set_default_position
    self.update_attribute :position, (((pages.map{|p| p.blocks.pluck(:position)}).flatten.compact.max || 0) + 1) if self[:position].blank? && self.pages.exists?
  end

end

