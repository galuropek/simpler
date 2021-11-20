require_relative 'view_types/html'
require_relative 'view_types/plain'

module Simpler
  class ViewRender

    def initialize(env)
      @env = env
      require_views
    end

    def render(binding)
      view = get_view_constant
      view.new(@env).render(binding)
    end

    private

    def require_views
      Dir["#{Simpler.root}/app/lib/view_types/*.rb"].each { |file| require file }
    end

    def get_view_constant
      content_type = @env['simpler.content_type']
      constant_path = "Simpler::ViewRender::#{content_type.capitalize}"
      Object.const_get(constant_path)
    end
  end
end
