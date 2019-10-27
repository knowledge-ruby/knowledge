# frozen_string_literal: true

module Knowledge
  # Getters are used to get the data from where it is
  module Getters; end
end

require 'knowledge/getters/base'
require 'knowledge/getters/file'

require 'knowledge/getters/env'
require 'knowledge/getters/hash'
require 'knowledge/getters/json'
require 'knowledge/getters/yaml'
