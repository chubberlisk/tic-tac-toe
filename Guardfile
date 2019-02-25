# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec --format documentation' do
  watch(%r{^spec/}) { 'spec' }
  watch(%r{^lib/}) { 'spec' }
end
