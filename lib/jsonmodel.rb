# require 'active_model/naming'
require 'active_model'

module JSONModel
  def self.from_hash(schema)
    Class.new do
      @_schema = schema
      # extend ActiveModel::Naming
      include ActiveModel::Validations
      include ActiveModel::Conversion
      
      def initialize(attributes = {})
        attributes.each do |attribute, value|
          send("#{attribute}=", value)
        end
      end
      
      def attributes
        self.class.attribute_names.inject({}) do |memo,name|
          memo[name] = send(name)
          memo
        end
      end
      
      def valid?(context = nil)
        self.class.setup_validations!
        super
      end
      
      def persisted?
        false
      end
      
      def self.name
        @_schema['name']
      end
      
      def self.attribute_names
        @attribute_names ||= @_schema['properties'].keys.map(&:to_sym)
      end
      
      #TODO raise if the method already exists
      attr_accessor *attribute_names
      
      protected
      def self.setup_validations!
        return if @_validations_setup
        @_schema['properties'].each do |name,data|
          apply_validations_for(name.to_sym, data)
        end
        @_validations_setup = true
      end
      
      def self.apply_validations_for(name, data)
        validates_presence_of(name) if data['required']
        validates_numericality_of(name, options_for_numericality(data)) if data['type'] == 'number'
      end
      
      def self.options_for_numericality(data)
        if data['minimum']
          if data['exclusiveMinimum']
            {:greater_than => data['minimum']}
          else
            {:greater_than_or_equal_to => data['minimum']}
          end
        elsif data['maximum']
          if data['exclusiveMaximum']
            {:less_than => data['maximum']}
          else
            {:less_than_or_equal_to => data['maximum']}
          end
        else
          {}
        end
      end
    end
  end
end