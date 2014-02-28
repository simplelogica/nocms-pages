require 'spec_helper'

describe NoCMS::Pages::Page do
  it_behaves_like "model with required attributes", :nocms_page, [:title, :body]
  it_behaves_like "model with has many relationship", :nocms_page, :nocms_block, :blocks, :page
end
