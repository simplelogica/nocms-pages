require 'spec_helper'

describe NoCMS::Pages::Block do
  it_behaves_like "model with required attributes", :nocms_block, [:layout, :page]

  context "when blocks have layouts" do

    context "with simple fields" do

      before do
        NoCMS::Pages.configure do |config|
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

      let(:block_with_layout) { build :nocms_block, layout: 'title-long_text', title: block_title }
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

    end
  end
end
