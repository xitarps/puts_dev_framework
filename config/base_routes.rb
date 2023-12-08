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

  def self.action_controller_resource(http_verb, target_path)
    controller = controller_name(target_path)

    feature = nil
    list[controller&.to_sym]&.select do |action, action_hash|
      verb, request_params_hash = action_hash.to_a.flatten
      next if verb != http_verb

      feature = {controller: , action:} if filter_action(request_params_hash, target_path).any?
      feature[:id] = fetch_id_from_path(target_path) if feature && fetch_id_from_path(target_path)
      feature[:params] = fetch_params(target_path) if feature && fetch_params(target_path)
    end
    feature
  end

  def self.controller_name(target_path)
    controller = target_path.split('/')
    controller.shift
    controller = controller.first
    controller = controller[0, (target_path.index('?') - 1)] if target_path.index('?')
    controller
  end

  def self.filter_action(request_params_hash, target_path)
    request_params_hash.select do |key, value|
      raw_target_path = target_path[0, (target_path.index('?') || target_path.size)]
      convert_id_to_path_param(raw_target_path) == value
    end
  end

  def self.convert_id_to_path_param(path)
    path.gsub(/\d+/, ':id')
  end

  def self.fetch_id_from_path(path)
    path =~ /\d+/
  end

  def self.fetch_params(path)
    return nil unless path.match(/\?/)

    params = path.split('?')
                 .last
                 .split('&')

    params.map do |key_value|
      key_value = key_value.split('=')
      {}.tap{ |hash| hash[key_value.first.to_sym] = URI.decode_uri_component(key_value.last)}
    end
  end
end
