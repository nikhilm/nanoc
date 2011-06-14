# encoding: utf-8

module Nanoc3::StringExtensions

  # Transforms string into an actual identifier
  #
  # @return [String] The identifier generated from the receiver
  def cleaned_identifier
    "/#{self}/".gsub(/^\/+|\/+$/, '/')
  end

  # Replaces Unicode characters with their ASCII decompositions if the
  # environment does not support Unicode.
  #
  # This method is not suited for general usage. If you need similar
  # functionality, consider using the Iconv library instead.
  #
  # @return [String] The decomposed string
  def make_compatible_with_env
    # Check whether environment supports Unicode
    # FIXME this is ugly, and there most likely are better ways to do this
    is_unicode_supported = %w( LC_ALL LC_CTYPE LANG ).any? { |e| ENV[e] =~ /UTF/ }
    return self if is_unicode_supported

    # Decompose if necessary
    # FIXME this decomposition is not generally usable
    self.gsub(/“|”/, '"').gsub(/‘|’/, '\'').gsub('…', '...')
  end

  # Calculates the checksum for this string. Any change to this string will
  # result in a different checksum.
  #
  # @return [String] The checksum for this string
  #
  # @api private
  def checksum
    digest = Digest::SHA1.new
    digest.update(self)
    digest.hexdigest
  end

end

class String
  include Nanoc3::StringExtensions
end
