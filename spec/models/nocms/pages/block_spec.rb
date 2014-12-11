require 'spec_helper'

describe NoCms::Blocks::Block do

  context "when blocks have layouts" do

    context "with simple fields" do

      before do
        NoCms::Blocks.configure do |config|
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

      let(:block_with_layout) { NoCms::Blocks::Block.create attributes_for(:block).merge(layout: 'title-long_text', title: block_title) }
      let(:block_title) { Faker::Lorem.sentence }
      let(:page) { create :nocms_page }

      subject { block_with_layout }

      context "when updating one field of the block through the page" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }
        let(:new_page_title) { "new page #{Faker::Lorem.sentence}" }

        before do
          page.blocks << subject
          page.update_attributes! title: new_page_title, blocks_attributes: { "0" => { title: new_block_title, id: subject.id } }
        end

        it("should save info in layout field") do
          subject.reload
          expect(page.title).to eq new_page_title
          expect(subject.title).to eq new_block_title
        end

      end


      context "when updating various fields of the block through the page" do

        let(:new_block_title) { "new #{Faker::Lorem.sentence}" }
        let(:new_block_body) { "new #{Faker::Lorem.paragraph}" }
        let(:new_page_title) { "new page #{Faker::Lorem.sentence}" }

        before do
          page.blocks << subject
          page.update_attributes! title: new_page_title, blocks_attributes: { "0" => { title: new_block_title, body: new_block_body, id: subject.id } }
        end

        it("should save info in layout field") do
          subject.reload
          expect(page.title).to eq new_page_title
          expect(subject.title).to eq new_block_title
          expect(subject.body).to eq new_block_body
        end

      end

    end


  end
end
