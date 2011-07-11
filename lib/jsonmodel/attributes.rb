module JSONModel::Attributes
  def self.included(base)
    base.extend ClassMethods
    #TODO raise if the method already exists
    base.send(:attr_accessor, *base.attribute_names)
  end
  
  def initialize(attributes = {})
    attributes.each do |attribute, value|
      send("#{attribute}=", value)
    end
    super
  end
  
  def attributes
    self.class.attribute_names.inject({}) do |memo,name|
      memo[name] = send(name)
      memo
    end
  end
  
  module ClassMethods
    def attribute_names
      @attribute_names ||= @_schema['properties'].keys.map(&:to_sym)
    end
  end
end