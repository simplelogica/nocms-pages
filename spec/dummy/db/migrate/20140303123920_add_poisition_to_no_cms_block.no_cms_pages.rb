# This migration comes from no_cms_pages (originally 20140303123845)
class AddPoisitionToNoCmsBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_blocks, :position, :integer
  end
end
