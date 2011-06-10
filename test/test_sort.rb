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


tt = "Manorama Year Book 2006"
s = "Manorama YearBook 2011"
puts Text::Levenshtein.distance(tt.downcase,s.downcase)

soundtt= soundex(tt)
sounds = soundex(s)
p soundtt
p sounds

p soundtt.include?(sounds)
p '=================================================================='
w,c =  new_find_weight(tt,s)
p w
p c
