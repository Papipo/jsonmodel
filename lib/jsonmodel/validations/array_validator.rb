class JSONModel::Validations::ArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.is_a?(Array)
      record.errors.add(attribute, :not_an_array)
      return
    end
    
    if options[:type]
      record.errors.add(attribute, :invalid_item_type) unless value.all? do |item|
        item.is_a?(JSONModel::Types[options[:type]])
      end
    end
    
    if options[:max_items]
      record.errors.add(attribute, :too_many_items, :count => options[:max_items]) if value.size > options[:max_items]
    end
    
    if options[:min_items]
      record.errors.add(attribute, :too_few_items, :count => options[:min_items]) if value.size < options[:min_items]
    end
  end
end