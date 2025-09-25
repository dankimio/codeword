require 'test_helper'

class AccessRestrictedTest < ActionDispatch::IntegrationTest
  include CodewordTestHelper
  include UserAgentHelper

  def enter_code_word(code_word)
    fill_in 'Code word', with: code_word
    click_on 'Go'
  end

  setup do
    reset_user_agent
  end

  test 'without a configured code word displays the requested page' do
    ENV.delete('CODEWORD')
    reset_codeword_configuration_cache!

    visit '/posts'
    assert_current_path('/posts')
    assert_text 'Title One'
    assert_text 'Title Two'
  end

  test 'with a configured code word redirects to the password entry screen' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/posts'
    assert_match(%r{^/codeword/unlock}, URI.parse(current_url).path)
    refute_text 'Title One'
    refute_text 'Title Two'
    assert_text 'Please enter the code word to continue…'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'allows access to the requested page when the correct code word is supplied' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/posts'
    enter_code_word('omgponies')
    assert_current_path('/posts')
    assert_text 'Title One'
    assert_text 'Title Two'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'does not allow access when the incorrect code word is supplied' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/posts'
    enter_code_word('lolwut')
    refute_equal '/posts', URI.parse(current_url).path
    refute_text 'Title One'
    refute_text 'Title Two'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'allows direct access with a code in the URL' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/posts?codeword=omgponies'
    assert_text 'Title One'
    assert_text 'Title Two'

    click_on 'Title One'
    assert_text 'Title One'
    assert_text 'Body One'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'rejects direct access with an invalid code in the URL' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/posts?lookup_codeword=lolwut'
    assert_text 'Please enter the code word to continue…'
    refute_match(%r{^/posts}, URI.parse(current_url).path)
    refute_text 'Title One'
    refute_text 'Title Two'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'renders nothing when hit by a crawler using a valid code' do
    ENV['CODEWORD'] = 'OMGponies'
    set_user_agent_to('Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)')

    visit '/posts?codeword=omgponies'
    assert_equal '', page.body.to_s
  ensure
    reset_user_agent
    ENV.delete('CODEWORD')
  end

  test 'works with a catch all route' do
    ENV['CODEWORD'] = 'OMGponies'

    visit '/this-does-not-exist?codeword=omgponies'
    assert_equal 404, page.status_code
  ensure
    ENV.delete('CODEWORD')
  end

  test 'with a configured hint displays the hint to the user' do
    ENV['CODEWORD'] = 'OMGponies'
    ENV['CODEWORD_HINT'] = 'Cute 4-legged animals'

    visit '/posts'
    assert_selector(:xpath, "//small[@title='Cute 4-legged animals']")
  ensure
    ENV.delete('CODEWORD')
    ENV.delete('CODEWORD_HINT')
  end

  test 'without a user agent does not blow up' do
    ENV['CODEWORD'] = 'OMGponies'
    set_user_agent_to(nil)
    visit '/posts?codeword=omgponies'
  ensure
    ENV.delete('CODEWORD')
  end
end
