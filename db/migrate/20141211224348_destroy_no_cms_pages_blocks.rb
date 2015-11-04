class DestroyNoCmsPagesBlocks < ActiveRecord::Migration
  def change

    if NoCms::Blocks::Block.table_exists?
      begin
        Rake::Task["no_cms:pages:migrate_blocks"].invoke
      rescue
        Rake::Task["app:no_cms:pages:migrate_blocks"].invoke
      end
    end

    drop_table :no_cms_pages_blocks

  end
end
