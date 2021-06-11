require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Spree
  module Stripe
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Rails::Generators::Migration

        class_option :auto_run_migrations, type: :boolean, default: false

        source_root File.expand_path("templates", __dir__)

        def self.next_migration_number(path)
          ActiveRecord::Generators::Base.next_migration_number(path)
        end

        def create_migrations
          migration_template "create_stripe_payment_sources.rb", "db/migrate/create_stripe_payment_sources.rb", migration_version: migration_version
          migration_template "add_stripe_customer_id_to_user.rb", "db/migrate/add_stripe_customer_id_to_user.rb", migration_version: migration_version
        end

        def run_migrations
          run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
          if run_migrations
            run 'bundle exec rake db:migrate'
          else
            puts 'Skipping rake db:migrate, don\'t forget to run it!'
          end
        end

        private
  
        def migration_version
          "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]" if ActiveRecord.version.version > "5"
        end
      end
    end
  end
end
  