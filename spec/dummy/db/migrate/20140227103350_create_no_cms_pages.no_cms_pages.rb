# This migration comes from no_cms_pages (originally 20140226123742)
class CreateNoCmsPages < ActiveRecord::Migration
  def change
    create_table :no_cms_pages_pages do |t|
      t.timestamps
    end

    create_table :no_cms_pages_page_translations do |t|
      t.belongs_to :no_cms_pages_page, index: true
      t.string :locale
      t.string :title
      t.string :body
    end
  end
end
