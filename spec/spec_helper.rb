SPEC_ROOT = Pathname(__FILE__).dirname

module TestNamespace
  def remove_constants
    constants.each do |name|
      remove_const(name)
    end
  end
end

class Hanami
  def self.root
    Pathname(SPEC_ROOT.join('fixtures'))
  end

  class Environment
    def project_name
      'test'
    end
  end
end

require 'dry/system/container'
require 'dry/system/hanami'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before do
    Object.const_set(:Test, Module.new { |m| m.extend(TestNamespace) })
  end

  config.after do
    Test.remove_constants
    Object.send(:remove_const, :Test)
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
