class CreateNoCmsPages < ActiveRecord::Migration
  def change
    create_table :no_cms_pages_pages do |t|
      t.timestamps
    end

    create_table :no_cms_pages_page_translations do |t|
      t.string :title
      t.string :body
    end
  end
end
