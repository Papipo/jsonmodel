# require 'active_model/naming'
require 'active_model'
require 'i18n'

I18n.load_path << File.join(File.dirname(__FILE__), "config", "locales", "en.yml")

module JSONModel
  require 'jsonmodel/types'
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