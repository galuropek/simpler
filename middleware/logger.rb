require 'logger'

class AppLogger

  TEMPLATE = '
Request: %<request>s
Handler: %<handler>s
Parameters: %<params>s
Response: %<response>s'.freeze

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @response = @app.call(env)
    @logger.info(log_body(env))
    @response
  end

  private

  def log_body(env)
    TEMPLATE % template_values(env)
  end

  def template_values(env)
    {
      request: "#{env['REQUEST_METHOD']} #{env['PATH_INFO']}",
      handler: "#{env['simpler.controller'].class}##{env['simpler.action']}",
      params: env['simpler.params'],
      response: "#{@response[0]} [#{@response[1]['Content-Type']}] #{env['simpler.view']}"
    }
  end
end
