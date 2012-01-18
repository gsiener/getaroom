require 'curb'
require 'nokogiri'

module GetARoom
  class Base
      def initialize(email, password)
        @email = email
        @password = password
        login
      end

      def finalize
        logout
      end

      def logged_in?
        return true
      end

      def login
        @curb = Curl::Easy.new('http://ga.getaroomapp.com/login')
        @curb.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2"
        @curb.follow_location = true
        @curb.enable_cookies = true
        #@curb.verbose = true
        @curb.perform

        @curb.http_post([
          Curl::PostField.content('email', @email),
          Curl::PostField.content('password', @password)
        ])
        raise("Could not login to service!") if @curb.response_code != 200

        @curb
      end

      def logout
        @curb.url = "http://ga.getaroomapp.com/logout"
        @curb.perform
        @curb = nil
      end

  end
end