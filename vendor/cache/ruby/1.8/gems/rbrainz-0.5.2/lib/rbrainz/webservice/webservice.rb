# $Id: webservice.rb 319 2011-04-19 20:49:49Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/includes'
require 'rbrainz/webservice/filter'
require 'net/http'
require 'stringio'

module MusicBrainz
  module Webservice

    # An interface all concrete web service classes have to implement.
    # 
    # All web service classes have to implement this and follow the method
    # specifications.
    class IWebservice
      
      # Query the web service.
      # 
      # This method must be implemented by the concrete webservices and
      # should return an IO object on success.
      # 
      # Options:
      # [:id]      A MBID if querying for a single ressource.
      # [:include] An include object (see AbstractIncludes).
      # [:filter]  A filter object (see AbstractFilter).
      # [:version] The version of the webservice to use. Defaults to 1.
      def get(entity_type, options={ :id=>nil, :include=>nil, :filter=>nil, :version=>1 })
        raise NotImplementedError.new('Called abstract method.')
      end
      
      # Submit data to the web service.
      #
      # This method must be implemented by the concrete webservices and
      # should return an IO object on success.
      # 
      # Options:
      # [:id]      A MBID if querying for a single ressource.
      # [:params]  A Hash or Array containing the data to post as key/value pairs.
      # [:version] The version of the webservice to use. Defaults to 1.
      def post(entity_type, options={ :id=>nil, :params=>[], :version=>1 })
        raise NotImplementedError.new('Called abstract method.')
      end
      
    end
    
    # An interface to the MusicBrainz XML web service via HTTP.
    # 
    # By default, this class uses the MusicBrainz server but may be configured
    # for accessing other servers as well using the constructor. This implements
    # IWebService, so additional documentation on method parameters can be found
    # there.
    class Webservice < IWebservice
    
      # Timeouts for opening and reading connections (in seconds)
      attr_accessor :open_timeout, :read_timeout
    
      # If no options are given the default MusicBrainz webservice will be used.
      # User authentication with username and password is only needed for some
      # services. If you want to query an alternative webservice you can do so
      # by setting the appropriate options.
      # 
      # Available options:
      # [:host] Host, defaults to 'musicbrainz.org'.
      # [:port] Port, defaults to 80.
      # [:path_prefix] The path prefix under which the webservice is located on
      #                the server. Defaults to '/ws'.
      # [:username] The username to authenticate with.
      # [:password] The password to authenticate with.
      # [:user_agent] Value sent in the User-Agent HTTP header. Defaults to "rbrainz/#{RBRAINZ_VERSION}"
      # [:proxy] URI for the proxy server to connect through
      def initialize(options={ :host=>nil, :port=>nil, :path_prefix=>'/ws', :username=>nil, :password=>nil, :user_agent=>"rbrainz/#{RBRAINZ_VERSION}", :proxy=>nil })
        Utils.check_options options, :host, :port, :path_prefix, :username, :password, :user_agent, :proxy
        @host = options[:host] ? options[:host] : 'musicbrainz.org'
        @port = options[:port] ? options[:port] : 80
        @path_prefix = options[:path_prefix] ? options[:path_prefix] : '/ws'
        @username = options[:username]
        @password = options[:password]
        @user_agent = options[:user_agent] ? options[:user_agent] : "rbrainz/#{RBRAINZ_VERSION}"
        @open_timeout = nil
        @read_timeout = nil
        set_proxy_options(options)
      end
    
      # Query the Webservice with HTTP GET.
      # 
      # Returns an IO object on success.
      # 
      # Options:
      # [:id]      A MBID if querying for a single ressource.
      # [:include] An include object (see AbstractIncludes).
      # [:filter]  A filter object (see AbstractFilter).
      # [:version] The version of the webservice to use. Defaults to 1.
      # 
      # Raises:: RequestError, ResourceNotFoundError, AuthenticationError,
      #          ConnectionError 
      # See:: IWebservice#get
      def get(entity_type, options={ :id=>nil, :include=>nil, :filter=>nil, :version=>1 })
        Utils.check_options options, :id, :include, :filter, :version
        uri = create_uri(entity_type, options)
        response = open_connection_and_make_request(uri, :get)
        return response
      end
      
      # Send data to the web service via HTTP-POST.
      #
      # Note that this may require authentication. You can set
      # user name, password and realm in the constructor.
      #
      # Returns an IO object on success.
      #
      # Options:
      # [:id]      A MBID if querying for a single ressource.
      # [:params]  A Hash or Array containing the data to post as key/value pairs.
      # [:version] The version of the webservice to use. Defaults to 1.
      #
      # Raises:: ConnectionError, RequestError, AuthenticationError, 
      #          ResourceNotFoundError
      #
      # See:: IWebservice#post
      def post(entity_type, options={ :id=>nil, :params=>[], :version=>1 })
        Utils.check_options options, :id, :params, :version
        uri = create_uri(entity_type, options)
        response = open_connection_and_make_request(uri, :post, options[:params])
        return response
      end
      
      private # ----------------------------------------------------------------
      
      def set_proxy_options(options)
        @proxy = {}
        unless options[:proxy].nil?
          uri = URI.parse( options[:proxy] )
          @proxy[:host], @proxy[:port] = uri.host, uri.port
          if uri.userinfo
            @proxy[:username], @proxy[:password] = uri.userinfo.split(/:/)
          end
        end
      end
      
      # Builds a request URI for querying the webservice.
      def create_uri(entity_type, options = {:id=>nil, :include=>nil, :filter=>nil, :version=>1, :type=>'xml'})
        # Make sure the version is set
        options[:version] = 1 if options[:version].nil?
        options[:type] = 'xml' if options[:type].nil?
        uri = build_uri_without_querystring(entity_type, options)
        uri = append_querystring_to_uri(uri, options)
        return URI.parse(uri)
      end
      
      def build_uri_without_querystring(entity_type, options)
        entity_type = Utils.entity_type_to_string(entity_type)
        if options[:id]
          # Make sure the id is a MBID object
          id = options[:id]
          unless id.is_a? Model::MBID
            id = Model::MBID.parse(id, entity_type)
          end
        
          uri = 'http://%s:%d%s/%d/%s/%s' %
                [@host, @port, @path_prefix, options[:version], entity_type, id.uuid]
        else
          uri = 'http://%s:%d%s/%d/%s/' %
                [@host, @port, @path_prefix, options[:version], entity_type]
        end
        return uri
      end
      
      def append_querystring_to_uri(uri, options)
        querystring = []
        querystring << 'type=' + CGI.escape(options[:type]) unless options[:type].nil?
        querystring << options[:include].to_s unless options[:include].nil?
        querystring << options[:filter].to_s unless options[:filter].nil?
        uri += '?' + querystring.join('&') unless querystring.empty? 
      end
      
      def open_connection_and_make_request(uri, request_type, form_data=nil)
        connection = create_connection(uri)
        response = make_request(connection, uri, request_type, form_data)
        handle_response_errors(uri, response)
        return ::StringIO.new(response.body)  
      end
      
      def create_connection(uri)
        connection = Net::HTTP.new(uri.host, uri.port, @proxy[:host], @proxy[:port])
        #connection.set_debug_output $stderr
        set_connection_timeouts(connection)
        return connection
      end
      
      def make_request(connection, uri, request_type, form_data=nil)
        response = nil
        begin
          connection.start do |http|
            request = create_request(uri, request_type, form_data)
            response = http.request(request)
            if response.is_a?(Net::HTTPProxyAuthenticationRequired) && @proxy[:username] && @proxy[:password]
              request = create_request(uri, request_type, form_data)
              request.proxy_select_auth(@proxy[:username], @proxy[:password], response)
              response = http.request(request)
            end

            if response.is_a?(Net::HTTPUnauthorized) && @username && @password
              request = create_request(uri, request_type, form_data)
              request.select_auth @username, @password, response
              response = http.request(request)
            end
            response
          end
        rescue Timeout::Error, Errno::ETIMEDOUT
          raise ConnectionError.new('%s timed out' % uri.to_s)
        rescue SocketError => e
          raise ConnectionError.new('%s (%s)' % [uri.to_s, e.to_s])
        rescue ::Exception => e
          raise ConnectionError.new(e.to_s) 
        end
        return response
      end
      
      def set_connection_timeouts(connection)
        connection.open_timeout = @open_timeout if @open_timeout
        connection.read_timeout = @read_timeout if @read_timeout
      end
      
      def create_request(uri, request_type, form_data=nil)
        if request_type == :post
          request = Net::HTTP::Post.new(uri.request_uri)
        else
          request = Net::HTTP::Get.new(uri.request_uri)
        end
        request['User-Agent'] = @user_agent
        request.set_form_data(form_data) unless form_data.nil?
        return request
      end
      
      # Handles response errors and raises appropriate exceptions
      def handle_response_errors(uri, response)
        if response.is_a? Net::HTTPBadRequest # 400
          raise RequestError.new(uri.to_s)
        elsif response.is_a? Net::HTTPUnauthorized # 401
          raise AuthenticationError.new(uri.to_s)
        elsif response.is_a? Net::HTTPNotFound # 404
          raise ResourceNotFoundError.new(uri.to_s)
        elsif response.is_a? Net::HTTPForbidden 
          raise AuthenticationError.new(uri.to_s)
        elsif not response.is_a? Net::HTTPSuccess
          raise ConnectionError.new(response.class.name)
        end
      end
    
    end
    
  end
end
