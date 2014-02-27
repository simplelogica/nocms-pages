# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nocms_block, class: NoCMS::Pages::Block do
    layout { Faker::Lorem.word }
    page { FactoryGirl.create :nocms_page }
  end
end
