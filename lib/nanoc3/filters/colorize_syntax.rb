# encoding: utf-8

module Nanoc3::Filters
  class ColorizeSyntax < Nanoc3::Filter

    # The default colorizer to use for a language if the colorizer for that
    # language is not overridden.
    DEFAULT_COLORIZER = :coderay

    # Syntax-highlights code blocks in the given content. Code blocks should
    # be enclosed in `pre` elements that contain a `code` element. The code
    # element should have a class starting with `language-` and followed by
    # the programming language, as specified by HTML5.
    #
    # Options for individual colorizers will be taken from the {#run}
    # options’ value for the given colorizer. For example, if the filter is
    # invoked with a `:coderay => coderay_options_hash` option, the
    # `coderay_options_hash` hash will be passed to the CodeRay colorizer.
    #
    # Currently, only the `:coderay` (http://coderay.rubychan.de/),
    # `:pygmentize` (http://pygments.org/, http://pygments.org/docs/cmdline/),
    # and `:simon_highlight`
    # (http://www.andre-simon.de/doku/highlight/en/highlight.html) colorizers
    # are implemented. Additional colorizer implementations are welcome!
    #
    # @example Content that will be highlighted
    #
    #     <pre><code class="language-ruby">
    #     def foo
    #       "asdf"
    #     end
    #     </code></pre>
    #
    # @example Invoking the filter with custom parameters
    #
    #     filter :colorize_syntax,
    #            :colorizers => { :ruby => :coderay },
    #            :coderay    => { :line_numbers => :list }
    #
    # @param [String] content The content to filter
    #
    # @option params [symbol] :default_colorizer (DEFAULT_COLORIZER) The
    #   default colorizer, i.e. the colorizer that will be used when the
    #   colorizer is not overriden for a specific language.
    #
    # @option params [Hash] :colorizers ({}) A hash containing
    #   a mapping of programming languages (symbols, not strings) onto
    #   colorizers (symbols).
    #
    # @return [String] The filtered content
    def run(content, params={})
      require 'nokogiri'

      # Take colorizers from parameters
      @colorizers = Hash.new(params[:default_colorizer] || DEFAULT_COLORIZER)
      (params[:colorizers] || {}).each_pair do |language, colorizer|
        @colorizers[language] = colorizer
      end

      # Determine syntax (HTML or XML)
      syntax = params[:syntax] || :html
      case syntax
      when :html
        klass = Nokogiri::HTML
      when :xml
        klass = Nokogiri::XML
      else
        raise RuntimeError, "unknown syntax: #{syntax.inspect} (expected :html or :xml)"
      end

      # Colorize
      doc = klass.fragment(content)
      doc.css('pre > code').each do |element|
        # Get language
        match = element.inner_text.match(/^#!([^\n ]+)/)
        next if match.nil?
        language = match[1]

        # Highlight
        highlighted_code = highlight(element.inner_text[match[0].length, element.inner_text.length].strip, language, params)
        element.inner_html = highlighted_code.strip
      end

      doc.to_s
    end

  private

    KNOWN_COLORIZERS = [ :coderay, :dummy, :pygmentize, :simon_highlight ]

    def highlight(code, language, params={})
      colorizer = @colorizers[language.to_sym]
      if KNOWN_COLORIZERS.include?(colorizer)
        send(colorizer, code, language, params[colorizer] || {})
      else
        raise RuntimeError, "I don’t know how to highlight code using the “#{colorizer}” colorizer"
      end
    end

    def coderay(code, language, params={})
      require 'coderay'

      ::CodeRay.scan(code, language).html(params)
    end

    def dummy(code, language, params={})
      code
    end

    # Runs the content through [pygmentize](http://pygments.org/docs/cmdline/),
    # the commandline frontend for [Pygments](http://pygments.org/).
    #
    # @api private
    #
    # @param [String] code The code to colorize
    #
    # @param [String] language The language the code is written in
    #
    # @option params [String, Symbol] :encoding The encoding of the code block
    #
    # @return [String] The colorized output
    def pygmentize(code, language, params={})
      enc = ""
      enc = "-O encoding=" + params[:encoding] if params[:encoding]

      IO.popen("pygmentize -l #{language} -f html #{enc}", "r+") do |io|
        io.write(code)
        io.close_write
        highlighted_code = io.read

        doc = Nokogiri::HTML.fragment(highlighted_code)
        return doc.inner_html
      end
    end

    SIMON_HIGHLIGHT_OPT_MAP = {
        :wrap => '-W',
        :include_style => '-I',
        :line_numbers  => '-l',
    }

    def simon_highlight(code, language, params={})
      opts = []

      params.each do |key, value|
        if SIMON_HIGHLIGHT_OPT_MAP[key]
          opts << SIMON_HIGHLIGHT_OPT_MAP[key]
        else
          # TODO allow passing other options
          case key
          when :style
            opts << "--style #{params[:style]}"
          end
        end
      end

      commandline = "highlight --syntax #{language} --fragment #{opts.join(" ")} /dev/stdin" 
      IO.popen(commandline, "r+") do |io|
        io.write(code)
        io.close_write
        return io.read
      end
    end
  end
end
