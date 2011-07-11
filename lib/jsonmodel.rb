# require 'active_model/naming'
require 'active_model'

module JSONModel
  require 'jsonmodel/validations'
  require 'jsonmodel/attributes'
  require 'jsonmodel/persistence'
  
  def self.from_hash(schema)
    Class.new do
      @_schema = schema
      # extend ActiveModel::Naming
      include JSONModel::Attributes
      include JSONModel::Validations
      include JSONModel::Persistence
      
      include ActiveModel::Conversion
      
      def self.name
        @_schema['name']
      end
    end
  end
end