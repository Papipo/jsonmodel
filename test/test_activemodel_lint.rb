require 'helper'
require 'active_model/lint'

class TestActiveModelLint < Test::Unit::TestCase
  include ActiveModel::Lint::Tests
  
  def setup
    @klass = JSONModel.from_hash(product_schema)
    @model = @klass.new
  end
end