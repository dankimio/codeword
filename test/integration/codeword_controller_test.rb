require "test_helper"

class CodewordControllerTest < ActionDispatch::IntegrationTest
  setup do
    reset_codeword_configuration_cache!
  end

  test "malicious user posts invalid data does not fail" do
    post "/codeword/unlock", params: { foo: "bar" }
    assert_response :success
  end

  test "malicious user requests non-HTML format returns 406" do
    get "/codeword/unlock.text"
    assert_response :not_acceptable
  end

  test "cookie_lifetime: integer returns configured duration" do
    ENV["COOKIE_LIFETIME_IN_WEEKS"] = "52"
    assert_equal 52.weeks, Codeword::Configuration.codeword_cookie_lifetime
  ensure
    ENV.delete("COOKIE_LIFETIME_IN_WEEKS")
  end

  test "cookie_lifetime: invalid returns default 5.years" do
    ENV["COOKIE_LIFETIME_IN_WEEKS"] = "invalid value"
    assert_equal 5.years, Codeword::Configuration.codeword_cookie_lifetime
  ensure
    ENV.delete("COOKIE_LIFETIME_IN_WEEKS")
  end

  test "cookie_lifetime: not set returns default 5.years" do
    ENV.delete("COOKIE_LIFETIME_IN_WEEKS")
    assert_equal 5.years, Codeword::Configuration.codeword_cookie_lifetime
  end

  test "open redirect protection: does not redirect to external host via return_to" do
    ENV["CODEWORD"] = "secret"
    post "/codeword/unlock", params: { codeword: "secret", return_to: "https://evil.com/phish" }
    assert_redirected_to "/"
  ensure
    ENV.delete("CODEWORD")
  end

  test "open redirect protection: redirects to valid relative path via return_to" do
    ENV["CODEWORD"] = "secret"
    post "/codeword/unlock", params: { codeword: "secret", return_to: "/posts/1" }
    assert_redirected_to "/posts/1"
  ensure
    ENV.delete("CODEWORD")
  end

  test "cookie security attributes are set on codeword cookie" do
    ENV["CODEWORD"] = "secret"
    post "/codeword/unlock", params: { codeword: "secret", return_to: "/posts" }
    header = response.headers["Set-Cookie"]
    assert_includes header, "codeword="
    assert_includes header.downcase, "httponly"
    assert_match(/samesite=(lax|strict|none)/i, header)
  ensure
    ENV.delete("CODEWORD")
  end
end
