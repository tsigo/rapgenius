module RapGenius
  # Class representing a single lyric (line) from a Song
  #
  # A lyric may or may not have an associated Annotation to go along with it.
  class Lyric
    def initialize(line)
      @line = Nokogiri::HTML(line)
    end

    def to_s
      @line.text
    end

    def inspect
      # Return the line itself, surrounded by quotes, with any of its own
      # quotes escaped
      "\"#{to_s.gsub('"', '\"')}\""
    end

    # Checks if the current lyric has an annotation associated with it
    #
    # A lyric is considered annotated if it contains a link attribute
    def annotated?
      @line.css('a').length > 0
    end

    # Returns the lyric's corresponding Annotation object
    #
    # Returns nil if lyric is not annotated
    def annotation
      if annotated?
        Annotation.new(id: @line.css('a').attr('data-id').to_s)
      else
        nil
      end
    end
  end
end
