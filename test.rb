puts ARGV

person = Hash.new

person[:name] = ARGV[0]
person[:age] = ARGV[1].to_i
person[:status] = ARGV[2]

puts person

#ARGV puts whatever comes after the "ruby filename.rb" into an array separated by the empty spaces
#to be used as arguments or parameters. ARGV parameters or arguments are entered in through the
#command line by inputting
#ruby test.rb calvin 23 great
#this will output 

#{:name => "calvin",
# :age => 23,
# :status => "great"
#}