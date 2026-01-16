namespace :db do
  desc "Populate the database with sample data for demo"
  task setup_demo: :environment do
    if Rails.env.production?
      puts "ERROR: Cannot run demo setup in production!"
    else
      puts "Creating demo data..."
      o1 = Organization.find_or_create_by!(code: "demo1") do |organization|
        organization.name = "Demo Org 1"
        organization.description = "Demo Organizations 1"
      end
      o2 = Organization.find_or_create_by!(code: "demo2") do |organization|
        organization.name = "Demo Org 2"
        organization.description = "Demo Organizations 2"
      end
      o3 = Organization.find_or_create_by!(code: "demo3") do |organization|
        organization.name = "Demo Org 3"
        organization.description = "Demo Organizations 3"
      end

      u1 = User.find_or_create_by!(upn: "admin.user@example.com") do |user|
        user.email = "admin.user@example.com"
        user.surname = "ADMIN"
        user.name = "USER"
      end
      u2 = User.find_or_create_by!(upn: "simple.user@example.com") do |user|
        user.email = "simple.user@example.com"
        user.surname = "SIMPLE"
        user.name = "USER"
      end

      # u1 can admin o1 and unload in o2
      u1.permissions.find_or_create_by!(organization: o1) { |permission| permission.authlevel = 60 }
      u1.permissions.find_or_create_by!(organization: o2) { |permission| permission.authlevel = 40 }

      # u2 can only unload in o1
      u2.permissions.find_or_create_by!(organization: o1) { |permission| permission.authlevel = 40 }

      puts "Demo data loaded successfully."
      puts "Login with email admin.user@example.com to be an administrator and with simple.user@example.com to be a simple user than can unload"
    end
  end
end
