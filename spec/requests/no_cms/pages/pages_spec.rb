require 'spec_helper'

describe NoCms::Pages::Page do

  context "when visiting page urls" do

    let(:cms_page) { create :nocms_page }
    let(:image_attributes) { attributes_for(:test_image) }
    let(:block_default_layout) { create :nocms_block, layout: 'default', page: cms_page, title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph }
    let(:block_3_columns_layout) { create :nocms_block, layout: 'title-3_columns', page: cms_page, title: Faker::Lorem.sentence, column_1: Faker::Lorem.paragraph, column_2: Faker::Lorem.paragraph, column_3: Faker::Lorem.paragraph }
    let(:block_logo) { create :nocms_block, layout: 'logo-caption', page: cms_page, caption: Faker::Lorem.sentence, logo: image_attributes }
    let(:block_draft) { create :nocms_block, layout: 'default', page: cms_page, title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, draft: true }

    let(:page_blocks) { [block_default_layout , block_3_columns_layout, block_logo, block_draft] }

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
              template: 'title_3_columns',
              fields: {
                title: :string,
                column_1: :text,
                column_2: :text,
                column_3: :text
              }
            },
            'logo-caption' => {
              template: 'logo_caption',
              fields: {
                caption: :string,
                logo: TestImage
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
        expect(page).to have_selector('.title', text: block_default_layout.title)
        expect(page).to have_selector('.body', text: block_default_layout.body)
      end

      it("should display 3 columns layout block") do
        expect(page).to have_selector('h2', text: block_3_columns_layout.title)
        expect(page).to have_selector('.column_1', text: block_3_columns_layout.column_1)
        expect(page).to have_selector('.column_2', text: block_3_columns_layout.column_2)
        expect(page).to have_selector('.column_3', text: block_3_columns_layout.column_3)
      end

      it("should display logo layout block") do
        expect(page).to have_selector('.caption', text: block_logo.caption)
        expect(page).to have_selector("img[src='#{block_logo.logo.logo.url}']")
      end

      it("should display not draft block") do
        expect(page).to_not have_selector('.title', text: block_draft.title)
        expect(page).to_not have_selector('.body', text: block_draft.body)
      end

    end

    context "if page desn't exist" do

      it("should not find the page") { expect{visit "#{cms_page.path}-wrong"}.to raise_error(ActionController::RoutingError) }

    end

    context "with nested pages" do

      let(:nested_cms_page) { create :nocms_page, parent: cms_page }

      before { visit nested_cms_page.path }

      it("should find the page") { expect(page.status_code).to eq 200 }

    end

    context "with templates" do

      let(:cms_page) { create :nocms_page, template: 'test' }

      before { visit cms_page.path }

      it("should display page's title") { expect(page).to have_selector('.test-template', text: cms_page.title) }

    end

    context "if page is in draft" do

      let(:cms_page) { create :nocms_page, draft: true }

      it("should not find the page") { expect{visit "#{cms_page.path}"}.to raise_error(ActionController::RoutingError) }

    end

    context "when visiting home" do

      let(:cms_page) { create :nocms_page, slug: '' }

      before { visit cms_page.path }

      it("should display home's title") { expect(page).to have_selector('h1', text: cms_page.title) }

    end

  end


end
