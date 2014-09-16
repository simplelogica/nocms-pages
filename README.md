# NoCMS Pages

## What's this?

This is a Rails engine with a basic functionality of content pages made of customizable blocks. It's not attached to any particular CMS so you can use it freely within your Rails application without too much dependencies.

## How do I install it?

Right now there's no proper gem, although we have a couple of projects making extensive use of it.

To install it just put the repo in your Gemfile:

```ruby
gem "nocms-pages", git: 'git@github.com:simplelogica/nocms-pages.git'
```

And then import all the migrations:

```
rake no_cms_pages:install:migrations
```

And run the initializer:

```
rails g nocms:pages
```

## How does it works?

In NoCms you can customize the layout, templates and blocks a page is made of. Let's how to customize each one of them:

### Layouts

Pages are rendered through the pages controller in a standard Rails way, so all the available layouts four your application are available for your pages.

The attribute `layout` from the `NoCms::Pages::Page` model set the layout used for rendering. The default layout is `application`.

### Templates

The template is the `action` set to the render instruction in the pages controller. Because of that any view in the no_cms/pages/pages may be used as template.

```ruby
render action: template, layout: layout
```

This `template` is set from the template attribute, being `show` the default value.

### Blocks

Blocks are the unit of contents the pages are made of. They are thought to be independent and customizable modules that can be created, edited or removed on their own, without dependency of any other module.

#### Block layouts

In NoCMS Pages, block layouts define two main things:

1. What kind of information a block contains and other settings (i.e. cache settings).
2. How this information is displayed within the page.

Block settings are configured in the file `config/initializers/nocms/pages.rb`. Here we declare all the available layouts for a block.

The following code

```ruby
  config.block_layouts = {
    'default' => {
      template: 'default',
      fields: {
        title: :string,
        body: :text
      }
    },
    'title-3_columns' => {
      template: 'title_3_columns',
      fields: {
        title: :string,
        column_1: :text,
        column_2: :text,
        column_3: :text
      },
    },
    'logo-caption' => {
      template: 'logo_caption',
      fields: {
        caption: :string,
        logo: TestImage
      }
    }
```

declares 3 layouts ('default', 'title-3_columns' and 'logo-caption'). Each layout has a template and some declared fields. These fields will be available in the ruby object for that block. As an example, if `@block` is an instance of the NoCms::Pages::Block model which layout attribute is set to 'default' you will be able to do `@block.title`

```ruby
block = NoCms::Pages::Block.new
block.layout = 'default'

block.title = 'a title'
block.title # => 'a title'

block.column_1 = 'a column' # => NoMethodError
block.column_1 # => NoMethodError


block.layout = 'title-3_columns'

block.title # => 'a title'
block.column_1 = 'a column'
block.column_1 # => 'a column'
block.body # => NoMethodError

block.layout = 'logo_caption'
block.title # => NoMethodError
block.logo = { name: 'testing logo' } # Currently this is the way to assign objects
block.logo.name # => 'testing logo'
block.logo.class # => TestImage
block.logo = TestImage.new name: 'testing logo' # Error! Currently assigning the object is not allowed :(
```

#### Block templates

Blocks are rendered using the `render_block` helper which controls all the logic related with renderinf a block, including fragment cache control.

In the end a partial is rendered using the block as a local variable to obtain the information. This partial must be found at `no_cms/pages/blocks` views folder and have the name configured in the `template` setting of the block. This way, rendering a 'title-3_columns' would render the partial `/no_cms/pages/blocks/title_3_columns`.

This partial is a regular Rails partial (nothing special here). AS an example, this could be the content of our  `/no_cms/pages/blocks/title_3_columns.html.erb` partial:

```html
<div class='columns_block'>
  <h2 class="title"><%= block.title %></h2>
  <p class="column_1"><%= block.column_1 %></p>
  <p class="column_2"><%= block.column_2 %></p>
  <p class="column_3"><%= block.column_3 %></p>
</div>
```

As you can see, the partial has a block variable containing the block object you are rendering.

Since this is plain old rails you can do everything you can do with a partial (i.e. having a `/no_cms/pages/blocks/title_3_columns.en.html.erb` for the english version and a `/no_cms/pages/blocks/title_3_columns.es.html.erb` for the spanish one).
