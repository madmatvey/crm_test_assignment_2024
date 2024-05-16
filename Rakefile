# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  task audit: :environment do
    require 'bundler/audit/cli'
    Bundler::Audit::CLI.start %w[update]
    Bundler::Audit::CLI.start %w[check]
  end
end
