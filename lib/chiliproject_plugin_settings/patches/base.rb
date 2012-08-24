module ChiliprojectPluginSettings
  module Patches
    module Base
      def target
        raise NotImplementedError
      end

      def patched?
        target.included_modules.include? self
      end

      def patch
        patch! unless patched?
      end

      def patch!
        target.send :include, self
      end

      def included(base)
        base.send :include, self::InstanceMethods
      end
    end
  end
end
