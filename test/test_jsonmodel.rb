require 'helper'

class TestJSONModel < Test::Unit::TestCase
  def setup
    @model = JSONModel.from_hash(
      "name" => "Product",
      "properties" => {
        "name" => {
          "type" => "string",
          "required" => true
        },
        "price" => {
          "type" => "number",
          "required" => true,
          "minimum" => 0
        },
        "weight" => {
          "type" => "number",
          "required" => true,
          "minimum" => 0,
          "exclusiveMinimum" => true
        },
        "ghz" => {
          "type" => "number",
          "required" => true,
          "maximum" => 2.4
        },
        "cpus" => {
          "type" => "number",
          "required" => true,
          "maximum" => 3,
          "exclusiveMaximum" => true
        },
        "tags" => {
          "type" => "array",
          "maxItems" => 5,
          "minItems" => 1,
          "items" => {
            "type" => "string"
          }
        }
      } 
    )
    
    @instance = @model.new(
      :name => 'MacBook',
      :price => 999,
      :weight => 5,
      :ghz => 2.4,
      :cpus => 2,
      :tags => ['apple', 'laptop']
    )
  end
  
  def test_attributes
    assert_equal({
      :name => 'MacBook',
      :price => 999,
      :weight => 5,
      :ghz => 2.4,
      :cpus => 2,
      :tags => ['apple', 'laptop']
    }, @instance.attributes)
  end
  
  def test_class_name
    assert_equal "Product", @model.name
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
end
