# NoCMS Pages

## What's this?

This is a Rails engine with a basic functionality of content pages made of customizable blocks. It's not attached to any particular CMS so you can use it freely within your Rails application without too much dependencies.

## How do I install it?

Right now there's no proper gem, although we have a couple of projects making extensive use of it.

To install it just put the repo in your Gemfile:

```ruby
gem "nocms-pages", git: 'git@github.com:simplelogica/nocms-pages.git'
```

Then you update the bundle:

```ruby
bundle install
```

And then import all the migrations:

```
rake no_cms_pages:install:migrations
```

And run the initializer:

```
rails g nocms:pages
```

Optionally, you may be interested on adding this engine routes to your app. You just have to mount the engine in your routes.rb file [just like any other standard engine][http://edgeguides.rubyonrails.org/engines.html#highlighter_95949].

```ruby
  mount NoCms::Pages::Engine => "/"
```

If you prefer not to mount the whole engine just take a look at the config/routes.rb file of the engine to see which controllers and actions are used.

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
NoCms::Pages.configure do |config|

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
  }

end
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

### Block Cache

Since blocks are independent units of content within a page, the standard Rails fragment cache seemed to fit well with them. That's why the `render_block` helper decides wether Rails cache should be used for rendering an individual block.

Cache for the blocks are configured at 3 levels:

1. The page may have its `cache_enabled` attribute set to false. If this is the case then the cache will be disabled without any further check. This way, a page can be marked as "not cacheable" (e.g. in an admin interface) and no other setting can overwrite it.

2. The `render_block` helper may be called with a `cache_enabled` option set to true or false. This option will enable/disable the cache. This allow us to render a block without using the cache (maybe on a preview action).

  ```ruby
    render_block block, cache: false
  ```

3. In the blocks configuration we can enable/disable the cache for all the blocks of a kind. We just have to add the cache_enabled setting.

  ```ruby
  NoCms::Pages.configure do |config|

    config.block_layouts = {
      'default' => {
        template: 'default',
        fields: {
          title: :string,
          body: :text
        },
        cache_enabled: false
      }
    }
  end
  ```

4. In the blocks configuration file we can enable/disable cache for all the blocks that doesn't have a cache_enabled setting. This configuration will be stored at `NoCms::Pages.cache_enabled`

  ```ruby
  NoCms::Pages.configure do |config|

    config.cache_enabled = true

  end
  ```

As a summary:

```ruby

  b = NoCms::Pages::Block.new layout: 'default', title: 'Foo', description: 'Bar', page: page
  b.page.cache_enabled # => true
  NoCms::Pages.cache_enabled # => true
  b.cache_enabled # => false, since the block configuration sets it to false
  render_block b # => This won't use fragment cache since this block layout have cache disabled

  b = NoCms::Pages::Block.new layout: 'title-3_columns', title: 'Foo', description: 'Bar', page: page
  b.page.cache_enabled # => true
  NoCms::Pages.cache_enabled # => true
  b.cache_enabled # => true, since this block configuration doesn't override NoCms::Pages.cache_enabled
  render_block b # => This will use fragment cache since, by default, it's enabled for all blocks

  render_block b, cache_enabled: false # => This won't use fragment cache as the option in the helper overrides the block configuration

  page.cache_enabled = false
  render_block b # => This won't use fragment cache sincs it's been disabled for the page and blocks configuration has been override
  render_block b, cache_enabled: true # => This won't use fragment cache even when saying the helper to do it. Power for the users!

```

## Where is the admin interface?

`nocms-pages` is a gem with the minimum dependencies and that includes the admin interface.

Main idea is that this gem can be used in a project with a Rails Admin, an Active Admin or a home made admin. Of course, it can be tricky to embed this dynamic kind of blocks in a pre-built admin, but we think that freedom must be given to the developers.

As soon as we started using this gem we started our own admin interface, which is contained in another gem [nocms-admin-pages](https://github.com/simplelogica/nocms-admin-pages) and you can use it.

If your project already has another standard admin interface such as Rails Admin and you manage to embed nocms-pages on it, please, let us know and we will make a note here giving you full credit for the development :)
