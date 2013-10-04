module RapGenius
  class Annotation
    include RapGenius::Scraper

    attr_reader :id, :song

    def self.find(id)
      self.new(id: id)
    end

    def initialize(kwargs)
      @id = kwargs.delete(:id)
      @song = kwargs.delete(:song)
      @lyric = kwargs.delete(:lyric)
      self.url = @id
    end

    def lyric
      @lyric ||= meta_property('referent')
    end

    def explanation
      @explanation ||= meta_property('body')
    end

    def song
      @song ||= Song.new(song_url)
    end

    def song_url
      @song_url ||= meta_property('song')
    end

    private

    # Convenience method for fetching the contents of a RapGenius meta tag from
    # the document
    def meta_property(key)
      document.css("meta[property=\"rap_genius:#{key}\"]").attr('content').to_s
    end
  end
end
