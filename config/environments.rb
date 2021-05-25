# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'sequel'
require './app/lib/secure_db'

module ISSInternship
  # Configuration for the API
  class Api < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    # def self.config() = Figaro.env
    def self.config()
      Figaro.env
    end
    # Logger setup
    LOGGER = Logger.new($stderr)
    # def self.logger() = LOGGER
    def self.logger()
      LOGGER
    end
    # Database Setup
    DB = Sequel.connect(ENV.delete('DATABASE_URL')+"?encoding=utf8")
    # DB = Sequel.mysql(database: ENV.delete('DATABASE_URL'), encoding: "utf8")
    # def self.DB() = DB # rubocop:disable Naming/MethodName
    def self.DB()
      DB
    end
    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
      
    end
  end
end
