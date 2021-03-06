require 'delegate'

module Enki
  class Config < SimpleDelegator
    def initialize(file_name)
      super(symbolize_keys(YAML::load(IO.read(file_name))))
    end

    def [](*path)
      path.inject(__getobj__()) {|config, item|
        config[item]
      }
    end

    def self.default
      Enki::Config.new(default_location)
    end

    def self.test
      Enki::Config.new(test_location)
    end

    def self.test_location
      "#{Rails.root}/config/enki_test.yml"
    end

    def self.default_location
      "#{Rails.root}/config/enki.yml"
    end

    private

    def symbolize_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value.is_a?(Hash) ? symbolize_keys(value) : value
        options
      end
    end
  end
end
