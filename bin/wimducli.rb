
APP_ROOT = File.dirname(__FILE__)

require "#{APP_ROOT}/db_helper"
require "#{APP_ROOT}/property"

action = ARGV[0].downcase
param  = ARGV[1]


def add
	property = Property.new

	puts "Starting with new property #{property.pid}\n\n"
	continue(property.pid)
	# !exit
end

def list
	property = Property.list
end

def self.continue(pid)


	Property.continue(pid)		

	# qry = "SELECT to_contnue FROM properties WHERE id = #{pid} AND status = 0"
	# db = DbHelper.new

 #    rs = db.dbCommand(qry)
    
 #    to_continue = rs.first

 #    puts "Continuing with #{pid}"
    
 #    # columns = db.get_rcs("SELECT * FROM properties WHERE id = #{pid}")
 #    # columns = {"address","email","max_guests","phone","ptype","rate","title"}

	
	#  # Property.send(to_continue.to_sym,value,to_continue)
	#  Property.update(pid,to_continue, "email")
end

case action
when 'new'
	add
when 'list'
	list
when 'continue'
	continue(param)
end