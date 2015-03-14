module Airplay
  class << self
    def clear_browser
      @_browser = nil
    end
  end
end

module Airplay
  module Playable
    def player
      @supervisor ||= Airplay::Player.supervise self
      @_player ||= @supervisor.actors.first
    end

    def supervisor
      @supervisor
    end
  end
end
