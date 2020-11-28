require "test_helper"

class NotifierMailer < ActionMailer::Base
  self.view_paths = File.expand_path("../views", __FILE__)

  layout "default"

  def inform_contact(recipient)
    @recipient = recipient

    mail(to: @recipient, from: "app@example.com") do |format|
      format.text
      format.html
    end
  end

  def invalid_template(recipient)
    @recipient = recipient

    mail(to: @recipient, from: "app@example.com") do |format|
      format.html
    end
  end
end

class NoLayoutMailer < ActionMailer::Base
  self.view_paths = File.expand_path("../views", __FILE__)

  layout nil

  def inform_contact(recipient)
    @recipient = recipient

    mail(to: @recipient, from: "app@example.com") do |format|
      format.mjml
    end
  end

  def with_owa(recipient)
    @recipient = recipient

    mail(to: @recipient, from: "app@example.com") do |format|
      format.mjml
    end
  end
end

class NotifierMailerTest < ActiveSupport::TestCase
  test "MJML layout based multipart email is generated correctly" do
    email = NotifierMailer.inform_contact("user@example.com")

    assert_equal "multipart/alternative", email.mime_type

    # To debug tests:
    # Mjml.logger.info email.mime_type
    # Mjml.logger.info email.to_s
    # Mjml.logger.info email.html_part.body

    refute email.html_part.body.match(%r{</?mj.+?>})
    assert email.html_part.body.match(/<body>/)
    assert email.html_part.body.match(/Hello, user@example.com!/)
    assert email.html_part.body.match(%r{<h2>We inform you about something</h2>})
    assert email.html_part.body.match(%r{<a href="https://www.example.com">this link</a>})
    assert email.html_part.body.match(/tracking-code-123/)

    assert email.text_part.body.match(/We inform you about something/)
    assert email.text_part.body.match(%r{Please visit https://www.example.com})
  end

  test "Invalid template raises error with validation level strict" do
    with_settings(validation_level: 'strict') do
      email = NotifierMailer.invalid_template("user@example.com")
      assert_raise(ActionView::Template::Error) { email.html_part.to_s }
    end
  end

  test "Invalid template gets compiled with validation level soft" do
    with_settings(validation_level: 'soft') do
      email = NotifierMailer.invalid_template("user@example.com")
      assert email.html_part.to_s.blank?
    end
  end
end

class NotifierMailerTest < ActiveSupport::TestCase
  test "old mjml-rails configuration style MJML template is rendered correctly" do
    email = NoLayoutMailer.inform_contact("user@example.com")

    assert_equal "text/html", email.mime_type

    refute email.body.match(%r{</?mj.+?>})
    assert email.body.match(/<body>/)
    assert email.body.match(/Welcome, user@example.com!/)
    assert email.body.match(%r{<h2>We inform you about something</h2>})
    assert email.body.match(%r{<a href="https://www.example.com">this link</a>})
    refute email.body.match(/tracking-code-123/)
  end

  test "old mjml-rails MJML template with owa is rendered correctly" do
    email = NoLayoutMailer.with_owa("user@example.com")

    assert_equal "text/html", email.mime_type

    refute email.body.match(%r{</?mj.+?>})
    assert email.body.match(/<body>/)
    assert email.body.match(/Welcome, user@example.com!/)
    assert email.body.match(%r{<h2>We inform you about something</h2>})
    assert email.body.match(%r{<a href="https://www.example.com">this link</a>})
    refute email.body.match(/tracking-code-123/)
  end
end
