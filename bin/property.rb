
class Property

	@@ptypes = ['proom', 'aparatment', 'hhome']
     @@columns = ["address","email","max_guests","phone","ptype","rate"]#alternatively we could initialise this in the constructor

	attr_accessor :pid, :ptype, :address, :rate, :max_guests, :email , :phone, :status, :to_contnue

	def initialize(ptype=-1,address=nil,rate=nil,max_guests=nil,email=nil,phone=nil)
		@ptype = ptype
		@address = address
		@rate = rate
		@max_guests = max_guests
		@email = email
		@phone = phone
          @status = 0 #to check is complete
          @to_contnue ='title' 

          qry = "INSERT INTO properties (status,to_contnue) "+
                " VALUES(#{status}, '#{to_contnue}');"

          db = DbHelper.new

          db.dbCommand(qry)
          @pid = db.lid

          # puts "#{@pid}"
     end

     def self.update(pid, column, continue_with, length)
           
          value = nil
          db = DbHelper.new

          case column
          when "title" 
               if check_for_nil(column,pid)
                    print "Title: ";  value = $stdin.gets.chomp; 
               end
          when "address"
               if check_for_nil(column,pid) 
                    print "Address: "; value = $stdin.gets.chomp;
               end
          when "email" 
               if check_for_nil(column,pid)
                    print "Email: "; value = $stdin.gets.chomp;
               end
          when "phone" 
               if check_for_nil(column,pid)
                    print "Phone number: "; value = $stdin.gets.chomp;
               end                  
          when "max_guests" 
               if check_for_nil(column,pid)
                    # puts "Error: must be a number" unless value.to_i.is_a? Integer
                    print "Max guests: "; value = $stdin.gets.chomp
               end
          
          when "rate"
               
               if check_for_nil(column,pid)         
                    print "Nightly rate in EUR: "; value = $stdin.gets.chomp;         
               end
          else
               status = 0; #completion check
          end

          value = "'#{value}'" unless value.is_a? Integer

          update_prop_on_input(column, value, continue_with, status, pid)
          
          if status == 1
             show_final_msg(pid); !exit
          end

          continue(pid, true) 

     end


     def self.continue(pid, to_remove = false)

          db = DbHelper.new
          
          qry = "SELECT to_contnue FROM properties WHERE id = #{pid} AND status = 0"
          
          rs = db.dbCommand(qry)
          
          if rs.empty?
               puts "No property found!"; !exit 
          end

          # puts to_remove; !exit
          to_continue = rs.first
          @@columns.delete_at(0) if to_remove

          continue_with = @@columns.first

          @@columns.each do |column|
               unless to_continue.nil?
                    puts "Continuing with #{pid}" if to_remove == true
                    Property.update(pid,to_continue, continue_with,@@columns.length)
               else
                    puts "No property found!" 
                    !exit#restart session
               end
          end
     end


     def add
     	puts "Starting with new property ...\n"
     end

     # def update
     # 	puts "Continuing with ...\n"
     # end

     def self.list

          qry = "SELECT * FROM properties WHERE status !=0"
          db = DbHelper.new

          rs = db.dbCommand(qry,1)

          if rs && rs.length > 0
             rs.each do |row,ts| 
              #  Found 1 offer.
              puts "Found #{rs.length} offer.\s" + row + "\n\n"
             end
          else 
             puts "No properties found.\n"
          end
     end

     def self.check_for_nil(column, pid)
          
          is_nil = false
          column = "phone"
          db = DbHelper.new
          qry = "SELECT #{column} FROM properties WHERE id = #{pid} AND status = 0"

          rs = db.dbCommand(qry,1)

          is_nil = true if  rs.first.empty? || rs.first.nil?
          # puts is_nil
          # !exit
          return is_nil
     end

     def self.update_prop_on_input(column, value, continue_with, status, pid)
          
          status = 0 if status.nil?

          db = DbHelper.new
          prep_qry = "UPDATE properties SET #{column} = #{value}, to_contnue = '#{continue_with}', status = #{status} "+
                     " WHERE id = #{pid}"
          rs = db.dbCommand(prep_qry,0)

     end

     def self.show_final_msg(pid)
          puts "Great job! Listing #{pid} is complete!"; 
     end

     def validate_input
          value = $stdin.gets.chomp
          
          if value.to_i == 0 &&  value.to_i.is_a?(Integer) == false
               puts "Error: must be a number"
               value = false
          end
   
          return value
        
     end
end