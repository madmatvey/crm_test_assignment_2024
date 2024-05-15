# frozen_string_literal: true

module Companies
  class Finder
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call # rubocop:disable Metrics/AbcSize
      companies = Company.all

      companies = minimum_deal_amount_companies(minimum_deal_amount) if minimum_deal_amount.present?
      companies = companies.by_name(name) if name.present?
      companies = companies.by_industry(industry) if industry.present?
      # If I had more time, I would move Industry to a separate model, belongs_to Company
      # (or with polymorphic relation if Industry can be not only Companies,
      # but for example Vendors and so on),
      # make a separate endpoint to get the list of industries on the frontend
      # and redo the filter to search for industry matches by the ID of the related entity;

      companies = companies.where('employee_count >= ?', min_employee) if min_employee.present?
      companies
    end

    private

    attr_reader :params

    def name
      params[:name]
    end

    def industry
      params[:industry]
    end

    def min_employee
      params[:min_employee]
    end

    def minimum_deal_amount
      params[:minimum_deal_amount]
    end

    def minimum_deal_amount_companies(minimum_deal_amount)
      sql = <<~SQL
        select
          companies.*
        from companies
        left join deals on deals.company_id=companies.id
        group by companies.id
        having COALESCE(sum(deals.amount),0) >= #{minimum_deal_amount}
      SQL
      Company.select('*').from("(#{sql}) AS companies")
    end
  end
end
