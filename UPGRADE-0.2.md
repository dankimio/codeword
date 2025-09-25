# Migrating from 0.1.x to 0.2.0

This guide walks you through the changes required to upgrade from 0.1.x to 0.2.0.

## TL;DR checklist

- Update to Rails >= 7.2.
- Move credentials to the namespaced structure under `codeword`.
- Ensure controllers use `require_codeword!` (and skip it only where access is allowed).
- Stop relying on external `return_to` redirects; they are blocked now.

## 1) Credentials: namespaced only

Codeword now reads credentials only from the namespaced structure:

```yml
# config/credentials.yml.enc
codeword:
  codeword: "love"
  hint: "Pepé Le Pew"
  cookie_lifetime_in_weeks: 4
```

- Non‑namespaced keys like `codeword_hint:` at the root are no longer read.
- Environment variable fallbacks still work: `ENV['CODEWORD']`, `ENV['CODEWORD_HINT']`, `ENV['COOKIE_LIFETIME_IN_WEEKS']`.

## 2) Controller hook rename and usage

- Use `require_codeword!` to enforce the codeword gate.

```ruby
class ApplicationController < ActionController::Base
  include Codeword::Authentication
  before_action :require_codeword!
end
```

- Skip it only for controllers/actions you want to allow without the codeword:

```ruby
class APIController < ApplicationController
  skip_before_action :require_codeword!
end
```

- The old `check_for_codeword` name is deprecated; switch to `require_codeword!`.

## 3) Redirect hardening (open redirects)

- After a successful unlock, external `return_to` URLs are no longer allowed. Redirects now use `allow_other_host: false` and will fall back to the root path if unsafe.
- If you previously depended on redirecting to external domains, move that flow behind your own internal path and perform external navigation server‑side or client‑side after the unlock.
