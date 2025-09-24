lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codeword/version'

Gem::Specification.new do |spec|
  spec.name        = 'codeword'
  spec.version     = Codeword::VERSION
  spec.authors     = ['Dan Kim', 'gb Studio']
  spec.email       = ['git@dan.kim']

  spec.summary     = 'Lock staging servers from search engines and prying eyespec.'
  spec.description = 'A simple gem to more elegantly place a staging server or other in-progress application behind a basic codeword. It’s easy to implement, share with clients/collaborators, and more beautiful than the typical password-protection sheet.'
  spec.homepage    = 'https://github.com/dankimio/codeword'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dankimio/codeword'
  spec.metadata['changelog_uri'] = 'https://github.com/dankimio/codeword/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_dependency 'rails', '>= 7.2'

  spec.add_development_dependency 'capybara', '~> 2.9'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'launchy', '~> 2.4'
  spec.add_development_dependency 'rspec-rails', '~> 6.0'
end
