class BaseRoutes
  def self.show_routes(args)
    puts '---Controller(Action) -> Verb: Path - [Params]---'
    puts '_________________________________________________'

    list.each do |controller, actions|
      actions.each do |action, request_hash|
        verb, request_params_hash = request_hash.to_a.flatten
        puts "#{controller}(#{action}) -> #{verb.to_s.upcase}: #{request_params_hash[:path]} - #{request_params_hash[:params]}"
      end
    end
  end
end
