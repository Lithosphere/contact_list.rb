require 'pg'
require_relative 'contact'
require 'pry'
class ContactNumber

    @@conn = PG.connect({
    host: 'localhost',
    dbname: 'postgres',
    user: 'development',
    password: 'development'
    })

    def initialize(id, numbers = {}, phone_type = {})
      @id = id
      @numbers = numbers
      @phone_type = phone_type
    end

    def self.create(contact_id, number, type)
      ContactNumber.new(contact_id, number, type)
      @@conn.exec_params('INSERT INTO numbers (contact_id, phone_number, phone_type) VALUES ($1, $2, $3);', [contact_id, number, type])
    end
end