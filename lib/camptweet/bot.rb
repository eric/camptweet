module Camptweet
  class Bot
    
    attr_accessor :twitter_users
    attr_accessor :campfire_subdomain
    attr_accessor :campfire_use_ssl    
    attr_accessor :campfire_room
    attr_accessor :campfire_email
    attr_accessor :campfire_password
    attr_accessor :verbose
    attr_reader   :twitter, :room
  
    def initialize(&block)
      yield self if block_given?
      @twitter = Twitter::Client.new
      unless @twitter
        log "Unable to establish connection to Twitter.  Exiting."
        exit
      end  
      log "Established connection to Twitter."
      
      campfire = Tinder::Campfire.new(campfire_subdomain, :ssl => campfire_use_ssl)
      unless campfire
        log "Unable to establish connection to Campfire (#{campfire_subdomain}).  Exiting."
        exit
      end
      log "Established connection to Campfire (#{campfire_subdomain})."
      
      unless campfire.login(campfire_email, campfire_password)
        log "Unable to log in to Campfire (#{campfire_subdomain}).  Exiting."
        exit
      end
      log "Logged in to Campfire (#{campfire_subdomain})."
      log "Available rooms: #{campfire.rooms.map(&:name).inspect}", :debug

      @room = campfire.find_room_by_name campfire_room
      if @room
        log "Entered Campfire room '#{room.name}'."
      else
        log "No room '#{campfire_room}' found.  Exiting."
        exit
      end
    end
  
    def run
      last_statuses = initial_statuses
      
      loop do
        begin
          new_statuses = []
          checking_twitter_timelines do |user, status|
            next if status.text == last_statuses[user]
            new_statuses << status
            last_statuses[user] = status.text
          end
                
          new_statuses.sort_by(&:created_at).each do |status|
            begin
              message = "[#{status.user.name}] #{status.text}"
              log message
              room.speak message
              log "(Campfire updated)", :debug
            rescue Timeout::Error => e
              log "Campfire timeout: (#{e.message})"
            ensure
              sleep 2
            end
          end
        rescue => e
          log e.message
          log e.backtrace
        end
        log "sleeping 10 seconds in main loop", :debug
        sleep 10
      end
    end
    
    def verbose?
      verbose
    end

    private
    
    def initial_statuses
      returning statuses = {} do
        checking_twitter_timelines do |user, status|
          statuses[user] = status.text
        end
      end
    end
    
    def checking_twitter_timelines
      twitter_users.each do |user|
        begin
          log "Checking '#{user}' timeline...", :debug
          twitter.timeline_for(:user, :id => user, :count => 1) do |status|
            yield user, status
          end
        rescue Timeout::Error => e
          log "Twitter timeout: (#{e.message})"
        rescue Twitter::RESTError => e
          log "Twitter REST Error: (#{e.message})"
        ensure
          log "   ...done.", :debug
          sleep 2
        end
      end
    end
  
    def log(msg, level=:info)
      if level == :info || (level == :debug && verbose?)
        puts "#{Time.now.strftime('%Y.%m.%d %H:%M:%S')} #{msg}"
      end
    end
  end
end