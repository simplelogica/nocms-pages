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

In a previous gem version blocks were a model within the NoCms::Pages namespace, but now everything was moved to the [nocms-blocks](https://github.com/simplelogica/nocms-blocks) and in this repo there's only left a rake task for the migration.

### Block Cache

Blocks are rendered through the `render_page_block` helper instead of the `render_block` helper from `nocms-blocks`. This helper uses the `render_block` helper but add some extra cache levels:

1. The page may have its `cache_enabled` attribute set to false. If this is the case then the cache will be disabled without any further check. This way, a page can be marked as "not cacheable" (e.g. in an admin interface) and no other setting can overwrite it.

2. The `render_page_block` helper may be called with a `cache_enabled` option set to true or false. This option will enable/disable the cache. This allow us to render a block without using the cache (maybe on a preview action).

  ```ruby
    render_block block, cache: false
  ```

3. In the page configuration file we can enable/disable cache for all the blocks that doesn't have a cache_enabled setting. This configuration will be stored at `NoCms::Pages.cache_enabled`

  ```ruby
  NoCms::Pages.configure do |config|

    config.cache_enabled = true

  end
  ```

As a summary:

```ruby

  b = NoCms::Blocks::Block.new layout: 'default', title: 'Foo', description: 'Bar'
  page.blocks << b
  page.cache_enabled # => true
  NoCms::Pages.cache_enabled # => true
  b.cache_enabled # => false, since the block configuration sets it to false
  render_page_block b # => This won't use fragment cache since this block layout have cache disabled

  b = NoCms::Blocks::Block.new layout: 'title-3_columns', title: 'Foo', description: 'Bar'
  page.blocks << b
  page.cache_enabled # => true
  NoCms::Pages.cache_enabled # => true
  b.cache_enabled # => true, since this block configuration doesn't override NoCms::Pages.cache_enabled
  render_page_block b # => This will use fragment cache since, by default, it's enabled for all blocks

  render_page_block b, cache_enabled: false # => This won't use fragment cache as the option in the helper overrides the block configuration

  page.cache_enabled = false
  render_page_block b # => This won't use fragment cache sincs it's been disabled for the page and blocks configuration has been override
  render_page_block b, cache_enabled: true # => This won't use fragment cache even when saying the helper to do it. Power for the users!

```

## Where is the admin interface?

`nocms-pages` is a gem with the minimum dependencies and that includes the admin interface.

Main idea is that this gem can be used in a project with a Rails Admin, an Active Admin or a home made admin. Of course, it can be tricky to embed this dynamic kind of blocks in a pre-built admin, but we think that freedom must be given to the developers.

As soon as we started using this gem we started our own admin interface, which is contained in another gem [nocms-admin-pages](https://github.com/simplelogica/nocms-admin-pages) and you can use it.

If your project already has another standard admin interface such as Rails Admin and you manage to embed nocms-pages on it, please, let us know and we will make a note here giving you full credit for the development :)
