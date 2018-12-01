# frozen_string_literal: true

module Knowledge
  #
  # === Description ===
  #
  # This is the namespace used to put the lib's adapters.
  # You can find the adapters by looking to the inclusions below or to the adapters folder.
  #
  module Adapters
  end
end

require 'knowledge/adapters/base'
require 'knowledge/adapters/environment'
require 'knowledge/adapters/key_value'
require 'knowledge/adapters/file'
