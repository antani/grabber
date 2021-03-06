require 'text'

def soundex(string)
  copy = string.upcase.tr '^A-Z', ''
  return nil if copy.empty?
  first_letter = copy[0, 1]
  copy.tr_s! 'AEHIOUWYBFPVCGJKQSXZDTLMNR', '00000000111122222222334556'
  copy.sub!(/^(.)\1*/, '').gsub!(/0/, '')
  "#{first_letter}#{copy.ljust(3,"0")}"
end

 def find_weight(source_string, search_string)
        p("-----------------------------Finding weight----------------------------------")
        weight,cost=0,0

        p(source_string)
        p(search_string)
	#Find word frequency in the source string
	freqs=Hash.new(0)
	#source_string.downcase.split.each { |word| freqs[word] += 1 }
	#freqs.sort_by {|x,y| y }.reverse.each {|w, f| puts w+' '+f.to_s} 

        #Start with small search string   
        search_string.downcase.split.each do |t|
          cost = cost + 1
	  source_string.downcase.split.each do |tt|
	          if(soundex(tt) == soundex(t)) then
        	          weight = weight + 1
			  freqs[t] += 1
	          end
          end 
        end
     freqs.sort_by {|x,y| y }.reverse.each {|w, f| puts w+' '+f.to_s} 
        p(weight)
	p(cost)
        p("-----------------")
	#reduce weight if there are duplicates
	freqs.each do |k,v|
		weight = weight - (v-1)
	end


        p(weight)
        return weight,cost
    end

 def new_find_weight(source_string, search_string)
        weight,cost=0,0
	#Find word frequency in the source string
	freqs=Hash.new(0)
	#source_string.downcase.split.each { |word| freqs[word] += 1 }
	#freqs.sort_by {|x,y| y }.reverse.each {|w, f| puts w+' '+f.to_s} 
        soundex_source = soundex(source_string.downcase)
        soundex_target = soundex(search_string.downcase)
        if soundex_source[0] == soundex_target[0] then
          weight =1
        end

        for xx in 1..soundex_source.length do
          if soundex_source[xx] == soundex_target[xx] then
              weight = weight + 5
          end
        end
        p 'Initial weight',  weight        

        #Start with small search string   
        search_string.downcase.split.each do |t|
          cost = cost + 1
	  source_string.downcase.split.each do |tt|
	          if(soundex(tt) == soundex(t)) then
        	          weight = weight + 1
			  freqs[t] += 1
	          end
          end 
        end
        p 'after adding characters', weight
        #freqs.sort_by {|x,y| y }.reverse.each {|w, f| @@logger.info (w+' '+f.to_s)} 
        #@@logger.info(weight)
	#@@logger.info(cost)
        #@@logger.info("-----------------")
	#reduce weight if there are duplicates
	freqs.each do |k,v|
		weight = weight - (v-1)
	end
        

        return weight,cost
    end
#=======================================================================================================

def find_w(source_string, search_string)

  p source_string
  p search_string
  # Assign 10 as weight for perfect word matches
  word_match_w = 10
  weight,cost =0,0
  freqs = Hash.new(0)
  filtered_source_string = ""
  # Check if all the words in search string are present in the target
  #Start with small search string   
  search_string.downcase.split.each do |t|
    cost = cost + 1
    source_string.downcase.split.each do |tt|
    #soundex always matches with numbers - need to ignore numbers. 
        if(soundex(tt) == soundex(t) and (/\d/.match(tt) == nil)) then
                   p t + " - " + tt + " Matches"
 		    if freqs[t] == 0 then	
   			    weight = weight + word_match_w
	         filtered_source_string << tt 
		    end	
		    freqs[t] += 1
    end
    #valid usecase for numbers like Nokia 5800
     if (/\d/.match(tt) != nil and t==tt) then
       p t + " - " + tt + " Matches"
       if freqs[t] == 0 then	
			    weight = weight + word_match_w
	        filtered_source_string << tt 
		    end	
		    freqs[t] += 1
     end
    end 
  end
  puts 'after adding characters- '+ weight.to_s
  
  p filtered_source_string
  #reduce weight if there are duplicates
  #  freqs.each do |k,v|
  #         p k , v
  #         weight = weight - (v*word_match_w)
  #  end
  #p 'after removing duplicates' , weight
        soundex_source = soundex(source_string.downcase)
        soundex_target = soundex(search_string.downcase)
        if soundex_source[0] == soundex_target[0] then
                for xx in 1..soundex_source.length do
                  if soundex_source[xx] == soundex_target[xx] then
                      weight = weight + 1
                  end
                end
        end 
  puts 'after soundex match- '+ weight.to_s 
  #Match filtered source string on soundex
  if soundex(search_string.gsub(" ","")) == soundex(filtered_source_string) then
    weight += 5
  end
  puts 'after soundex match for filter- '+ weight.to_s 
  return weight, cost

end







#tt = "Manorama Year Book 2006"
#s = "Manorama Year Book 2011"
#tt="New Samsung Galaxy S2 I9100, 3G, 8MP 1yr Warranty"
tt= "C++ Programming Language"
s = "Ruby Programming Language"

w,c =0,0
#p soundtt.include?(sounds)
#p '=================================================================='
#w,c =  find_w(tt,s)
#p w
#p c

#tt= "Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds "
#s = "just for fun linus"
soundtt= soundex(tt)
sounds = soundex(s)
p soundtt
p sounds

w,c =  find_w(tt,s)
p w
p c
#30,500.00 
#rs = "30,500.00"

#rs="Our Price: Rs.14699.0"
#rs_tr= rs.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
#.gsub(/[,]/,'')
#p rs_tr

