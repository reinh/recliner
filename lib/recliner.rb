require 'forwardable'
require 'rubygems'
require 'json'
require 'restclient'

module Recliner

  class Database
    def self.count( url); new(url).count  end
    def self.create(url); new(url).create end
    def self.delete(url); new(url).delete end

    def initialize(url)
      @resource = Resource.new(url)
    end

    def count
      @resource.get["doc_count"]
    end

    def create
      @resource.put ''
    end

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
