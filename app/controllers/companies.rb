# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    route('companies') do |routing|
      # @comp_route = "#{@api_root}/companies"

      routing.on String do |company_id|
        routing.on 'internships' do
          # @internship_route = "#{@comp_route}/#{company_id}/internships"

          # GET api/v1/companies/[company_id]/internships/[internship_id]
          # routing.get String do |internship_id|
          #   internship_post = Internship.where(company_id: company_id, id: internship_id).first
          #   internship_post ? internship_post.to_json : raise('internship post not found')
          # rescue StandardError => e
          #   routing.halt 404, { message: e.message }.to_json
          # end

          # GET api/v1/companies/[company_id]/internships
          routing.get do
            company = Company.first(id: company_id)
            internships = Internship.where(company_name: company.name).all
            JSON.pretty_generate(data: internships)
          rescue StandardError
            routing.halt 404, { message: 'Could not find internship posts' }.to_json
          end

          # # POST api/v1/companies/[company_id]/internships
          # routing.post do
          #   new_data = JSON.parse(routing.body.read)
          #   new_internship = CreateInternshipForCompany.call(company_id: company_id, internship_data: new_data)
          #   raise 'Could not save internship post' unless new_internship

          #   response.status = 201
          #   response['Location'] = "#{@internship_route}/#{new_internship.id}"
          #   { message: 'Internship Post saved', data: new_internship }.to_json
          # rescue Sequel::MassAssignmentRestriction
          #   Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
          #   routing.halt 400, { message: 'Illegal Attributes' }.to_json
          # rescue StandardError => e
          #   routing.halt 500, { message: e.message }.to_json
          # end
        end

        routing.on 'interviews' do
          # @interview_route = "#{@comp_route}/#{company_id}/interviews"

          # GET api/v1/companies/[company_id]/interviews/[interview_id]
          # routing.get String do |interview_id|
          #   interview_post = Interview.where(company_id: company_id, id: interview_id).first
          #   interview_post ? interview_post.to_json : raise('interview post not found')
          # rescue StandardError => e
          #   routing.halt 404, { message: e.message }.to_json
          # end

          # GET api/v1/companies/[company_id]/interviews
          routing.get do
            company = Company.first(id: company_id)
            interviews = Interview.where(company_name: company.name).all
            JSON.pretty_generate(data: interviews)
          rescue StandardError
            routing.halt 404, { message: 'Could not find interview posts' }.to_json
          end

          # # POST api/v1/companies/[company_id]/interviews
          # routing.post do
          #   new_data = JSON.parse(routing.body.read)
          #   new_interview = CreateInterviewForCompany.call( company_id: company_id, interview_data: new_data)
          #   raise 'Could not save interview' unless new_interview

          #   response.status = 201
          #   response['Location'] = "#{@interview_route}/#{new_interview.id}"
          #   { message: 'Interview Post saved', data: new_interview }.to_json
          # rescue Sequel::MassAssignmentRestriction
          #   Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
          #   routing.halt 400, { message: 'Illegal Attributes' }.to_json
          # rescue StandardError => e
          #   routing.halt 500, { message: e.message }.to_json
          # end
        end

        # routing.on 'interns' do
        #   @interns_route = "#{@comp_route}/#{company_id}/interns"

        #   # GET api/v1/companies/[company_id]/interns
        #   routing.get do
        #     output = { data: Company.first(id: company_id).interns }
        #     JSON.pretty_generate(output)
        #   rescue StandardError
        #     routing.halt 404, { message: 'Could not find interns' }.to_json
        #   end

        #   # POST api/v1/companies/[company_id]/interns
        #   routing.post do
        #     new_data = JSON.parse(routing.body.read)
        #     company = Company.first(id: company_id)
        #     new_intern = company.add_intern(new_data)
        #     raise 'Could not save intern' unless new_intern

        #     response.status = 201
        #     response['Location'] = "#{@interns_route}"
        #     { message: 'Internsaved', data: new_intern }.to_json
        #   rescue Sequel::MassAssignmentRestriction
        #     Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
        #     routing.halt 400, { message: 'Illegal Attributes' }.to_json
        #   rescue StandardError => e
        #     routing.halt 500, { message: e.message }.to_json
        #   end
        # end

        # GET api/v1/companies/[company_id]
        routing.get do
          company = Company.first(id: company_id)
          company ? company.to_json : raise('Company not found')
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end
      end

      # GET api/v1/companies
      routing.get do
        output = { data: Company.all }
        JSON.pretty_generate(output)
      rescue StandardError
        routing.halt 404, { message: 'Could not find companies' }.to_json
      end

      # POST api/v1/companies
      routing.post do
        company_no = JSON.parse(routing.body.read)
        new_company = SearchCompany.call(company_no['company_no'])

        raise('Could not save company') unless new_company

        response.status = 201

        response['Location'] = "#{@company_route}/#{new_company.id}"
        { message: 'Company saved', data: new_company }.to_json

      rescue StandardError => e
        routing.halt 400, { message: e.message }.to_json
      end
    end
  end
end
