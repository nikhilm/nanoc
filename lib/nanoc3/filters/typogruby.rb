# encoding: utf-8

module Nanoc3::Filters

  # @since 3.2.0
  class Typogruby < Nanoc3::Filter

    # Runs the content through [Typogruby](http://avdgaag.github.com/typogruby/).
    # This method takes no options.
    #
    # @param [String] content The content to filter
    #
    # @return [String] The filtered content
    def run(content, params={})
      require 'typogruby'

      # Get result
      ::Typogruby.improve(content)
    end

  end

end
