# This migration comes from no_cms_pages (originally 20140329160306)
class AddParentIdToNoCmsPagesBlock < ActiveRecord::Migration
  def change
    add_reference :no_cms_pages_blocks, :parent, index: true
  end
end
