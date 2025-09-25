## [Unreleased]

- BREAKING: Only support namespaced Rails credentials under `codeword` (e.g. `codeword.codeword`, `codeword.hint`, `codeword.cookie_lifetime_in_weeks`)
- BREAKING: Drop support for Rails < 7.2
- BREAKING: Rename `check_for_codeword` to `require_codeword!`
- BREAKING: Deprecate Rails secrets in favor of Rails credentials
- BREAKING: Remove lowercase ENV variable support (only uppercase ENV variables are now supported)

- Prevent open redirects by using `allow_other_host: false`
- Harden cookie with `httponly: true`, `same_site: :lax`, and `secure: request.ssl?`
- `codeword_cookie_lifetime` now returns an `ActiveSupport::Duration`; cookie expiry uses `from_now`
- Updated crawler detection regex (removed duplicate `spider` and generic `click` token)

## [0.1.1] - 2021-12-17

- Fix unlocks
- Refactor CodewordController

## [0.1.0] - 2021-12-17

- Initial release
