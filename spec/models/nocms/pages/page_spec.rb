require 'spec_helper'

describe NoCms::Pages::Page do
  it_behaves_like "model with required attributes", :nocms_page, [:title, :body]
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_block, :blocks, :page
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_page, :children, :parent

  context "when creating" do

    let(:page) { create :nocms_page, title: testing_title}
    let(:testing_title) { "testing slug" }

    subject { page }

    it("should generate a slug") { expect(page.slug).to eq testing_title.parameterize }
    it("should generate a path") { expect(page.path).to eq "/#{page.slug}" }

  end

  context "when updating" do

    let(:page) { create :nocms_page}
    let(:updated_slug) { "updated-slug" }

    before {
      page.update_attributes slug: updated_slug
    }

    subject { page }

    it("should rebuild the path") { expect(page.path).to eq "/#{updated_slug}" }

  end

  context "when nesting" do

    let(:page) { create :nocms_page }
    let(:nested_page) { create :nocms_page, parent: page}

    subject { nested_page }

    it("should have a nested path") { expect(nested_page.path).to eq "/#{page.slug}/#{nested_page.slug}" }

    context "when updating the parent" do

      let(:updated_slug) { "updated-slug" }

      before {
        page.update_attributes slug: updated_slug
      }

      subject { page }

      it("should rebuild the path") { expect(nested_page.path).to eq "/#{updated_slug}/#{nested_page.slug}" }

    end

  end

  context "when duplicating a path" do

    let(:page) { create :nocms_page}
    let(:duplicated_page) { build :nocms_page, slug: page.slug}

    subject { duplicated_page }

    it("should not have a valid path") { expect(subject.errors_on(:path)).to_not be_blank }

  end

  context "when setting an empty slug and no parent" do

    let(:page) { create :nocms_page, slug: ''}

    subject { page }

    it("should be the home page") { expect(subject).to eq NoCms::Pages::Page.home }

    context "adding a new page with empty slug and no parent" do

      before do
        page
      end

      let(:another_home) { create :nocms_page, slug: ''}

      subject { another_home }

      it "should set a slug" do
        expect(another_home.slug).to eq another_home.title.parameterize
      end

    end
  end

  context "when setting an empty slug and a parent" do

    let(:page) { create :nocms_page, slug: '', parent: create(:nocms_page, slug: 'asdasdasd')}

    subject { page }

    it "should set a slug" do
      expect(page.slug).to eq page.title.parameterize
    end

  end

  context "regarding templates" do

    it "should detect templates from app folder" do
      expect(NoCms::Pages::Page.templates).to match_array ['show', 'test']
    end

  end

  context "regarding layouts" do

    it "should detect layouts from app folder" do
      expect(NoCms::Pages::Page.layouts).to match_array ['application', 'landing']
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
