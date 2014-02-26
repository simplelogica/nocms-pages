require 'spec_helper'

describe NoCMS::Pages::Page do
  it_behaves_like "model with required attributes", :nocms_page, [:title, :body]
end
