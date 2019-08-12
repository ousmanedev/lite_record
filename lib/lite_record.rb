require 'sqlite3'
require 'lite_record/version'

module LiteRecord
  class << self
    attr_accessor :connection
  end

  autoload :Base, 'lite_record/base'

  def self.configure(path)
    self.connection = SQLite3::Database.new(path, results_as_hash: true)
  end
end
