require_relative "lib/codeword/version"

Gem::Specification.new do |spec|
  spec.name = "codeword"
  spec.version = Codeword::VERSION
  spec.authors = ["Dan Kim", "gb Studio"]
  spec.email = ["git@dan.kim"]

  spec.summary = "Lock staging servers from search engines and prying eyes."
  spec.description = "Protect your staging server or in-progress app with a simple codeword prompt. Easy to install and share, prettier than a basic password prompt."
  spec.homepage = "https://github.com/dankimio/codeword"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dankimio/codeword"
  spec.metadata["changelog_uri"] = "https://github.com/dankimio/codeword/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end

  spec.add_dependency "rails", ">= 7.2"
end
