# frozen_string_literal: true

module Notifications
  module Definitions
    class Registry
      class UnknownKindError < KeyError; end

      @map = {}

      class << self
        def register(kind, klass)
          @map[kind.to_sym] = klass
        end

        def fetch(kind)
          klass = @map[kind.to_sym]
          raise UnknownKindError, "Unknown notification kind: #{kind}" unless klass

          klass.new
        end

        def clear!
          @map = {}
        end
      end
    end
  end
end
