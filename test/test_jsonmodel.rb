require 'helper'

class TestJSONModel < Test::Unit::TestCase
  def setup
    @model = JSONModel.from_hash(product_schema)
    
    @instance = @model.new(
      :name => 'MacBook',
      :price => 999,
      :weight => 5,
      :ghz => 2.4,
      :cpus => 2,
      :tags => ['apple', 'laptop'],
      :ean => '0012345678905'
    )
  end
  
  
  def test_attributes
    assert_equal({
      :name => 'MacBook',
      :price => 999,
      :weight => 5,
      :ghz => 2.4,
      :cpus => 2,
      :tags => ['apple', 'laptop'],
      :ean => '0012345678905'
    }, @instance.attributes)
  end
  
  def test_class_name
    assert_equal "Product", @model.name
  end
  
  def test_name_constantize
    assert_equal @model, @model.name.constantize
  end
  
  def test_validators_on
    assert_equal 1, @model.validators_on(:name).count
  end
  
  def test_validators
    assert @model.validators.count > 1
  end
  
  def test_accessors
    assert_equal "MacBook", @instance.name
    @instance.name = ''
    assert_equal '', @instance.name
  end
  
  def test_required
    @instance.name = ''
    assert !@instance.valid?
    assert_equal ["can't be blank"], @instance.errors[:name]
  end
  
  def test_number
    @instance.price = 'g'
    assert !@instance.valid?
    assert_equal ["is not a number"], @instance.errors[:price]
  end
  
  def test_integer
    @instance.cpus = 0.5
    assert !@instance.valid?
    assert_equal ["must be an integer"], @instance.errors[:cpus]
  end
  
  def test_minimum_number
    @instance.price = -1
    assert !@instance.valid?
    assert_equal ["must be greater than or equal to 0"], @instance.errors[:price]
  end
  
  def test_exclusive_minimum
    @instance.weight = 0
    assert !@instance.valid?
    assert_equal ["must be greater than 0"], @instance.errors[:weight]
  end
  
  def test_maximum
    @instance.ghz = 2.5
    assert !@instance.valid?
    assert_equal ["must be less than or equal to 2.4"], @instance.errors[:ghz]
  end
  
  def test_exclusive_maximum
    @instance.cpus = 3
    assert !@instance.valid?
    assert_equal ["must be less than 3"], @instance.errors[:cpus]
  end
  
  def test_array_type
    @instance.tags = 'test'
    assert !@instance.valid?
    assert_equal ["must be an array"], @instance.errors[:tags]
  end
  
  def test_array_items_type
    @instance.tags = [{"some" => "hash"}]
    assert !@instance.valid?
    assert_equal ["has invalid items"], @instance.errors[:tags]
  end
  
  def test_array_maxitems
    @instance.tags = ['one', 'two', 'three', 'four', 'five', 'toomany']
    assert !@instance.valid?
    assert_equal ["can't have more than 5 items"], @instance.errors[:tags]
  end
  
  def test_array_minitems
    @instance.tags = []
    assert !@instance.valid?
    assert_equal ["must have at least one item"], @instance.errors[:tags]
  end
  
  def test_pattern
    @instance.ean = '34'
    assert !@instance.valid?
    assert_equal ["is invalid"], @instance.errors[:ean]
  end
end
