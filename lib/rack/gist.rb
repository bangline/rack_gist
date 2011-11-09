module Rack
  class Gist
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, @headers, response = @app.call(env)
      if html?
        parsed_response = ""
        response.each do |r|
          parsed_response = r.gsub(/(https:\/\/|)gist\.github\.com\/(\d+)/) do |gist|
            gist = "https://" + gist unless gist.start_with? "https://"
            "<script src=\"#{gist}.js\"></script>"
          end
        end
        response = [parsed_response]
        @headers['Content-Length'] &&= bytesize(parsed_response).to_s 
      end
      [status, @headers, response]
    end

    private

    def html?
      @headers["Content-Type"].include? "text/html"
    end
  end
end
