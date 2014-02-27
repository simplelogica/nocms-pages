# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nocms_page, class: NoCMS::Pages::Page do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
