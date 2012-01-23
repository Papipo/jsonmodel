require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jsonmodel'

class Test::Unit::TestCase
  def product_schema
    {
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
          "type" => "integer",
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
        },
        "ean" => {
          "type" => "string",
          "pattern" => /^[0-9]{13}$/
        }
      }
    }
  end
end
