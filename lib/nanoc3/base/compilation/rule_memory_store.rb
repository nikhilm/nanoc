# encoding: utf-8

module Nanoc3

  # Stores rule memories for objects that can be run through a rule (item
  # representations and layouts).
  #
  # @api private
  class RuleMemoryStore < ::Nanoc3::Store

    # @option params [Nanoc3::Site] site The site where this rule memory store
    #   belongs to
    def initialize(params={})
      super('tmp/rule_memory', 1)

      @site = params[:site] if params.has_key?(:site)

      @rule_memories = {}
    end

    # @param [Nanoc3::ItemRep, Nanoc3::Layout] obj The item representation or
    #   the layout to get the rule memory for
    #
    # @return [Array] The rule memory for the given object
    def [](obj)
      @rule_memories[obj.reference]
    end

    # @param [Nanoc3::ItemRep, Nanoc3::Layout] obj The item representation or
    #   the layout to set the rule memory for
    #
    # @param [Array] rule_memory The new rule memory to be stored
    #
    # @return [void]
    def []=(obj, rule_memory)
      @rule_memories[obj.reference] = rule_memory
    end

  protected

    # @see Nanoc3::Store#data
    def data
      @rule_memories
    end

    # @see Nanoc3::Store#data=
    def data=(new_data)
      @rule_memories = new_data
    end

  end

end
