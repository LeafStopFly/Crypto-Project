# frozen_string_literal: true

module ISSInternship
  # Service object to create a new internship for an owner
  class CreateInternshipForOwner
    # Error for invalid account cannot add internship
    class ForbiddenError < StandardError
      def message
        'You are not allowed to add internship'
      end
    end

    def self.call(auth:, internship_data:)
      # internship data should be in db
      raise ForbiddenError unless auth[:scope].can_write?('internships')

      auth[:account].add_owned_internship(internship_data)
    end
  end
end
