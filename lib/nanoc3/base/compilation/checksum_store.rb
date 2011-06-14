# encoding: utf-8

module Nanoc3

  # Stores checksums for objects in order to be able to detect whether a file
  # has changed since the last site compilation.
  #
  # @api private
  class ChecksumStore < ::Nanoc3::Store

    # @option params [Nanoc3::Site] site The site where this checksum store
    #   belongs to
    def initialize(params={})
      super('tmp/checksums', 1)

      @site = params[:site] if params.has_key?(:site)

      @checksums = {}
    end

    # Returns the old checksum for the given object. This makes sense for
    # items, layouts and code snippets.
    #
    # @param [#reference] obj The object for which to fetch the checksum
    #
    # @return [String] The checksum for the given object
    def [](obj)
      @checksums[obj.reference]
    end

    # Sets the checksum for the given object.
    #
    # @param [#reference] obj The object for which to set the checksum
    #
    # @param [String] checksum The checksum
    def []=(obj, checksum)
      @checksums[obj.reference] = checksum
    end

    # @see Nanoc3::Store#unload
    def unload
      @checksums = {}
    end

  protected

    def data
      @checksums
    end

    def data=(new_data)
      @checksums = new_data
    end

  end

end
