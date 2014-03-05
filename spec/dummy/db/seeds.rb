NoCms::Pages::Page.destroy_all

NoCms::Pages::Page.create(
  title: Faker::Lorem.sentence,
  body: Faker::Lorem.paragraph,
  blocks_attributes: [
    {
      layout: 'default',
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph
    },
    {
      layout: 'title-3_columns',
      title: Faker::Lorem.sentence,
      column_1: Faker::Lorem.paragraph,
      column_2: Faker::Lorem.paragraph,
      column_3: Faker::Lorem.paragraph
    },
    {
      layout: 'logo-caption',
      caption: Faker::Lorem.sentence,
      logo: {
        name: Faker::Lorem.sentence,
        logo: File.open(Rails.root + '../fixtures/images/logo.png')
      }
    },

  ]
)

puts "created page, visit: #{NoCms::Pages::Page.last.path}"

NoCms::Pages::Page.first.children.create(
  title: Faker::Lorem.sentence,
  body: Faker::Lorem.paragraph,
  blocks_attributes: [
    {
      layout: 'title-3_columns',
      title: Faker::Lorem.sentence,
      column_1: Faker::Lorem.paragraph,
      column_2: Faker::Lorem.paragraph,
      column_3: Faker::Lorem.paragraph
    },
    {
      layout: 'logo-caption',
      caption: Faker::Lorem.sentence,
      logo: {
        name: Faker::Lorem.sentence,
        logo: File.open(Rails.root + '../fixtures/images/logo.png')
      }
    },
    {
      layout: 'title-3_columns',
      title: Faker::Lorem.sentence,
      column_1: Faker::Lorem.paragraph,
      column_2: Faker::Lorem.paragraph,
      column_3: Faker::Lorem.paragraph
    },
  ]
)

puts "created nested page, visit: #{NoCms::Pages::Page.last.path}"
