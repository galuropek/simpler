require_relative 'view'

module Simpler
  class ViewRender
    class Html < View

      def render(binding)
        @env['simpler.view'] = relative_template_path
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end
  end
end
