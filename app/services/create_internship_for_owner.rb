# frozen_string_literal: true

module ISSInternship
    # Service object to create a new project for an owner
    class CreateInternshipForOwner
        def self.call(owner_id:, internship_data:)
        Account.find(id: owner_id)
            .add_owned_internship(internship_data)
        end
    end
ends