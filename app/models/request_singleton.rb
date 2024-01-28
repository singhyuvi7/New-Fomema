require 'singleton'

class RequestSingleton
  include Singleton
  attr_accessor :subdomain
end