require 'spec_helper'

describe NoCms::Pages::Block do
  it_behaves_like "model with required attributes", :nocms_block, [:layout, :page]

  context "when blocks have layouts" do

    context "with simple fields" do

      before do
        NoCms::Pages.configure do |config|
          config.block_layouts = {
            'title-long_text' => {
              template: 'title-long_text',
              fields: {
                title: :string,
                body: :text
              }
            }
          }
        end
      end

      let(:block_with_layout) { NoCms::Pages::Block.create attributes_for(:nocms_block).merge(layout: 'title-long_text', title: block_title) }
      let(:block_title) { Faker::Lorem.sentence }

      subject { block_with_layout }

      it("should respond to layout fields") do
        expect{subject.title}.to_not raise_error
        expect{subject.body}.to_not raise_error
      end

      it("should not respond to fields from other layouts") do
        expect{subject.no_title}.to raise_error
      end

      it("should save info in layout fields") do
        expect(subject.title).to eq block_title
      end

      it("should save nil fields") do
        expect(subject.body).to be_blank
      end

      context "when updating various fields" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }
        let(:block_body) { Faker::Lorem.paragraph }

        before do
          subject.update_attributes title: new_block_title, body: block_body
        end

        it("should save info in layout fields") do
          expect(subject.title).to eq new_block_title
          expect(subject.body).to eq block_body
        end

      end

      context "when updating just one field" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }

        before do
          subject.update_attribute :title, new_block_title
        end

        it("should save info in layout field") do
          expect(subject.title).to eq new_block_title
        end

      end

      context "when updating one field of the block through the page" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }
        let(:new_page_title) { "new page #{Faker::Lorem.sentence}" }

        before do
          subject.page.update_attributes! title: new_page_title, blocks_attributes: { "0" => { title: new_block_title, id: subject.id } }
        end

        it("should save info in layout field") do
          subject.reload
          expect(subject.page.title).to eq new_page_title
          expect(subject.title).to eq new_block_title
        end

      end


      context "when updating various fields of the block through the page" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }
        let(:new_block_body) { "new #{Faker::Lorem.paragraph}" }
        let(:new_page_title) { "new page #{Faker::Lorem.sentence}" }

        before do
          subject.page.update_attributes! title: new_page_title, blocks_attributes: { "0" => { title: new_block_title, body: new_block_body, id: subject.id } }
        end

        it("should save info in layout field") do
          subject.reload
          expect(subject.page.title).to eq new_page_title
          expect(subject.title).to eq new_block_title
          expect(subject.body).to eq new_block_body
        end

      end

    end

    context "with related models" do

      before do
        NoCms::Pages.configure do |config|
          config.block_layouts = {
            'logo-caption' => {
              template: 'logo_caption',
              fields: {
                caption: :string,
                logo: TestImage
              }
            }
          }
        end
      end

      let(:image_attributes) { attributes_for(:test_image) }

      let(:block_with_layout) { NoCms::Pages::Block.create attributes_for(:nocms_block).merge(
          layout: 'logo-caption',
          caption: Faker::Lorem.sentence,
          logo: image_attributes
        )
      }

      before { subject }
      subject { block_with_layout }

      it("should respond to layout fields") do
        expect{subject.caption}.to_not raise_error
        expect{subject.logo}.to_not raise_error
      end

      it("should return objects") do
        expect(subject.logo).to be_a(TestImage)
      end

      it("should return objects with the right value") do
        expect(subject.logo.name).to eq image_attributes[:name]
      end

      it("should save related objects") do
        expect(TestImage.first).to_not be_nil
      end

      context "when related objects are modified outside" do

        let(:logo) { TestImage.first }
        let(:new_testing_name) { "new testing name" }

        before do
          subject
          logo.update_attribute :name, new_testing_name
        end

        it("should get those modifications") do
          expect(subject.reload.logo.name).to eq new_testing_name
        end

        it("should not overwrite those modifications") do
          subject.save!
          expect(logo.reload.name).to eq new_testing_name
        end

      end

      context "when we update the related object" do

        let(:logo) { TestImage.first }
        let(:new_testing_name) { "new testing name" }
        before do
          subject.update_attributes logo: { name: new_testing_name }
        end

        it("should be modified in database") do
          expect(logo.name).to eq new_testing_name
        end

      end

    end

  end

  context "when asigning blocks to pages" do

    let(:page) { create :nocms_page }
    let(:block_1) { create :nocms_block, page: page }
    let(:block_2) { create :nocms_block, page: page }

    it "blocks positions should be correctly assigned" do
      expect(block_1.position).to eq 1
      expect(block_2.position).to eq 2
    end

    context "when having assigned a different position to a block" do

      let(:last_block) { create :nocms_block, page: page }

      before do
        block_1
        block_2.update_attribute :position, 10
      end

      it "new block should be the last one" do
        expect(last_block.position).to eq 11
      end

    end

  end

  context "when blocks are marked as draft" do

    let(:no_draft_blocks) { create_list :nocms_block, 2, draft: false }
    let(:draft_blocks) { create_list :nocms_block, 2, draft: true }

    before { draft_blocks && no_draft_blocks }

    it("should distinguish between drafts and no drafts") do
      expect(NoCms::Pages::Block.drafts).to match_array draft_blocks
      expect(NoCms::Pages::Block.no_drafts).to match_array no_draft_blocks
    end
  end
end
