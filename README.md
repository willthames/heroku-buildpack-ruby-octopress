Heroku buildpack: Octopress/Jekyll on Ruby
======================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Octopress, Jekyll, Ruby, Rack, and Rails apps. It uses [Bundler](http://gembundler.com) for dependency management.

See [my blog post](http://jasongarber.com/blog/2012/01/10/deploying-octopress-to-heroku-with-a-custom-buildpack/) for information on how to configure Octopress for use with Heroku.

Usage
-----

### Octopress or Jekyll

This buildpack should detect Jekyll sites and, if present, run the :generate rake task, which is specific to Octopress.

Octopress example usage:

    $ ls
    CHANGELOG.markdown README.markdown    config.rb          public
    Gemfile            Rakefile           config.ru          sass
    Gemfile.lock       _config.yml        plugins            source

    $ heroku create --stack cedar --buildpack git://github.com/jgarber/heroku-buildpack-ruby-octopress.git

    -----> Heroku receiving push
    -----> Fetching custom buildpack... done
    -----> Octopress app detected
    -----> Installing dependencies using Bundler version 1.1.rc.3
           Running: bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
           Using rake (0.9.2)
           Using RedCloth (4.2.8)
           Using posix-spawn (0.3.6)
           Using albino (1.3.3)
           Using chunky_png (1.2.1)
           Using fast-stemmer (1.0.0)
           Using classifier (1.3.3)
           Using coffee-script-source (1.1.3)
           Using multi_json (1.0.4)
           Using execjs (1.2.11)
           Using coffee-script (2.2.0)
           Using fssm (0.2.7)
           Using sass (3.1.5)
           Using compass (0.11.5)
           Using daemons (1.1.4)
           Using directory_watcher (1.4.0)
           Using eventmachine (0.12.10)
           Using haml (3.1.2)
           Using kramdown (0.13.3)
           Using liquid (2.2.2)
           Using syntax (1.0.0)
           Using maruku (0.6.0)
           Using jekyll (0.11.0)
           Using rack (1.3.2)
           Using rdiscount (1.6.8)
           Using rubypants (0.2.0)
           Using tilt (1.3.2)
           Using sinatra (1.2.6)
           Using stringex (1.3.0)
           Using thin (1.2.7)
           Using bundler (1.1.rc.3)
           Your bundle is complete! It was installed into ./vendor/bundle
           Cleaning up the bundler cache.
    -----> Building Jekyll site
           ## Generating Site with Jekyll
           directory source/stylesheets/
              create source/stylesheets/screen.css
           Configuration from /tmp/build_3hjas2h9zl31n/_config.yml
           Building site: source -> public
           Successfully generated site: source -> public
    -----> Discovering process types
           Procfile declares types     -> (none)
           Default types for Octopress -> console, rake, web

The buildpack will detect your app as Jekyll if it has a `_config.yml` file and Octopress if your Rakefile contains the `:generate` task, which generates the Jekyll site and also compiles the CSS.

### Ruby

Example Usage:

    $ ls
    Gemfile Gemfile.lock

    $ heroku create --stack cedar --buildpack http://github.com/heroku/heroku-buildpack-ruby.git

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> Ruby app detected
    -----> Installing dependencies using Bundler version 1.1.rc
           Running: bundle install --without development:test --path vendor/bundle --deployment
           Fetching gem metadata from http://rubygems.org/..
           Installing rack (1.3.5)
           Using bundler (1.1.rc)
           Your bundle is complete! It was installed into ./vendor/bundle
           Cleaning up the bundler cache.
    -----> Discovering process types
           Procfile declares types -> (none)
           Default types for Ruby  -> console, rake

The buildpack will detect your app as Ruby if it has a `Gemfile` and `Gemfile.lock` files in the root directory. It will then proceed to run `bundle install` after setting up the appropriate environment for [ruby](http://ruby-lang.org) and [Bundler](http://gembundler.com).

#### Bundler

For non-windows `Gemfile.lock` files, the `--deployment` flag will be used. In the case of windows, the Gemfile.lock will be deleted and Bundler will do a full resolve so native gems are handled properly. The `vendor/bundle` directory is cached between builds to allow for faster `bundle install` times. `bundle clean` is used to ensure no stale gems are stored between builds.

### Rails 2

Example Usage:

    $ ls
    app  config  db  doc  Gemfile  Gemfile.lock  lib  log  public  Rakefile  README  script  test  tmp  vendor

    $ ls config/environment.rb
    config/environment.rb

    $ heroku create --stack cedar --buildpack http://github.com/heroku/heroku-buildpack-ruby.git

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Ruby/Rails app detected
    -----> Installing dependencies using Bundler version 1.1.rc
    ...
    -----> Writing config/database.yml to read from DATABASE_URL
    -----> Rails plugin injection
           Injecting rails_log_stdout
    -----> Discovering process types
           Procfile declares types      -> (none)
           Default types for Ruby/Rails -> console, rake, web, worker

The buildpack will detect your app as a Rails 2 app if it has a `environment.rb` file in the `config`  directory.

#### Rails Log STDOUT
  A [rails_log_stdout](http://github.com/ddollar/rails_log_stdout) is installed by default so Rails' logger will log to STDOUT and picked up by Heroku's [logplex](http://github.com/heroku/logplex).

#### Auto Injecting Plugins

Any vendored plugin can be stopped from being installed by creating the directory it's installed to in the slug. For instance, to prevent rails_log_stdout plugin from being injected, add `vendor/plugins/rails_log_stdout/.gitkeep` to your git repo.

### Rails 3

Example Usage:

    $ ls
    app  config  config.ru  db  doc  Gemfile  Gemfile.lock  lib  log  Procfile  public  Rakefile  README  script  tmp  vendor

    $ ls config/application.rb
    config/application.rb

    $ heroku create --stack cedar --buildpack http://github.com/heroku/heroku-buildpack-ruby.git

    $ git push heroku master
    -----> Heroku receiving push
    -----> Ruby/Rails app detected
    -----> Installing dependencies using Bundler version 1.1.rc
           Running: bundle install --without development:test --path vendor/bundle --deployment
           ...
    -----> Writing config/database.yml to read from DATABASE_URL
    -----> Preparing app for Rails asset pipeline
           Running: rake assets:precompile
    -----> Rails plugin injection
           Injecting rails_log_stdout
           Injecting rails3_serve_static_assets
    -----> Discovering process types
           Procfile declares types      -> web
           Default types for Ruby/Rails -> console, rake, worker

The buildpack will detect your apps as a Rails 3 app if it has an `application.rb` file in the `config` directory.

#### Assets

To enable static assets being served on the dyno, [rails3_serve_static_assets](http://github.com/pedro/rails3_serve_static_assets) is installed by default. If the [execjs gem](http://github.com/sstephenson/execjs) is detected then [node.js](http://github.com/joyent/node) will be vendored. The `assets:precompile` rake task will get run if no `public/manifest.yml` is detected.  See [this article](http://devcenter.heroku.com/articles/rails31_heroku_cedar) on how rails 3.1 works on cedar.

Hacking
-------

To use this buildpack, fork it on Github.  Push up changes to your fork, then create a test app with `--buildpack <your-github-url>` and push to it.

To change the vendored binaries for Bundler, [Node.js](http://github.com/joyent/node), and rails plugins, use the rake tasks provided by the `Rakefile`. You'll need an S3-enabled AWS account and a bucket to store your binaries in as well as the [vulcan](http://github.com/ddollar/vulcan) gem to build the binaries on heroku.

For example, you can change the vendored version of Bundler to 1.1.rc.

First you'll need to build a Heroku-compatible version of Node.js:

    $ export AWS_ID=xxx AWS_SECRET=yyy S3_BUCKET=zzz
    $ s3 create $S3_BUCKET
    $ rake gem:install[bundler,1.1.rc]

Open `lib/language_pack/ruby.rb` in your editor, and change the following line:

    BUNDLER_VERSION = "1.1.rc"

Open `lib/language_pack/base.rb` in your editor, and change the following line:

    VENDOR_URL = "https://s3.amazonaws.com/zzz"

Commit and push the changes to your buildpack to your Github fork, then push your sample app to Heroku to test.  You should see:

    -----> Installing dependencies using Bundler version 1.1.rc

NOTE: You'll need to vendor the plugins, node, Bundler, and libyaml by running the rake tasks for the buildpack to work properly.

Flow
----

Here's the basic flow of how the buildpack works:

Ruby (Gemfile and Gemfile.lock is detected)

* runs Bundler
* installs binaries
  * installs node if the gem execjs is detected
* runs `rake assets:precompile` if the rake task is detected

Rack (config.ru is detected)

* everything from Ruby
* sets RACK_ENV=production

Rails 2 (config/environment.rb is detected)

* everything from Rack
* sets RAILS_ENV=production
* install rails 2 plugins
  * [rails_log_stdout](http://github.com/ddollar/rails_log_stdout)

Rails 3 (config/application.rb is detected)

* everything from Rails 2
* install rails 3 plugins
  * [rails3_server_static_assets](https://github.com/pedro/rails3_serve_static_assets)

