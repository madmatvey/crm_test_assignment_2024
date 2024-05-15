# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        companies = Company.all.order(created_at: :desc)
        render json: companies.as_json(include: :deals)
      end
    end
  end
end
