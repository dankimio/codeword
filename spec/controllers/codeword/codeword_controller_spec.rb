require 'spec_helper'

describe Codeword::CodewordController do
  include CodewordTestHelper

  routes { Codeword::Engine.routes }

  describe 'a malicious user posts invalid data' do
    it 'does not fail' do
      post 'unlock', params: { foo: 'bar' }
    end
  end

  describe 'a malicious user requests a format that is not HTML' do
    it 'throws an unknown format error' do
      -> { get 'unlock', format: 'text' }.should raise_error(ActionController::UnknownFormat)
    end
  end

  describe '#cookie_lifetime' do
    before { reset_codeword_configuration_cache! }

    context 'COOKIE_LIFETIME_IN_WEEKS is set to an integer' do
      before { ENV['COOKIE_LIFETIME_IN_WEEKS'] = '52' }

      it 'returns the integer' do
        Codeword::Configuration.codeword_cookie_lifetime.should eq(52.weeks)
      end
    end

    context 'COOKIE_LIFETIME_IN_WEEKS is not a valid integer' do
      before { ENV['COOKIE_LIFETIME_IN_WEEKS'] = 'invalid value' }

      it 'returns the integer' do
        Codeword::Configuration.codeword_cookie_lifetime.should eq(5.years)
      end
    end

    context 'COOKIE_LIFETIME_IN_WEEKS is not set' do
      before { ENV.delete('COOKIE_LIFETIME_IN_WEEKS') }

      it 'returns the integer' do
        Codeword::Configuration.codeword_cookie_lifetime.should eq(5.years)
      end
    end
  end

  describe 'open redirect protection' do
    before do
      ENV['CODEWORD'] = 'secret'
      reset_codeword_configuration_cache!
    end

    it 'does not redirect to an external host via return_to' do
      post 'unlock', params: { codeword: 'secret', return_to: 'https://evil.com/phish' }
      response.should redirect_to('/')
    end

    it 'redirects to a valid relative path via return_to' do
      post 'unlock', params: { codeword: 'secret', return_to: '/posts/1' }
      response.should redirect_to('/posts/1')
    end
  end

  describe 'cookie security attributes' do
    before do
      ENV['CODEWORD'] = 'secret'
      reset_codeword_configuration_cache!
    end

    it 'sets HttpOnly and SameSite on the codeword cookie' do
      post 'unlock', params: { codeword: 'secret', return_to: '/posts' }
      header = response.headers['Set-Cookie']
      header.should include('codeword=')
      header.downcase.should include('httponly')
      header.should match(/samesite=(lax|strict|none)/i)
    end
  end
end
