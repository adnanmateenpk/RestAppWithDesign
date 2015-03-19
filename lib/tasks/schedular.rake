desc "Heroku scheduler tasks"
task :reservation_expiry => :environment do
  puts "Check for expired Reservations."
  Reservation.expire_reservations
  puts "Success"
end