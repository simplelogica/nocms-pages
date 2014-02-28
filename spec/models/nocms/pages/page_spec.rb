require 'spec_helper'

describe NoCMS::Pages::Page do
  it_behaves_like "model with required attributes", :nocms_page, [:title, :body]
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_block, :blocks, :page

  context "when saving" do

    let(:page) { create :nocms_page, title: testing_title}
    let(:testing_title) { "testing slug" }

    subject { page }

    it("should generate a slug") { expect(page.slug).to eq testing_title.parameterize }

  end
end
