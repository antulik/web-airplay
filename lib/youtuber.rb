require 'net/http'
require 'rack'

class Youtuber

  def initialize url
    @url = url
  end

  def info
    @info ||= fetch_info video_id
  end

  def get_urls
    url_params = info["url_encoded_fmt_stream_map"].split(',')

    url_params.map! do |param|
      Rack::Utils.parse_nested_query param
    end

    url_params.map do |param|
      param['url'] = param['url'] + "&signature=#{param['sig']}"

      param
    end
  end

  def urls_playable_by_airplay
    get_urls.select do |hash|
      hash['type'].include? "video/mp4"
    end
  end

  def airplay_link
    links = urls_playable_by_airplay
    qualities = links.group_by { |h| h['quality'] }

    hash_list = qualities['hd720'] || qualities['medium'] || qualities['small'] || links
    hash = hash_list.first
    hash['url'] if hash
  end

  def video_info_url id
    "http://www.youtube.com/get_video_info?video_id=#{id}&asv=3&el=detailpage&hl=en_US"
  end

  def fetch_info video_id
    url = video_info_url video_id
    uri = URI.parse url
    result = Net::HTTP.get(uri)

    Rack::Utils.parse_nested_query(result)
  end

  def video_id
    query_hash = Rack::Utils.parse_query URI(@url).query
    query_hash['v']
  end

end
