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
end
