module Nanoc3

  # Keeps track of the rules in a site.
  #
  # @api private
  class RulesCollection

    extend Nanoc3::Memoization

    # @return [Array<Nanoc3::Rule>] The list of item compilation rules that
    #   will be used to compile items.
    attr_reader :item_compilation_rules

    # @return [Array<Nanoc3::Rule>] The list of routing rules that will be
    #   used to give all items a path.
    attr_reader :item_routing_rules

    # The hash containing layout-to-filter mapping rules. This hash is
    # ordered: iterating over the hash will happen in insertion order.
    #
    # @return [Hash] The layout-to-filter mapping rules
    attr_reader :layout_filter_mapping

    # @return [Proc] The code block that will be executed after all data is
    #   loaded but before the site is compiled
    attr_accessor :preprocessor

    # @param [Nanoc3::Compiler] compiler The site’s compiler
    def initialize(compiler)
      @compiler = compiler

      @item_compilation_rules  = []
      @item_routing_rules      = []
      @layout_filter_mapping   = OrderedHash.new
    end

    # Add the given rule to the list of item compilation rules.
    #
    # @param [Nanoc3::Rule] rule The item compilation rule to add
    #
    # @param [:before, :after] position The place where the rule should be
    #   added (either at the beginning or the end of the list of rules)
    #
    # @return [void]
    def add_item_compilation_rule(rule, position=:after)
      case position
      when :before
        @item_compilation_rules.unshift(rule)
      when :after
        @item_compilation_rules << rule
      else
        raise "#add_item_routing_rule expected position to be :after or :before"
      end
    end

    # Add the given rule to the list of item routing rules.
    #
    # @param [Nanoc3::Rule] rule The item routing rule to add
    #
    # @param [:before, :after] position The place where the rule should be
    #   added (either at the beginning or the end of the list of rules)
    #
    # @return [void]
    def add_item_routing_rule(rule, position=:after)
      case position
      when :before
        @item_routing_rules.unshift(rule)
      when :after
        @item_routing_rules << rule
      else
        raise "#add_item_routing_rule expected position to be :after or :before"
      end
    end

    # @param [Nanoc3::Item] item The item for which the compilation rules
    #   should be retrieved
    #
    # @return [Array] The list of item compilation rules for the given item
    def item_compilation_rules_for(item)
      @item_compilation_rules.select { |r| r.applicable_to?(item) }
    end

    # Loads this site’s rules.
    #
    # @return [void]
    def load
      # Find rules file
      rules_filenames = [ 'Rules', 'rules', 'Rules.rb', 'rules.rb' ]
      rules_filename = rules_filenames.find { |f| File.file?(f) }
      raise Nanoc3::Errors::NoRulesFileFound.new if rules_filename.nil?

      # Get rule data
      @data = File.read(rules_filename)

      # Load DSL
      dsl.instance_eval(@data, "./#{rules_filename}")
    end

    # Unloads this site’s rules.
    #
    # @return [void]
    def unload
      @item_compilation_rules  = []
      @item_routing_rules      = []
      @layout_filter_mapping   = OrderedHash.new
    end

    # Finds the first matching compilation rule for the given item
    # representation.
    #
    # @param [Nanoc3::ItemRep] rep The item rep for which to fetch the rule
    #
    # @return [Nanoc3::Rule, nil] The compilation rule for the given item rep,
    #   or nil if no rules have been found
    def compilation_rule_for(rep)
      @item_compilation_rules.find do |rule|
        rule.applicable_to?(rep.item) && rule.rep_name == rep.name
      end
    end

    # Finds the first matching routing rule for the given item representation.
    #
    # @param [Nanoc3::ItemRep] rep The item rep for which to fetch the rule
    #
    # @return [Nanoc3::Rule, nil] The routing rule for the given item rep, or
    #   nil if no rules have been found
    def routing_rule_for(rep)
      @item_routing_rules.find do |rule|
        rule.applicable_to?(rep.item) && rule.rep_name == rep.name
      end
    end

    # Returns the list of routing rules that can be applied to the given item
    # representation. For each snapshot, the first matching rule will be
    # returned. The result is a hash containing the corresponding rule for
    # each snapshot.
    #
    # @param [Nanoc3::ItemRep] rep The item rep for which to fetch the rules
    #
    # @return [Hash<Symbol, Nanoc3::Rule>] The routing rules for the given rep
    def routing_rules_for(rep)
      rules = {}
      @item_routing_rules.each do |rule|
        next if !rule.applicable_to?(rep.item)
        next if rule.rep_name != rep.name
        next if rules.has_key?(rule.snapshot_name)

        rules[rule.snapshot_name] = rule
      end
      rules
    end

    # Finds the filter name and arguments to use for the given layout.
    #
    # @param [Nanoc3::Layout] layout The layout for which to fetch the filter.
    #
    # @return [Array, nil] A tuple containing the filter name and the filter 
    #   arguments for the given layout.
    def filter_for_layout(layout)
      @layout_filter_mapping.each_pair do |layout_identifier, filter_name_and_args|
        return filter_name_and_args if layout.identifier =~ layout_identifier
      end
      nil
    end

    # Returns the Nanoc3::CompilerDSL that should be used for this site.
    def dsl
      Nanoc3::CompilerDSL.new(self)
    end
    memoize :dsl

    # Returns an object that can be used for uniquely identifying objects.
    #
    # @return [Object] An unique reference to this object
    def reference
      :rules
    end

    # @return [String] The checksum for this object. If its contents change,
    #   the checksum will change as well.
    def checksum
      @data.checksum
    end

    def inspect
      "<#{self.class}:0x#{self.object_id.to_s(16)}>"
    end

    # @param [Nanoc3::ItemRep] rep The item representation to get the rule
    #   memory for
    #
    # @return [Array] The rule memory for the given item representation
    def new_rule_memory_for_rep(rep)
      recording_proxy = rep.to_recording_proxy
      compilation_rule_for(rep).apply_to(recording_proxy, :compiler => @compiler)
      recording_proxy.rule_memory
    end
    memoize :new_rule_memory_for_rep

    # @param [Nanoc3::Layout] layout The layout to get the rule memory for
    #
    # @return [Array] The rule memory for the given layout
    def new_rule_memory_for_layout(layout)
      filter_for_layout(layout)
    end
    memoize :new_rule_memory_for_layout

    # @param [Nanoc3::Item] obj The object for which to check the rule memory
    #
    # @return [Boolean] true if the rule memory for the given object has
    # changed since the last compilation, false otherwise
    def rule_memory_differs_for(obj)
      !rule_memory_store[obj].eql?(rule_memory_calculator[obj])
    end
    memoize :rule_memory_differs_for

    # @return [Nanoc3::RuleMemoryStore] The rule memory store
    def rule_memory_store
      @compiler.rule_memory_store
    end

    # @return [Nanoc3::RuleMemoryCalculator] The rule memory calculator
    def rule_memory_calculator
      @compiler.rule_memory_calculator
    end

  end

end
