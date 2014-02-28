# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nocms_block, class: NoCms::Pages::Block do
    layout { 'default' }
    page { FactoryGirl.create :nocms_page }
  end
end
