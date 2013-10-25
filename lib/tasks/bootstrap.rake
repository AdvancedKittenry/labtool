    namespace :bootstrap do
      desc "Add the default user"
      task :default_user => :environment do
        User.create :forename=> 'Testi', :surename=> 'Kayttaja', :student_number => "000000007", :email => "admin@admin.admin", :password => "admin"
        # Hack to make the first user admin
        admin = User.find(1)
        admin.admin = true
        admin.save
      end

      desc "Create the default course"
      task :default_course => :environment do
        Course.create :year=>2013, :period=>"Fall I", :active => true, :week=>1, :weeks_total => 6, :reviews_total => 2, :review_round => 1
      end

      desc "Run all bootstrapping tasks"
      task :all => [:default_user, :default_course]
    end
