require 'webrick'
require 'mime/types'

module Nanoc

  class AutoCompiler

    ERROR_404 = <<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>404 File Not Found</title>
		<style type="text/css">
			body { padding: 10px; border: 10px solid #f00; margin: 10px; font-family: Helvetica, Arial, sans-serif; }
		</style>
	</head>
	<body>
		<h1>404 File Not Found</h1>
		<p>The file you requested, <i><%=h path %></i>, was not found on this server.</p>
	</body>
</html>
END

    ERROR_500 = <<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>500 Server Error</title>
		<style type="text/css">
			body { padding: 10px; border: 10px solid #f00; margin: 10px; font-family: Helvetica, Arial, sans-serif; }
		</style>
	</head>
	<body>
		<h1>500 Server Error</h1>
		<p>An error occurred while compiling the page you requested, <i><%=h path %></i>.</p>
		<p><%=h exception.message %></p>
		<ol>
<% exception.backtrace.each do |line| %>
			<li><%= line %></li>
<% end %>
		</ol>
	</body>
</html>
END

    def initialize(site)
      # Set site
      @site = site
    end

    def start
      # Create server
      @server = WEBrick::HTTPServer.new(:Port => 8083)
      @server.mount_proc("/") { |request, response| handle_request(request, response) }

      # Start server
      trap('INT') { @server.shutdown }
      @server.start
    end

    def handle_request(request, response)
      # Reload site data
      @site.load_data(:force => true)

      # Get page or file
      page      = @site.pages.find { |page| page.path == request.path }
      file_path = @site.config[:output_dir] + request.path

      if page.nil?
        # Serve file
        if File.exist?(file_path)
          serve_file(file_path, response)
        else
          serve_404(request.path, response)
        end
      else
        # Serve page
        serve_page(page, response)
      end
    end

    def h(s)
      ERB::Util.html_escape(s)
    end

    def serve_404(path, response)
      response.status           = 404
      response['Content-Type']  = 'text/html'
      response.body             = ERB.new(ERROR_404).result(binding)
    end

    def serve_500(path, exception, response)
      response.status           = 500
      response['Content-Type']  = 'text/html'
      response.body             = ERB.new(ERROR_500).result(binding)
    end

    def serve_file(path, response)
      response.status           = 200
      response['Content-Type']  = MIME::Types.of(path).first || 'application/octet-stream'
      response.body             = File.read(path)
    end

    def serve_page(page, response)
      # Recompile page
      begin
        @site.compiler.run(page)
      rescue => exception
        serve_500(page.path, exception, response)
        return
      end

      response.status           = 200
      response['Content-Type']  = 'text/html'
      response.body             = page.layouted_content
    end

  end

end
