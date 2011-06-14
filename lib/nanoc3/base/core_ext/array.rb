# encoding: utf-8

module Nanoc3::ArrayExtensions

  # Returns a new array where all items' keys are recursively converted to
  # symbols by calling {Nanoc3::ArrayExtensions#symbolize_keys} or
  # {Nanoc3::HashExtensions#symbolize_keys}.
  #
  # @return [Array] The converted array
  def symbolize_keys
    inject([]) do |array, element|
      array + [ element.respond_to?(:symbolize_keys) ? element.symbolize_keys : element ]
    end
  end

  # Returns a new array where all items' keys are recursively converted to
  # strings by calling {Nanoc3::ArrayExtensions#stringify_keys} or
  # {Nanoc3::HashExtensions#stringify_keys}.
  #
  # @return [Array] The converted array
  def stringify_keys
    inject([]) do |array, element|
      array + [ element.respond_to?(:stringify_keys) ? element.stringify_keys : element ]
    end
  end

  # Freezes the contents of the array, as well as all array elements. The
  # array elements will be frozen using {#freeze_recursively} if they respond
  # to that message, or #freeze if they do not.
  #
  # @see Hash#freeze_recursively
  #
  # @return [void]
  #
  # @since 3.2.0
  def freeze_recursively
    freeze
    each do |value|
      if value.respond_to?(:freeze_recursively)
        value.freeze_recursively
      else
        value.freeze
      end
    end
  end

end

class Array
  include Nanoc3::ArrayExtensions
end
