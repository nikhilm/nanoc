# encoding: utf-8

module Nanoc3::Filters

  # @since 3.2.0
  class Slim < Nanoc3::Filter

    # Runs the content through [Slim](http://slim-lang.com/)
    # This method takes no options.
    #
    # @param [String] content The content to filter
    #
    # @return [String] The filtered content
    def run(content, params={})
      require 'slim'

      # Create context
      context = ::Nanoc3::Context.new(assigns)

      ::Slim::Template.new { content }.render(context) { assigns[:content] }
    end

  end

end
