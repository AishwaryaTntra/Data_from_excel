namespace :db do
  namespace :migrate do
    desc 'Run db:migrate but ignore ActiveRecord::ConcurrentMigrationError errors'
    task ignore_concurrent: :environment do
      Rake::Task['first_migration'].invoke
    rescue ActiveRecord::ConcurrentMigrationError
      # Do nothing
    end
  end
end
