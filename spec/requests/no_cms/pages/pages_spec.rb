require 'spec_helper'

describe NoCms::Pages::Page do

  context "when visiting page urls" do

    let(:cms_page) { create :nocms_page}

    context "if page exists" do

      before do
        visit cms_page.path
      end

      subject { page }

      it("should find the page") { expect(page.status_code).to eq 200 }

    end

    context "if page desn't exist" do

      it("should not find the page") { expect{visit "#{cms_page.path}-wrong"}.to raise_error(ActionController::RoutingError) }

    end

  end
end
