# Codeword

A simple gem to more elegantly place a staging server or other in-progress Ruby on Rails application behind a basic codeword. It’s easy to implement, share with clients/collaborators, and more beautiful than the typical password-protection sheet.

![Screenshot](./screenshot.png)

## Installation

1. Add this line to your application’s Gemfile:

```ruby
gem 'codeword'
```

2. Define a codeword (see Usage below).

3. Mount the engine in your application’s routes file (usually first, for best results):

```ruby
# config/routes.rb
mount Codeword::Engine, at: '/codeword'
```

4. Include the `Codeword::Authentication` module in your application_controller.rb file and check for codeword:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Codeword::Authentication

  before_action :require_codeword!
end
```

5. Skip the check for codeword in the controller(s) you would like to allow:

```ruby
class APIController < ApplicationController
  skip_before_action :require_codeword!
end
```

## Usage

To set a codeword, define CODEWORD in your environments/your_environment.rb file like so:

```ruby
ENV['CODEWORD'] = 'secret'
```

If you think you might need a hint:

```ruby
ENV['CODEWORD_HINT'] = 'Something that you do not tell everyone.'
```

You can add your codeword via Rails credentials in your `credentials.yml.enc` file (`$ bin/rails credentials:edit`):

```yml
codeword:
  codeword: "love"
  hint: "Pepé Le Pew"
  cookie_lifetime_in_weeks: 4
```

**Codewords are not case-sensitive, by design. Keep it simple.**

## Advanced Usage

### Use Codeword around a specific controller:

1. Follow the installation instructions above.

2. In your application_controller.rb file, add:

```ruby
skip_before_action :require_codeword!, raise: false
```

4. In the controller(s) you would like to restrict:

```ruby
before_action :require_codeword!
```

### Link it with no typing:

    http://somedomain.com/or_path/?codeword=love

The visitor is redirected and the cookie is set without them ever seeing the Codeword splash page.

(Codeword also makes a rudimentary attempt based on user agent to **block major search engine bots/crawlers** from following this link and indexing the site, just in case it ever gets out into the wild.)

### Set a custom lifetime for cookie

The cookie set by Codeword defaults to 5 years. If you want to set a shorter amount of time, you can specify a number of weeks:

```ruby
ENV['COOKIE_LIFETIME_IN_WEEKS'] = 4

cookie_lifetime_in_weeks: 4
```

### Design Customization

If you would like to change the content or design of the codeword page, you can create the directories `app/views/layouts/codeword` and `app/views/codeword/codeword` and populate them with the default content from [here](https://github.com/dankimio/codeword/tree/main/app/views), and then customize as desired.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Acknowledgements

Codeword is a fork of [lockup](https://github.com/interdiscipline/lockup).
