#!/usr/bin/env ruby
require_relative 'contact'
require 'csv'
require 'colorize'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  def initialize
    puts "Here is a list of available commands: "
    puts "new             - Create a new contact"
    puts "list            - List all contacts"
    puts "show            - shows a contact"
    puts "search          - Search contacts"
  end

end

# ContactList.new.main


# This should go to main
case
when ARGV.empty?
  ContactList.new
when ARGV[0] == "list"
  puts "--------------------------------------------------".colorize(:blue)
  puts "Here is a list of all the people in your contacts".colorize(:blue)
  puts "--------------------------------------------------".colorize(:blue)
  Contact.all

  puts "--------------------------------------------------".colorize(:blue)
  puts Contact.count.to_s.colorize(:blue) + " people are currently in your contact list.".colorize(:blue)
  puts "--------------------------------------------------".colorize(:blue)
when ARGV[0] == "show"
  Contact.find(ARGV[1].to_i)
when ARGV[0] == "new"
  puts "What is your full name?".colorize(:red)
  name = STDIN.gets.chomp.downcase
  puts "What is your email address?".colorize(:red)
  email = STDIN.gets.chomp
  puts "Did you have a phone number you wanted to add?"
  answer = STDIN.gets.chomp 
  if answer == "yes"
    @numbers = []
    loop do
      puts "What is your phone number?"
      phone_number = STDIN.gets.gsub(' ', '').to_i
      puts "What sort of phone is this for?"
      phone_type = STDIN.gets.chomp
      puts "Any more phone numbers to add?"
      any_more = STDIN.gets.chomp
      @numbers << [phone_number, phone_type]
      if any_more == "no"
        break
      end
    end
  end
  Contact.create(name, email, @numbers)
when ARGV[0] == "search"
  # Contact.search(ARGV[1])
  contact = Contact.search(ARGV[1])
  if contact == nil
    puts "No one was found with the name #{ARGV[1]}"
  end
else
  puts "'#{ARGV}' is an invalid input, please try again."
end




# case ARGV[0]
#   when nil
#     ContactList.new
#   when "list"
#     Contact.all
#   when "show"
#     Contact.find(ARGV[1])
#   when "new"
#     puts "What is your full name?".colorize(:red)
#     name = STDIN.gets.chomp.downcase
#     puts "What is your email address?".colorize(:red)
#     email = STDIN.gets.chomp
#     Contact.create(name, email)
#   when "search"
#     Contact.search(ARGV[1])
#   else
#     puts "'#{ARGV}' is an invalid input, please try again."
# end



