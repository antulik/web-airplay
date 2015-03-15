class Github

  def self.releases
    response = HTTParty.get('https://api.github.com/repos/antulik/web-airplay/releases')
    response.parsed_response.map(&Release.method(:new))
  end

  def self.latest_release
    releases.sort_by { |r| r['id'] }.last
  end

  class Release < OpenStruct

  end

end
