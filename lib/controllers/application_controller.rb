class ApplicationController
  def initialize(**args)
    @current_controller = args[:controller]
    @current_action = args[:action]
    @params = args[:params]&.inject({ id: args[:id] }){ |base_hash, hash| base_hash.merge(hash)}
  end

  protected

  attr_accessor :params
end