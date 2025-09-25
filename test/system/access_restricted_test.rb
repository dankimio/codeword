require 'test_helper'

class AccessRestrictedTest < ActionDispatch::IntegrationTest
  include CodewordTestHelper

  setup do
    reset_codeword_configuration_cache!
  end

  test 'without a configured code word displays the requested page' do
    ENV.delete('CODEWORD')
    reset_codeword_configuration_cache!

    get '/posts'
    assert_response :ok
    assert_includes @response.body, 'Title One'
    assert_includes @response.body, 'Title Two'
  end

  test 'with a configured code word redirects to the password entry screen' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/posts'
    assert_response :redirect
    follow_redirect!
    assert_equal '/codeword/unlock', @request.path
    assert_includes @response.body, 'Please enter the code word to continue…'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'allows access to the requested page when the correct code word is supplied' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/posts'
    follow_redirect!

    post '/codeword/unlock', params: { codeword: 'omgponies', return_to: '/posts' }
    assert_redirected_to '/posts'
    follow_redirect!
    assert_response :ok
    assert_includes @response.body, 'Title One'
    assert_includes @response.body, 'Title Two'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'does not allow access when the incorrect code word is supplied' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/posts'
    follow_redirect!

    post '/codeword/unlock', params: { codeword: 'lolwut', return_to: '/posts' }
    assert_response :success
    refute_includes @response.body, 'Title One'
    refute_includes @response.body, 'Title Two'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'allows direct access with a code in the URL' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/posts', params: { codeword: 'omgponies' }
    follow_redirects!
    assert_response :ok
    assert_includes @response.body, 'Title One'
    assert_includes @response.body, 'Title Two'

    get '/posts/1'
    assert_response :ok
    assert_includes @response.body, 'Title One'
    assert_includes @response.body, 'Body One'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'rejects direct access with an invalid code in the URL' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/posts', params: { lookup_codeword: 'lolwut' }
    follow_redirect!
    assert_equal '/codeword/unlock', @request.path
    assert_includes @response.body, 'Please enter the code word to continue…'
  ensure
    ENV.delete('CODEWORD')
  end

  test 'renders nothing when hit by a crawler using a valid code' do
    ENV['CODEWORD'] = 'OMGponies'
    get '/codeword/unlock', params: { codeword: 'omgponies', return_to: '/posts' }, headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)' }
    assert_response :ok
    assert_equal '', @response.body.to_s
  ensure
    ENV.delete('CODEWORD')
  end

  test 'works with a catch all route' do
    ENV['CODEWORD'] = 'OMGponies'

    get '/this-does-not-exist', params: { codeword: 'omgponies' }
    follow_redirects!
    assert_response :not_found
  ensure
    ENV.delete('CODEWORD')
  end

  test 'with a configured hint displays the hint to the user' do
    ENV['CODEWORD'] = 'OMGponies'
    ENV['CODEWORD_HINT'] = 'Cute 4-legged animals'

    get '/posts'
    follow_redirect!
    assert_includes @response.body, 'title="Cute 4-legged animals"'
  ensure
    ENV.delete('CODEWORD')
    ENV.delete('CODEWORD_HINT')
  end

  test 'without a user agent does not blow up' do
    ENV['CODEWORD'] = 'OMGponies'
    get '/posts', params: { codeword: 'omgponies' }, headers: { 'HTTP_USER_AGENT' => nil }
    follow_redirects!
    assert_response :ok
  ensure
    ENV.delete('CODEWORD')
  end
end
