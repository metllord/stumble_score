require "rubygems"
require "net/https"
require "uri"
require "json"

module StumbleScore

  class Location
    GOOGLE_KEY    = "AIzaSyBBguetr1vq8s2LLvZNzm4M57YGYk_uzNc"
    RADIUS        = 2000 # (meters)
    CRITERIA      = URI.escape("bar|pub")
    MAGIC_NUMBER  = 20

    def initialize(address)
        @address = address
    end

    def bar_count
      self.bars.length
    end

    def score
      self.bars.length * 5.0 
    end

    def classification
      if self.score < 50.0
        "Dry"
      elsif self.score >= 50.0 and self.score < 100
        "Tipsy"
      else
        "Sloppy"
      end
    end

    def bar_names
       output = Array.new()
       self.bars.each do |place|
        output.push(place['name'])
      end
       output  
    end

    def cabs
       output = Array.new()
       self.designated_driver.each do |driver|
       output.push(driver['name'])
      end
       output 
     end
    def bars
      uri = URI::HTTPS.build({
        :host  => "maps.googleapis.com",
        :path  => "/maps/api/place/search/json",
        :query => "location=#{self.geocode}&" \
                  "radius=#{RADIUS}&" \
                  "keyword=#{URI.escape('bar|pub')}&" \
                  "sensor=false&" \
                  "key=#{GOOGLE_KEY}"
      })
      parsed = self.ask_the_google(uri)
      parsed["results"]
    end

    def designated_driver
         uri = URI::HTTPS.build({
        :host  => "maps.googleapis.com",
        :path  => "/maps/api/place/search/json",
        :query => "location=#{self.geocode}&" \
                  "radius=#{RADIUS}&" \
                  "keyword=#{URI.escape('taxi|cab')}&" \
                  "sensor=false&" \
                  "key=#{GOOGLE_KEY}"
      })
      parsed = self.ask_the_google(uri)
      parsed["results"]
    end
    def geocode
      raise "@address instance variable not set!" unless @address
      escaped_address = URI.escape(@address)
      uri = URI::HTTPS.build({
        :host  => "maps.googleapis.com",
        :path  => "/maps/api/geocode/json",
        :query => "address=#{escaped_address}&" \
                  "sensor=false"
      })
      parsed   = self.ask_the_google(uri)
      location = parsed["results"][0]["geometry"]["location"]
      "#{location["lat"]},#{location["lng"]}"
    end

    def ask_the_google(uri)
      session              = Net::HTTP.new(uri.host, uri.port)
      session.use_ssl      = true
      session.verify_mode  = OpenSSL::SSL::VERIFY_NONE
      #session.set_debug_output($stdout)
      request              = Net::HTTP::Get.new(uri.request_uri)
      response             = session.request(request)
      json                 = response.body
      JSON.parse(json)
    end

  end

end
