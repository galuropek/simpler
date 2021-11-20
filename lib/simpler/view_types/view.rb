require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding); end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || relative_template_path

      Simpler.root.join(VIEW_BASE_PATH, path)
    end

    def relative_template_path
      "#{[controller.name, action].join('/')}.html.erb"
    end
  end
end
