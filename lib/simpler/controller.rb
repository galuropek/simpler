require_relative 'view_render'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    HEADERS = {
      content_type: { plain: 'text/plain', html: 'text/html' }
    }.freeze

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action


      set_params_from_route(params)
      set_default_headers(action)
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_params_from_route(params)
      params.each { |key, value| @request.update_param(key, value) }
      @request.env['simpler.params'] = params
    end

    def set_default_headers(action)
      @request.env['simpler.content_type'] = :html
      @response['Cnotroller-Name'] = self.class.name
      @response['Controller-Action'] = action
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      ViewRender.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      response_data = prepare_response(template)
      @request.env['simpler.content_type'] = response_data[:type]
      @request.env['simpler.template'] = response_data[:body]
    end

    def prepare_response(template)
      if template.is_a?(Hash)
        type, body = template.first
      else
        type = :html
        body = template
      end

      { type: type, body: body }
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end
  end
end
