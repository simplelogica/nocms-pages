class CreateTestImages < ActiveRecord::Migration
  def change
    create_table :test_images do |t|
      t.string :image
      t.timestamps
    end
  end
end
