require 'nanoc3/cli/commands/create_item'

# encoding: utf-8

module Nanoc3::CLI::Commands

  class CreateBlogEntry < CreateItem

    def name
      'create_entry'
    end

    def aliases
      [ 'cb' ]
    end

    def short_desc
      'create a blog entry item'
    end

    def long_desc
      'Create a new item in the blog folder of the current site. Sets attributes like date and title. The first data source in the site configuration will be used.'
    end

    def usage
      "nanoc3 create_entry [options] title"
    end

    def option_definitions
      [
        # --vcs
        {
          :long => 'vcs', :short => 'c', :argument => :required,
          :desc => 'select the VCS to use'
        }
      ]
    end

    def run(options, arguments)
      # Check arguments
      if arguments.length != 1
        $stderr.puts "usage: #{usage}"
        exit 1
      end

      title = arguments[0]

      arguments[0] = 'blog/' + arguments[0].downcase.gsub(/(\:|\?)/, ' ').split.join('-')

      ## This part is copied from original, but since
      ## we want a custom title we can't just use super

      # Extract arguments and options
      identifier = arguments[0].cleaned_identifier

      # Make sure we are in a nanoc site directory
      @base.require_site

      # Set VCS if possible
      @base.set_vcs(options[:vcs])

      # Check whether item is unique
      if !@base.site.items.find { |i| i.identifier == identifier }.nil?
        $stderr.puts "An item already exists at #{identifier}. Please " +
                     "pick a unique name for the item you are creating."
        exit 1
      end

      # Setup notifications
      Nanoc3::NotificationCenter.on(:file_created) do |file_path|
        Nanoc3::CLI::Logger.instance.file(:high, :create, file_path)
      end

      # Create item
      data_source = @base.site.data_sources[0]
      data_source.create_item(
        "",
        { :title => title,
          :author => "Nikhil Marathe",
          :kind => "blog_post",
          :created_at => Time.now.to_i,
          :tags => ['tag1'],
        },
        identifier,
        { :extension => '.md' }
      )

      puts "An item has been created at #{identifier}."
      ## Copy ends here
    end

  end

end
