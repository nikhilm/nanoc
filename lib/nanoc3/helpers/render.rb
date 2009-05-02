module Nanoc3::Helpers

  # Nanoc3::Helpers::Render provides functionality for rendering layouts as
  # partials.
  #
  # This helper is activated automatically.
  module Render

    # Returns a string containing the rendered given layout.
    #
    # +identifier+:: the identifier of the layout that should be rendered.
    #
    # +other_assigns+:: a hash containing assigns that will be made available
    #                   as instance variables.
    #
    # Example 1: a layout 'head' with content "HEAD" and a layout 'foot' with
    # content "FOOT":
    #
    #   <%= render 'head' %> - MIDDLE - <%= render 'foot' %>
    #   # => "HEAD - MIDDLE - FOOT" 
    #
    # Example 2: a layout named 'head' with content "<h1><%= @title %></h1>":
    #
    #   <%= render 'head', :title => 'Foo' %>
    #   # => "<h1>Foo</h1>"
    def render(identifier, other_assigns={})
      # Find layout
      layout = @site.layouts.find { |l| l.identifier == identifier.cleaned_identifier }
      raise Nanoc3::Errors::UnknownLayoutError.new(identifier.cleaned_identifier) if layout.nil?

      # Get assigns
      assigns = {
        :item       => @item,
        :item_rep   => @item_rep,
        :items      => @items,
        :layout     => layout,
        :layouts    => @layouts,
        :config     => @config,
        :site       => @site
      }.merge(other_assigns)

      # Get filter name
      filter_name  = @site.compiler.filter_name_for_layout(layout)
      raise Nanoc3::Errors::CannotDetermineFilterError.new(layout.identifier) if filter_name.nil?

      # Get filter class
      filter_class = Nanoc3::Filter.named(filter_name)
      raise Nanoc3::Errors::UnknownFilterError.new(filter_name) if filter_class.nil?

      # Create filter
      filter = filter_class.new(assigns)

      # Layout
      @site.compiler.stack.push(layout)
      result = filter.run(layout.content)
      @site.compiler.stack.pop
      result
    end

  end

end