module JSONModel::Validations
  require 'jsonmodel/validations/array_validator'
  
  def self.included(base)
    base.class_eval do
      include ActiveModel::Validations
      include InstanceMethods # Need to do it this way so valid?() can call super from ActiveModel
      extend ClassMethods
      
      def self.validators_on(*args)
        setup_validations!
        super
      end
      
      def self.validators(*args)
        setup_validations!
        super
      end
    end
  end
      
  module InstanceMethods
    def valid?(*args)
      self.class.send(:setup_validations!)
      super
    end
  end
  
  module ClassMethods
    protected
    def setup_validations!
      return if @_validations_setup
      schema['properties'].each do |name,data|
        apply_validations_for(name.to_sym, data)
      end
      @_validations_setup = true
    end
  
    def apply_validations_for(property, data)
      validates(property, :presence => true) if data['required']
      
      case data['type']
      when 'string'
        validates property, :format => {:with => data['pattern']} if data['pattern']
      when 'number', 'integer'
        validates property, :numericality => options_for_numericality(data)
      when 'array'
        validates property, :array => options_for_array(data)
      end
    end
    
    def options_for_array(data)
      options = {}
      options[:type]      = data['items'] && data['items']['type']
      options[:max_items] = data['maxItems']
      options[:min_items] = data['minItems']
      options
    end
  
    def options_for_numericality(data)
      options = {}
      if data['minimum']
        if data['exclusiveMinimum']
          options[:greater_than] = data['minimum']
        else
          options[:greater_than_or_equal_to] = data['minimum']
        end
      elsif data['maximum']
        if data['exclusiveMaximum']
          options[:less_than] = data['maximum']
        else
          options[:less_than_or_equal_to] = data['maximum']
        end
      end
      options[:only_integer] = true if data['type'] == 'integer'
      options
    end
  end
end