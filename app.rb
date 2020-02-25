# Set up for the application and database. DO NOT CHANGE. ###################
require "sinatra"                                                           #
require "sinatra/reloader" if development?                                  #
require "sequel"                                                            #
require "logger"                                                            #
require "twilio-ruby"                                                       #
DB ||= Sequel.connect "sqlite://#{Dir.pwd}/development.sqlite3"             #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                #
def view(template); erb template.to_sym; end                                #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret' #
before { puts "Parameters: #{params}" }                                     #
after { puts; }                                                             #
#############################################################################

events_table = DB.from(:events)
rsvps_table = DB.from(:rsvps)


get "/" do
    puts events_table.all
    @events = events_table.all
    #this creates a variable that is the array of hashes "events"
    view "events"
end


get "/events/:id" do
        #:id placeholder for actual event id
        #this is a definition of a url pattern that the application is looking for
    @event = events_table.where(id: params[:id]).first
        #to_s converts to string vs. ugly ruby version
        #first gives back first entry in array of Sequl SQLite table
        #now we have a hash. we grab its keys & values
    view "event"
        #want to show an "event" view, so have to create a new event.erb view file
end


get "events/:id/rsvps/new" do 
    #this is a form that's creating an RSVP for a specific event
    @event = events_table.where(id: params[:id]).first
    # this is how we get the event!
    view new_rsvp
end

