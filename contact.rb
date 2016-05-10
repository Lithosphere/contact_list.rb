require 'csv'
gem 'will_paginate', '~> 3.1'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id, :count, :numbers
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, numbers={} )
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
    @numbers = numbers
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects

    # MAHER COMMENTS: put only logic in this file, keep user experience to the contact list
    # the all should return collection of Contacts
    def all
      counter = 0
      @count = 0
      CSV.foreach('contacts.csv') do |row|
        if row.empty?
          nil 
        else 
          puts row.inspect.gsub(/\\/, '').gsub(/"/, '').gsub(//, '').colorize(:green) 
          counter += 1        
          @count += 1
          case 
          when counter == 5
            puts "Press any key for the next set of records..."
            input = STDIN.gets.chomp
            counter = 0
          end 

        end

      end

    end
    def count
      @count
    end
    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email

    # MAHER COMMENTS: create should create an instance of contact
    def create(name, email, numbers={} )
      new_contact = Contact.new(name, email, numbers)
      contact_list = CSV.read('contacts.csv')
      already_logged = nil

      CSV.foreach('contacts.csv') do |row|
        if row[2] == email
         already_logged = email
       end
     end
     id = contact_list.empty? ? 1 : contact_list.last[0].to_i + 1
     if already_logged == new_contact.email
       puts "Email is already taken, please select another."
     else
       CSV.open("contacts.csv", "a") do |csv|
         csv << [id, name, email, numbers]
         csv 
       end
       puts "#{new_contact.name} with #{new_contact.email} was created!".colorize(:red)
     end

     new_contact
   end

      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.

      # MM new_contact

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      CSV.foreach('contacts.csv') do |row|
        if row[0].to_i == id
          puts "ID ##{row[0]} belongs to #{row[1]} with the email #{row[2]}.".colorize(:red)
          if row[3] != nil
            puts "#{row[1]}'s phone numbers are as follows: #{row[3]}".gsub(/\\/, '').gsub(/"/, '').gsub(//, '').colorize(:red)
          end
        end
      end
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
  #     if CSV.read('contacts.csv').any? {|array| array.include?(term)}
  #       puts "Here is a list of people returned with your search keyword '#{term}'".colorize(:red)
  #       CSV.foreach('contacts.csv') do |row|
  #         unless row.include?(term) 
  #           nil
  #         end
  #         case
  #           when row[1] == term || row[2] == term
  #             puts row.inspect
  #         end
  #       end
  #     else
  #       puts "No one was found with the name #{term}."
  #     end
  #   end
  # end
  #     TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.

  search_contact = nil
  CSV.foreach('contacts.csv') do |row|
    if row[1].include? term or row[2].include? term
      puts row.inspect.gsub(/\\/, '').gsub(/"/, '').gsub(//, '').colorize(:red)
      if row[3] != nil
        puts "#{row[1]}'s phone numbers are as follows: #{row[3]}".gsub(/\\/, '').gsub(/"/, '').gsub(//, '').colorize(:red)
      end
      search_contact = Contact.new(row[1], row[2])
    end
  end
  search_contact
end
end
end
