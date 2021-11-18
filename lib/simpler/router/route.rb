module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      PARAMS_KEYS_REGEXP = { id: '\\d+' }.freeze

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params_keys = parse_params_keys
      end

      def match?(method, path)
        @method == method && path.match(path_regexp)
      end

      def params(env)
        return {} if @params_keys.empty?

        path = env['PATH_INFO']
        @params_keys.each_with_object({}) do |param_key, params|
          param_value = path.match(path_regexp)[param_key.to_sym]
          params[param_key.to_sym] = param_value if param_value
        end
      end

      private

      def parse_params_keys
        @path.scan(/:(\w+)/).flatten.uniq
      end

      def path_regexp
        Regexp.new("#{@params_keys.empty? ? @path : prepare_params_for_regexp}$")
      end

      def prepare_params_for_regexp
        @params_keys.each_with_object(@path.dup) do |param_key, prepared_path|
          prepared_path.gsub!(":#{param_key}", "(?<#{param_key}>\\w+)")
        end
      end
    end
  end
end
