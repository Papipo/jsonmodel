module JSONModel::Validations
  def self.included(base)
    base.class_eval do
      include ActiveModel::Validations
      include InstanceMethods # Need to do it this way so valid?() can call super from ActiveModel
      extend ClassMethods
    end
  end
      
  module InstanceMethods
    def valid?(*args)
      self.class.send(:setup_validations!)
      super
    end
  end
  
  class ArrayValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << :not_an_array and return unless value.is_a?(Array)
      record.errors[attribute] << :invalid_item_type unless value.all? { |item| item.is_a?(JSONModel::Types[options[:type]]) } if options[:type]
    end
  end
  
  module ClassMethods
    protected
    def setup_validations!
      return if @_validations_setup
      @_schema['properties'].each do |name,data|
        apply_validations_for(name.to_sym, data)
      end
      @_validations_setup = true
    end
  
    def apply_validations_for(name, data)
      validates(name, :presence => true) if data['required']
      
      case data['type']
      when 'number'
        validates name, :numericality => options_for_numericality(data)
      when 'array'
        validates name, :array => options_for_array(data)
      end
    end
    
    def options_for_array(data)
      if data['items'] && data['items']['type']
        {:type => data['items']['type']}
      else
        {}
      end
    end
  
    def options_for_numericality(data)
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