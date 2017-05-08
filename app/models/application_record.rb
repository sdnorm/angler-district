class ApplicationRecord < ActiveRecord::Base

  require 'net/http'
  require 'uri'
  require 'openssl'

  self.abstract_class = true

end
