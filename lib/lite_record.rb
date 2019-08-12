require 'lite_record/version'
require 'lite_record/configuration'

module LiteRecord
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end