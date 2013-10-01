# rapgenius

![Rap Genius logo](http://f.cl.ly/items/303W0c1i2r100j2u3Y0y/Screen%20Shot%202013-08-17%20at%2016.01.19.png)

## What does this do?

It's a Ruby gem for accessing lyrics and explanations on
[Rap Genius](http://rapgenius.com). 

They very sadly [don't have an API](https://twitter.com/RapGenius/status/245057326321655808) so I decided to replicate one for myself
with a nice bit of screen scraping with [Nokogiri](https://github.com/sparklemotion/nokogiri), much like my [amex](https://github.com/timrogers/amex), [ucas](https://github.com/timrogers/ucas) and [lloydstsb](https://github.com/timrogers/lloydstsb) gems.

## Installation

Install the gem, and you're ready to go. Simply add the following to your
Gemfile:

`gem "rapgenius", "~> 0.1.0"`

## Usage

Songs on Rap Genius don't have numeric identifiers as far as I can tell - they're identified by a URL slug featuring the artist and song name, for instance "Big-sean-control-lyrics". We use this to fetch a particular track, like so:

```ruby
require 'rapgenius'
song = RapGenius::Song.find("Big-sean-control-lyrics")
```

Once you've got the song, you can easily load details about it. This uses
Nokogiri to fetch the song's page and then parse it:

```ruby
song.title
# => "Control"

song.artist
# => "Big Sean"

song.full_artist
# => "Big Sean (Ft. Jay Electronica & Kendrick Lamar)"

song.images
# => ["http://s3.amazonaws.com/rapgenius/1376434983_jay-electronica.jpg", "http://s3.amazonaws.com/rapgenius/1375029260_Big%20Sean.png", "http://s3.amazonaws.com/rapgenius/Kendrick-Lamar-1024x680.jpg"]

song.description
# => "The non-album cut from Sean that basically blew up the Internet due to a world-beating verse by Kendrick Lamar...
```

### Lyrics and Annotations

You can get the full lyrics of a song by calling `#lyrics`.

```ruby
song.lyrics[0...10]
# => ["[Produced by No I.D.]",
#  "",
#  "[Intro: Big Sean]",
#  "I look up",
#  "Yeah and I take my time, nigga",
#  "I'mma take my time, whoa",
#  "Power moves only, nigga",
#  "",
#  "[Verse 1: Big Sean]",
#  "Boy I'm 'bout my business on business, I drink liquor on liquor"]
# =>
```

You can check each lyric individually to see if it's annotated, and then fetch the annotation.

```ruby
song.lyrics[0].annotated?
# => true

song.lyrics[0].annotation
# => #<RapGenius::Annotation>
```

Call `#annotations` to return *just* those lyrics having annotations.

```ruby
song.annotations
# => [#<RapGenius::Annotation>, #<RapGenius::Annotation>, ...]

annotation = song.annotations[99]

annotation.lyric
# => "And that goes for Jermaine Cole, Big KRIT, Wale\nPusha T, Meek Millz, A$AP Rocky, Drake\nBig Sean, Jay Electron', Tyler, Mac Miller"

annotation.explanation
# => "Kendrick calls out some of the biggest names in present day Hip-hop...""

# You can get back to the song from the annotation...
annotation.song == song
# => true

annotation.id
# => "2093001"

# Find an annotation directly by ID
annotation2 = RapGenius::Annotation.find("2093001")

annotation == annotation2
# => true
```

### Searching

You can search for songs by artist and/or title.

```ruby
results = RapGenius::Song.search("Big Sean Control")
# => [#<RapGenius::Song>, #<RapGenius::Song>, ...]

results[0].description
# => "The non-album cut from Sean that basically blew up the Internet due to a world-beating verse by Kendrick Lamar..."
```

## Contributing

After the last few contributions, there's one core thing I'd like to add to the gem:

* __Support for *\*Genius*__ - Rap Genius also have other sites on subdomains like [News Genius](http://news.rapgenius.com) and [Poetry Genius](http://poetry.rapgenius.com). These could very easily be supported, since theyre identical in terms of markup.

If you'd like to contribute anything else, go ahead or better still, make an issue and we can talk it over and spec it out! A few quick tips:

* Don't update the version numbers before your pull request - I'll sort that part out for you!
* Make sure you write specs, then run them with `$ bundle exec rake`
* Update this README.md file so I, and users, know how your changes work

## Copyright

Copyright (c) 2013 Tim Rogers. See LICENSE for details.

## Get in touch

[timrogers](https://github.com/timrogers) and [tsigo](https://github.com/tsigo) are the gem's primary contributors.

Any questions, thoughts or comments? Email me at <me+rapgenius@timrogers.co.uk> or create an issue.
