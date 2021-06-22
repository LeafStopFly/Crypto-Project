# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'sequel'
require_app('lib')

module ISSInternship
  # Configuration for the API
  class Api < Roda
    plugin :environments

    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config()
        Figaro.env
      end

      # Logger setup
      LOGGER = Logger.new($stderr)
      def self.logger()
        LOGGER
      end

      # Database Setup
      DB = Sequel.connect(ENV.delete('DATABASE_URL') + '?encoding=utf8')
      def self.DB()
        DB
      end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock

    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
    end

    configure do
      SecureDB.setup(ENV.delete('DB_KEY')) # Load crypto keys
      AuthToken.setup(ENV.delete('MSG_KEY')) # Load crypto keys
    end
  end
end
