require 'forwardable'
require 'rubygems'
require 'json'
require 'restclient'

module Recliner

  # Encapsulates the REST interface for a CouchDB database and its documents.
  class Database
    def self.count( url); new(url).count  end
    def self.delete(url); new(url).delete end

    # Creates a new database
    #
    # @return [Recliner::Database] the created database
    def self.create(url)
      db = new(url)
      db.create
      db
    end

    # Create a Database interface for the given url.
    #
    # #param [String] url the url of your couch database, including host
    def initialize(url)
      @resource = Resource.new(url)
    end

    # The number of documents
    def count
      @resource.get["doc_count"]
    end

    # Create the database
    def create
      @resource.put ''
    end

    # Delete the database
    def delete
      @resource.delete
    end

    def get(id)
      @resource[id].get
    end

    def post(data)
      @resource.post data.to_json, 'Content-Type' => 'application/json'
    end

  end

  class Resource < RestClient::Resource
    def delete(additional_headers={}, &block)
      Response.new super
    end

    def get(additional_headers={}, &block)
      Response.new super
    end

    def post(payload, additional_headers={}, &block)
      Response.new super
    end

    def put(payload, additional_headers={}, &block)
      Response.new super
    end
  end

  class Response
    extend Forwardable

    attr_reader :body
    def initialize(body)
      @body = body
      @hash = JSON.parse(body)
    end

    def_delegators :@hash, :[], :[]=
  end
end
