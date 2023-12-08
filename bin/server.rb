require 'socket'
require 'uri'

class Server
  def initialize
    @port = 3000
    @server = TCPServer.new(@port)
  end

  def call
    run
  end

  private

  def run
    puts "Server listening, port: #{@port}"

    loop do
      client = @server.accept

      request_line = client.readline

      http_verb, target_path, version_number = request_line.split

      headers = fetch_headers(client)
      data = client.read(headers["Content-Length"].to_i)
      data = format_payload(data) if data

      log_data = ['http_verb', 'target_path', 'version_number'].zip(request_line.split)
                                                               .map{ |item| { "#{item.first}": item.last} }
                                                               .inject{ |bash_hash, item_hash| bash_hash.merge item_hash}
      log(**log_data.merge({type: :request}))

      resource = Routes.action_controller_resource(http_verb.downcase.to_sym, target_path)
      resource = merge_resource_params(resource, data) unless resource.nil?

      log(**resource.merge({type: :response})) if resource
    end
  end

  def log(**args)
    if args[:type] == :request
      puts "Received -> request: #{args[:http_verb]}, to: #{args[:target_path]}, http version: #{args[:version_number]}"
    elsif args[:type] == :response
      puts "Returning -> controller: #{args[:controller]}, action: #{args[:action]}, params: #{args[:params]}}"
    else
      puts args[:data]
    end
  end

  def fetch_headers(client)
    headers = {}
    while line = client.gets.split(' ', 2)
      break if line[0] == ''

      headers[line[0].chop] = line[1].strip
    end
    headers
  end

  def format_payload(data)
    data.split('&')
        .map { |pair| pair.split('=') }
        .map { |pair| {}.tap{ |hash| hash[pair.first.to_sym] = pair.last} }
  end

  def merge_resource_params(resource, data)
    if resource.dig(:params) || data
      params = []
      params << (resource&.dig(:params)) if resource&.dig(:params)
      params << data if data
      resource[:params] = params.flatten if resource
      resource
    end
  end
end