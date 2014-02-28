require 'spec_helper'

describe NoCms::Pages::Page do

  context "when visiting page urls" do

    let(:cms_page) { create :nocms_page }
    let(:block_default_layout) { create :nocms_block, layout: 'default', page: cms_page, title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph }
    let(:block_3_columns_layout) { create :nocms_block, layout: 'title-3_columns', page: cms_page, title: Faker::Lorem.sentence, column_1: Faker::Lorem.paragraph, column_2: Faker::Lorem.paragraph, column_3: Faker::Lorem.paragraph }
    let(:page_blocks) { [block_default_layout , block_3_columns_layout] }

    context "if page exists" do

      before do
        NoCms::Pages.configure do |config|
          config.block_layouts = {
            'default' => {
              template: 'default',
              fields: {
                title: :string,
                body: :text
              }
            },
            'title-3_columns' => {
              template: 'title-long_text',
              fields: {
                title: :string,
                column_1: :text,
                column_2: :text,
                column_3: :text
              }
            }
          }

        end

        page_blocks

        visit cms_page.path
      end

      subject { page }

      it("should find the page") { expect(page.status_code).to eq 200 }
      it("should display page's title") { expect(page).to have_selector('h1', text: cms_page.title) }
      it("should display page's body") { expect(page).to have_selector('p', text: cms_page.body) }

      it("should display default layout block") do
        expect(page).to have_selector('p.title', text: block_default_layout.title)
        expect(page).to have_selector('p.body', text: block_default_layout.body)
      end

      it("should display 3 columns layout block") do
        expect(page).to have_selector('p.title', text: block_3_columns_layout.title)
        expect(page).to have_selector('p.column_1', text: block_3_columns_layout.column_1)
        expect(page).to have_selector('p.column_2', text: block_3_columns_layout.column_2)
        expect(page).to have_selector('p.column_3', text: block_3_columns_layout.column_3)
      end

    end

    context "if page desn't exist" do

      it("should not find the page") { expect{visit "#{cms_page.path}-wrong"}.to raise_error(ActionController::RoutingError) }

    end

  end
end
