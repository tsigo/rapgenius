# encoding: utf-8
module RapGenius
  class Song
    include RapGenius::Scraper

    def self.find(path)
      self.new(path)
    end

    # Search for a song
    #
    # query - Song to search for
    #
    # Returns an Array of Song objects.
    def self.search(query)
      results = Client.search(query)

      results.split("\n").map do |song|
        info, link, id = song.split('|')
        artist, title  = info.force_encoding('UTF-8').split(' – ')

        new(link, artist: artist, title: title)
      end
    end

    def initialize(path, kwargs = {})
      self.url = path

      @artist = kwargs.delete(:artist)
      @title  = kwargs.delete(:title)
    end

    def artist
      @artist ||= document.css('.song_title a').text
    end

    def title
      @title ||= document.css('.edit_song_description i').text
    end

    def description
      document.css('.description_body').text
    end

    def images
      document.css('meta[property="og:image"]').
        map { |meta| meta.attr('content') }
    end

    def full_artist
      document.css('meta[property="og:title"]').attr('content').to_s.
        split(" – ").first
    end

    # Get all lyrics for this song
    #
    # Returns an Array of Lyric objects
    def lyrics
      @lyrics ||= document.css('.lyrics').inner_html.split(/<br\/?>/).map do |line|
        Lyric.new(line.strip)
      end
    end

    # Get all annotated lyrics for this song
    #
    # Returns an Array of Annotation objects
    def annotations
      # Get only annotated lyrics, then map them to actual Annotation objects
      lyrics.select { |l| l.annotated? }.map(&:annotation)
    end
  end
end
