# frozen_string_literal: true

module Knowledge
  #
  # === Description
  #
  # This error class should be considered as the lib's standard error.
  # All error classes inherit from this one.
  # The goal is to be able to rescue Knowledge::Error outside the lib and catch them all.
  #
  # === Usage
  #
  # You have many examples behind. Just inherit from this class and it's ok.
  #
  # @example:
  #   class ::MyCustomKnowledgeError < Knowledge::Error; end
  #
  class Error < ::StandardError; end

  #
  # === Description
  #
  # This error is used when, at some point, we can't find the adapter we're looking for
  #
  class AdapterNotFound < Error; end

  #
  # === Description
  #
  # This error is used when an adapter has no #run method declared
  #
  class AdapterRunMethodNotImplemented < Error; end

  #
  # === Description
  #
  # This error is pretty generic and is meant to be used when we're not able to gather infos in order to set vars.
  #
  class LearnError < Error; end

  #
  # === Description
  #
  # This error is used when we fail registering an adapter.
  #
  class RegisterError < Error; end
end
