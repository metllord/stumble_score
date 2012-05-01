require File.expand_path(File.join('..', 'stumble_score'), __FILE__)

class CLI

  def self.run(address="")
    if address != ""
        location = StumbleScore::Location.new(address)
         "Welcome to StumbleScore\n"
         "Calculating StumbleScore for: #{address}"
         "Bar count: #{location.bar_count}"
         "StumbleScore: #{location.score}"
         "Classified as: #{location.classification}"
         location.bar_names.class
    else
        "usage: Enter an address after the command."
        "EX: stumblescore 19078"
    end
  end

end
