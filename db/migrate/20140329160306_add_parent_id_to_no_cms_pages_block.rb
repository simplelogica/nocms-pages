class AddParentIdToNoCmsPagesBlock < ActiveRecord::Migration
  def change
    add_reference :no_cms_pages_blocks, :parent, index: true
  end
end
