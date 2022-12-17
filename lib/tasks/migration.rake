desc 'run user migration first'
task :first_migration do
  ActiveRecord::Migrator.new(:up,
                             [ActiveRecord::MigrationProxy.new('CreateUsers', nil , 'db/migrate/20220915063806_create_users.rb', '')], ActiveRecord::SchemaMigration, nil).run
end
