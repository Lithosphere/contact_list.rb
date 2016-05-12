#!/usr/bin/env ruby
require_relative 'contact'
require_relative 'numbers'
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
  contacts = Contact.all
  pp contacts
  puts "--------------------------------------------------".colorize(:blue)
  puts "--------------------------------------------------".colorize(:blue)
when ARGV[0] == "find"
  contacts = Contact.find(ARGV[1].to_i)
  if contacts.empty?
    puts "doesn't exist"
  else
    pp contacts
    end
when ARGV[0] == "new"
  puts "What is your full name?".colorize(:red)
  name = STDIN.gets.chomp.downcase
  puts "What is your email address?".colorize(:red)
  email = STDIN.gets.chomp
  contact = Contact.create(name, email)
  if contact
  puts "Did you have a phone number you wanted to add?".colorize(:red)
  answer = STDIN.gets.chomp 
  else
  puts "email already in the system"
  end
  if answer == "yes" && contact
    loop do
      puts "What is your phone number?"
      @phone_number = STDIN.gets.gsub(' ', '').chomp
      puts "What sort of phone is this for?"
      @phone_type = STDIN.gets.chomp
      ContactNumber.create(contact[0]["id"], @phone_number, @phone_type)
      puts "Any more phone numbers to add?"
      any_more = STDIN.gets.chomp
      if any_more == "no"
        break
      end
    end
  end

when ARGV[0] == "search"
  # Contact.search(ARGV[1])
  contact = Contact.search(ARGV[1])
  if contact.empty?
    puts "No one was found with the name #{ARGV[1]}"
  else
    puts contact
  end
when ARGV[0] == "update"
  puts "Did you want to update the contact?"
  answer = STDIN.gets.chomp.downcase
  if answer == "yes"
    puts "What is the new name?"
    name = STDIN.gets.chomp.downcase
    puts "What is your new email?"
    email = STDIN.gets.chomp.downcase
    updated = Contact.update(ARGV[1], name, email)
    puts "ID has been updated."
  elsif answer == "no"
    puts "No updates to be made."
  end
when ARGV[0] == "destroy"
  the_contact = Contact.destroy(ARGV[1])
  if the_contact.nil?
    puts "No one is under that ID number."
  else
    puts "deleted"
  end
else
  puts "'#{ARGV}' is an invalid input, please try again."
end




