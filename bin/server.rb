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

      response_message = build_response_message(resource)
      http_response = build_http_response(response_message)

      puts "\n"
      client.puts(http_response)
      client.close
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

  def build_response_message(resource)
    if resource.nil?
      "<h1 style='color: red;'>Oops! didin't find any resource</h1>"
    else
      controller = Object.const_get((resource[:controller] + '_controller').camelize)
      controller_response = controller.new(**resource).send(resource[:action])
      controller_response[:view].render
    end
  end

  def build_http_response(body, status: { number: 200, message: 'OK' }, headers: {'Content-type': 'text/html'})
    http_header = "HTTP/1.1 #{status[:number]} #{status[:message]}\n"
    http_header << headers.map{ |key, value| "#{key}: #{value}" }.join

    <<~HTTP_MSG
      #{http_header}

      <!DOCTYPE html>
      <html lang="pt-BR">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
      </head>
      <body>
        #{body}
      </body>
      </html>
    HTTP_MSG
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