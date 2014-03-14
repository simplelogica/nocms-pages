require 'spec_helper'

describe NoCms::Pages::Page do
  it_behaves_like "model with required attributes", :nocms_page, [:title, :body]
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_block, :blocks, :page
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_page, :children, :parent

  context "when saving" do

    let(:page) { create :nocms_page, title: testing_title}
    let(:testing_title) { "testing slug" }

    subject { page }

    it("should generate a slug") { expect(page.slug).to eq testing_title.parameterize }
    it("should generate a path") { expect(page.path).to eq "/#{page.slug}" }

  end

  context "when nesting" do

    let(:page) { create :nocms_page }
    let(:nested_page) { create :nocms_page, parent: page}

    subject { nested_page }

    it("should have a nested path") { expect(nested_page.path).to eq "/#{page.slug}/#{nested_page.slug}" }

  end

  context "regarding templates" do

    it "should detect templates from app folder" do
      expect(NoCms::Pages::Page.templates).to match_array ['test']
    end

  end

  context "when pages are marked as draft" do

    let(:no_draft_pages) { create_list :nocms_page, 2, draft: false }
    let(:draft_pages) { create_list :nocms_page, 2, draft: true }

    before { draft_pages && no_draft_pages }

    it("should distinguish between drafts and no drafts") do
      expect(NoCms::Pages::Page.drafts).to match_array draft_pages
      expect(NoCms::Pages::Page.no_drafts).to match_array no_draft_pages
    end
  end
end
