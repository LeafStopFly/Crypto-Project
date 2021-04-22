# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl'

module Internship
  STORE_DIR = 'app/db/store'

  # Holds a full secret post
  class Post
    # Create a new post by passing in hash of attributes
    def initialize(new_post)
      @id          = new_post['id'] || new_id
      @postname    = new_post['postname']
      @description = new_post['description']
      @content     = new_post['content']
    end

    attr_reader :id, :postname, :description, :content

    def to_json(options = {})
      JSON(
        {
          type: 'post',
          id: id,
          postname: postname,
          description: description,
          content: content
        },
        options
      )
    end

    # File store must be setup once when application runs
    def self.setup
      Dir.mkdir(Internship::STORE_DIR) unless Dir.exist? Internship::STORE_DIR
    end

    # Stores post in file store
    def save
      File.write("#{Internship::STORE_DIR}/#{id}.txt", to_json)
    end

    # Query method to find one post
    def self.find(find_id)
      post_file = File.read("#{Internship::STORE_DIR}/#{find_id}.txt")
      post.new JSON.parse(post_file)
    end

    # Query method to retrieve index of all posts
    def self.all
      Dir.glob("#{Internship::STORE_DIR}/*.txt").map do |file|
        file.match(%r{#{Regexp.quote(Internship::STORE_DIR)}\/(.*)\.txt})[1]
      end
    end

    private

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
