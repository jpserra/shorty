require 'shorty/repositories/shorties_repository'
require 'faker'

module Shorty
  module Interactors
    class ShortcodeGenerator
      RANDOM_SHORTCODE_REGEX = ::Shorty.config[:random_shortcode_regex]

      attr_reader :shorties_repository
      attr_reader :generator

      def initialize(environment)
        @shorties_repository = environment[:shorties_repository]
        @generator = environment[:faker]
      end

      def call
        generate_unique_shortcode(random_shortcode)
      end

      def generate_unique_shortcode(shortcode)
        while shorties_repository.find_by_shortcode shortcode
          shortcode = random_shortcode
        end

        shortcode
      end

      def random_shortcode
        generator.regexify(RANDOM_SHORTCODE_REGEX)
      end
    end
  end
end
