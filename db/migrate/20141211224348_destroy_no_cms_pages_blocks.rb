class DestroyNoCmsPagesBlocks < ActiveRecord::Migration
  def change

    if !defined?(NoCms::Blocks::Block) || !NoCms::Blocks::Block.table_exists?
      raise Exception.new("Migration destroying no_cms_pages_blocks should only be run after creating NoCms::Blocks::Block table")
    end

    Rake::Task["no_cms:pages:migrate_blocks"].invoke
    drop_table :no_cms_pages_blocks
  end
end
