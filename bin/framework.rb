require_relative '../config/load_initializers.rb'

class Framework
  def initialize
    @args = ARGV
    @options = {
      routes: ->{ routes(@args) },
      server: ->{ Server.new.call },
      db: -> { Database.call(@args - ['db']) }
    }
  end

  def self.call
    new.call
  end

  def call
    @options[@args.first.to_sym].call
  end

  private

  def routes(args)
    Routes.show_routes(args)
  end
end

Framework.call
