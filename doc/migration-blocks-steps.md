These are the steps for the migration from NoCms::Pages::Block model to NoCms::Blocks::Block one

1. *Change render_block for render_page_block*: This way, the helper we will be able to use the configuration about cache inside the own page.

2. *Change all render that points to the no_cms/pages folder for the usual render_page_block*: If you have any `render partial: '...'` you should chante to the `render_page_block` helper, so you can benefit from the cache settings.

3. *Change block templates from no_cms/pages folder to no_cms/blocks*: `render_block` and `render_page_blocks` will search the templates inside the no_cms/blocks views folder.

4. If you want you can comment the `drop_table :no_cms_pages_blocks` inside the destroy_no_cms_pages_blocks migration. This way you won't delete that table and will always beable to recover the information.

5. *Run the migrations*: the destroy_no_cms_pages_blocks  migration will copy your information from the old blocks table to the new one and no information will be lost!
