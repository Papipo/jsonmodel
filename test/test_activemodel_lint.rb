require 'helper'
require 'active_model/lint'

class TestActiveModelLint < Test::Unit::TestCase
  include ActiveModel::Lint::Tests
  
  def setup
    @klass = JSONModel.from_hash(schema('product.json'))
    @model = @klass.new
  end
end