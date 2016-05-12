require 'csv'
require 'pg'
require 'pry'
require 'will_paginate/array'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@conn = PG.connect({
    host: 'localhost',
    dbname: 'postgres',
    user: 'development',
    password: 'development'
    })

  attr_accessor :name, :email, :id, :count, :numbers

  def initialize(name, email)
    @name = name
    @email = email
    @numbers = numbers
  end

  def to_s
    "#{@name} #{@email}"
  end


  class << self

    def all
      results = []
      @@conn.exec('SELECT contacts.id as contactid, contacts.name, contacts.email, numbers.phone_number, numbers.id as phoneid,
        numbers.phone_type
        FROM contacts LEFT OUTER JOIN numbers ON contacts.id =numbers.contact_id 
        ORDER BY contacts.id ASC;') do |contacts|
      contacts.each do |contact|
        results << contact
      end
    end
    results.paginate(:page => 1, :per_page => 5)
  end

  def create_from_row(row)

    Contact.new(row["name"], row["email"])

  end


  def create(name, email)
    results = []
    @@conn.exec_params('SELECT * FROM contacts WHERE email = $1;', [email]).each do |result|
      results << create_from_row(result)
    end
    if results.empty?
      results << Contact.new(name, email)
      new_contact = self.save(name, email)
    else
      return false
    end
  end
end


def self.save(name, email)
  @@conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;', [name, email])
end

def self.find(id)
  results= []
  @@conn.exec_params('SELECT contacts.id as contactid, contacts.name as name, contacts.email as email, numbers.phone_number as phonenumber, numbers.phone_type as type FROM contacts LEFT OUTER JOIN numbers on numbers.contact_id = contacts.id WHERE contacts.id = $1;',[id]).each do |result|
      # binding.pry
      results << result
    end
    results
  end

  
  def self.search(term)
    results = []
    @@conn.exec_params('SELECT * FROM contacts WHERE name LIKE $1;',[term]) do |contacts|
      contacts.each do |contact|
        results << create_from_row(contact)
      end
    end
    results
  end

  def self.update(id, new_name, new_email)
    the_contact = find(id)[0]
    if the_contact.nil?
      self.save(new_name, new_email)
    else
      the_contact["name"] = new_name
      the_contact["email"] = new_email
      @@conn.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3;', [the_contact["name"], the_contact["email"], id])
      the_contact
    end
  end

  def self.destroy(id)
    the_contact = find(id)[0]
    @@conn.exec_params('DELETE FROM contacts WHERE id = $1;',[id])
    the_contact
  end
end

