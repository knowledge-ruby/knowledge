# frozen_string_literal: true

module Knowledge
  #
  # === Description
  #
  # This is the namespace used to put the lib's setters.
  # You can find the setters by looking to the inclusions below or to the setters folder.
  #
  module Setters
    # == Behaviors =====================================================================================================
    extend Dry::Configurable

    # == Settings ======================================================================================================
    setting :default
  end
end

require 'knowledge/setters/base'
require 'knowledge/setters/knowledge'

Knowledge::Setters.config.default = Knowledge::Setters::Knowledge
