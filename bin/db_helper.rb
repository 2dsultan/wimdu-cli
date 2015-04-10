require 'sqlite3'
class DbHelper

	attr_accessor :lid

	def initialize
		#create table Property in the database for demo only 
		qry = "CREATE TABLE IF NOT EXISTS "+
		      "properties(id INTEGER PRIMARY KEY,"+
		      "title TEXT,"+
		      "ptype INT,"+
		      "address TEXT,"+
		      "rate INT,"+
		      "max_guests INT,"+
		      "email TEXT,"+
		      "phone TEXT,"+
		      "status INT,"+
		      "to_contnue TEXT)"

		self.dbCommand(qry,0)
	end

	def dbCommand(query="", dml=1)

		begin
	    
		    db = SQLite3::Database.open "test.db"
		    result  = []

		    if dml == 0 
		    	db.execute(query)
		    	
		    elsif dml == 1
		    	stm = db.prepare(query)
	    		rs = stm.execute
	    		# result  = []

				rs.each do |row|
				        result << row.join("\s")
				end	
			elsif dml == 2
				columns = nil 
				db.execute2(query) do |row|
					if columns.nil?
						columns = row
					else
						result << row.join("\s")	
					end
				end	
			end
		
		@lid = db.last_insert_row_id
		
		rescue SQLite3::Exception => e 
		    
		    puts "Exception occurred"
		    puts e
		    
		ensure
			stm.close if stm
		    db.close if db
		end

	return [result, columns] if dml == 2
	return result if result

	end
# get rows and cols
def get_rcs(query)
	
	rows, columns = self.dbCommand(query,2)

	columns.sort.each do |column|
		puts column
	end

	# property.each do |row|
	# 	 print property.first  
	# end

	return columns 
end


end