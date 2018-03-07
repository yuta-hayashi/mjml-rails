# MJML-Rails

[![Build Status](https://api.travis-ci.org/sighmon/mjml-rails.svg?branch=master)](http://travis-ci.org/sighmon/mjml-rails) [![Gem Version](https://badge.fury.io/rb/mjml-rails.svg)](https://badge.fury.io/rb/mjml-rails)

**MJML-Rails** allows you to render HTML e-mails from an [MJML](https://mjml.io) template.

An example template might look like:

```erb
<!-- ./app/views/user_mailer/email.mjml -->
<mjml>
  <mj-body>
    <mj-container>
      <mj-section>
        <mj-column>
          <mj-text>Hello World</mj-text>
          <%= render :partial => 'info', :formats => [:html] %>
        </mj-column>
      </mj-section>
    </mj-container>
  </mj-body>
</mjml>
```

And the partial `_info.mjml`:

```erb
<!-- ./app/views/user_mailer/_info.mjml -->
<mj-text>This is <%= @user.username %></mj-text>
```

* Notice you can use ERb and partials inside the template.

Your `user_mailer.rb` might look like this::

```ruby
# ./app/mailers/user_mailer.rb
class UserMailer < ActionMailer::Base
  def user_signup_confirmation()
    mail(to: 'test@example.com', subject: 'test') do |format|
      format.text
      format.mjml
    end
  end
end
```

## Installation

Add it to your Gemfile.

```ruby
gem 'mjml-rails'
```

Run the following command to install it:

```console
bundle install
```

Install the MJML parser (optional -g to install it globally):

```console
npm install -g mjml@4.0.0-beta.1
```

Note that you'll need at least Node.js version 6 for MJML to function properly.

If you're using ```:haml``` or any other Rails template language, create an initializer to set it up:

```ruby
# config/initializers/mjml.rb
Mjml.setup do |config|
  config.template_language = :erb # :erb (default), :slim, :haml, or any other you are using
end
```

### MJML v3.x & v4.0.x support

Version 4.0.x of this gem brings support for MJML 4.0.x

Version 2.3.x and 2.4.x of this gem brings support for MJML 3.x

If you'd rather still stick with MJML 2.x then lock the mjml-rails gem:

```ruby
gem 'mjml-rails', '2.2.0'
```

### How to guides

[Hugo Giraudel](https://twitter.com/hugogiraudel) wrote a post on [using MJML in Rails](http://dev.edenspiekermann.com/2016/06/02/using-mjml-in-rails/).

## Using Email Layouts

Mailer:
```ruby
# mailers/foo_mailer.rb
class MyMailer < ActionMailer::Base
  layout "default"

  def mail_template(template_name, recipient, subject, **params)
    mail(
      to: recipient.email,
      from: ENV["MAILER_FROM"],
      subject: subject
    ) do |format|
      format.mjml { render template_name, locals: { recipient: recipient }.merge(params) }
    end
  end

  # this function is called to send the email
  def foo(item, user)
    mail_template(
      "foo_bar",
      user,
      "email subject",
      request: item
    )
  end
end
```

Email layout:
```html
<!-- views/layouts/default.mjml -->
<mjml>
	<mj-body>
		<mj-container>
			<%= yield %>
		</mj-container>
	</mj-body>
</mjml>
```

Email view:
```html
<!-- views/my_mailer/foo_bar.mjml.erb -->
<%= render partial: "to", formats: [:html], locals: { name: recipient.name } %>

<mj-section>
	<mj-column>
		<mj-text>
			Hello <%= recipient.name %>!
		</mj-text>
	</mj-column>
</mj-section>
```

Email partial:
```html
<!-- views/my_mailer/_to.mjml -->
<mj-section>
	<mj-column>
		<mj-text>
			<%= name %>,
		</mj-text>
	</mj-column>
</mj-section>
```

## Sending Devise user emails

If you use [Devise](https://github.com/plataformatec/devise) for user authentication and want to send user emails with MJML templates, here's how to override the [devise mailer](https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb):
```ruby
# app/mailers/devise_mailer.rb
class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    @token = token
    @resource = record
    # Custom logic to send the email with MJML
    mail(
      template_path: 'devise/mailer',
      from: "some@email.com",
      to: record.email,
      subject: "Custom subject"
    ) do |format|
      format.mjml
      format.text
    end
  end
end
```

Now tell devise to user your mailer in `config/initializers/devise.rb` by setting `config.mailer = 'DeviseMailer'` or whatever name you called yours.

And then your MJML template goes here: `app/views/devise/mailer/reset_password_instructions.mjml`

Devise also have [more instructions](https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer) if you need them.

## Deploying with Heroku

To deploy with [Heroku](https://heroku.com) you'll need to setup [multiple buildpacks](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app) so that Heroku first builds Node for MJML and then the Ruby environment for your app.

Once you've installed the [Heroku Toolbelt](https://toolbelt.heroku.com/) you can setup the buildpacks from the commandline:

`$ heroku buildpacks:set heroku/ruby`

And then add the Node buildpack to index 1 so it's run first:

`$ heroku buildpacks:add --index 1 heroku/nodejs`

Check that's all setup by running:

`$ heroku buildpacks`

Next you'll need to setup a `package.json` file in the root, something like this:

```json
{
  "name": "your-site",
  "version": "1.0.0",
  "description": "Now with MJML email templates!",
  "main": "index.js",
  "directories": {
    "doc": "doc",
    "test": "test"
  },
  "dependencies": {
    "mjml": "^4.0.0-beta.1",
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/your-repo/your-site.git"
  },
  "keywords": [
    "mailer"
  ],
  "author": "Your Name",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/sighmon/mjml-rails/issues"
  },
  "homepage": "https://github.com/sighmon/mjml-rails"
}
```

Then `$ git push heroku master` and it should Just WorkTM.

## Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as possible to help us fixing the possible bug. We also encourage you to help even more by forking and sending us a pull request.

[github.com/sighmon/mjml-rails/issues](https://github.com/sighmon/mjml-rails/issues)

## Maintainers

* Simon Loffler [github.com/sighmon](https://github.com/sighmon)
* Steven Pickles [github.com/thatpixguy](https://github.com/thatpixguy)

## License

MIT License. Copyright 2016 Simon Loffler. [sighmon.com](http://sighmon.com)

Lovingly built on [github.com/plataformatec/markerb](https://github.com/plataformatec/markerb)
