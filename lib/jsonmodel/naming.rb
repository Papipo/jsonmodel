module JSONModel
  module Naming
    extend ActiveSupport::Concern
  
    module ClassMethods
      def name
        unless @name
          @name = schema['name']
          this = self
          @name.define_singleton_method(:constantize) do
            this
          end
        end
        @name
      end
    end
  end
end