JSONModel::Types = {
  "string"  => String,
  "integer" => [Integer, Fixnum],
  "number"  => [Integer, Float, Fixnum, Numeric],
  "boolean" => [TrueClass, FalseClass],
  "object"  => Hash,
  "array"   => Array,
  "null"    => NilClass,
  "any"     => nil
}