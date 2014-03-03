class AddTemplateToNoCmsPage < ActiveRecord::Migration
  def change
    add_column :no_cms_pages_pages, :template, :string
  end
end
