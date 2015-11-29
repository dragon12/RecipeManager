ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
#require Rails.root.join('../factories.rb')
require 'rails/test_help'
require 'minitest/spec'
require "minitest/reporters"
require 'capybara/rails'
require "active_support"
Minitest::Reporters.use!
Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
    Capybara::Webkit.configure do |config|
      config.block_unknown_urls
    end

  setup do
    Capybara.current_driver = :webkit

    #page.driver.block_url("secure.gravatar.com")
    #page.driver.block_url("www.test.image.com")
  end
  
end

class ActionDispatch::IntegrationTest
  def html_document_with_capybara
    return html_document_without_capybara if response
    xml = page.response_headers['Content-Type'] =~ /\bxml\b/
    HTML::Document.new(page.body, false, xml)
  end
alias_method_chain :html_document, :capybara
end


class ActiveSupport::TestCase
  set_fixture_class :ingredient_bases => IngredientBase
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  def capy_login_as_admin
    visit login_path
    fill_in('Email', :with => 'michael@example.com')
    fill_in('Password', :with => 'password')
    click_button('Log in')
  end
    
    
  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
