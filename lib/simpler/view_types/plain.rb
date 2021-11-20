require_relative 'view'

module Simpler
  class ViewRender
    class Plain < View

      def render(binding)
        template
      end
    end
  end
end
