class AddPoisitionToNoCmsBlock < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_blocks, :position, :integer
  end
end
