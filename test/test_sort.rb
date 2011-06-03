require 'text'

a=[[[{:price=>"  190 ", :author=>"P. G. Wodehouse", :name=>"Right Ho Jeeves ", :url=>"", :source=>"Flipkart"}, {:price=>"  190 ", :author=>"P. G. Wodehouse", :name=>"Laughing Gas ", :url=>"", :source=>"Flipkart"}, {:price=>"  200 ", :author=>"P. G. Wodehouse", :name=>"The Inimitable Jeeves ", :url=>"", :source=>"Flipkart"}, {:price=>"  218 ", :author=>"P. G. Wodehouse", :name=>"The Code Of The Woosters ", :url=>"", :source=>"Flipkart"}, {:price=>"  245 ", :author=>"P G Wodehouse", :name=>"What Ho! : The Best Of Wodehouse ", :url=>"", :source=>"Flipkart"}, {:price=>"  190 ", :author=>"P. G. Wodehouse", :name=>"Thank You Jeeves ", :url=>"", :source=>"Flipkart"}, {:price=>"  218 ", :author=>"P G Wodehouse", :name=>"Uncle Fred An Omnibus ", :url=>"", :source=>"Flipkart"}, {:price=>"  190 ", :author=>"P. G. Wodehouse", :name=>"Leave It To P Smith ", :url=>"", :source=>"Flipkart"}, {:price=>"  198 ", :author=>"P. G. Wodehouse", :name=>"Something Fresh ", :url=>"", :source=>"Flipkart"}, {:price=>"  198 ", :author=>"P. G. Wodehouse", :name=>"The Small Bachelor ", :url=>"", :source=>"Flipkart"}]], [[{:price=>" 605", :author=>"Joseph Connolly", :name=>"Wodehouse ", :url=>"", :source=>"Infibeam"}, {:price=>" 388", :author=>"Robert Mc Crum", :name=>"Wodehouse ", :url=>"", :source=>"Infibeam"}, {:price=>" 1062", :author=>"John Wodehouse", :name=>"Wodehouses of Kimberly ", :url=>"", :source=>"Infibeam"}, {:price=>" 261", :author=>"P G Wodehouse", :name=>"Vintage Wodehouse ", :url=>"", :source=>"Infibeam"}, {:price=>" 803", :author=>"Richard Usborne", :name=>"Wodehouse Nuggets ", :url=>"", :source=>"Infibeam"}, {:price=>" 153", :author=>"P G Wodehouse Richard", :name=>"Wodehouse On Crime ", :url=>"", :source=>"Infibeam"}, {:price=>" 3365", :author=>"P G Wodehouse", :name=>"A Wodehouse Bestiary ", :url=>"", :source=>"Infibeam"}]]]

c = a.flatten


b = c.sort_by { |p| p[:price].to_i }

puts b

string = "Right Ho Jeeves P. G. Wodehouse".downcase 
searchstr = "WHAT HO WODEHOUSE".downcase
weight,cost=0,0
searchstr.split.each do |t|
        if(string.include? t) then
                weight = weight + 1
        end
end
puts weight

tstr="  		
			A WODEHOUSE BESTIARY (P.G. WODEHOUSE COLLECTION) (Paperback)
		 
		 
		 P. G. Wodehouse, P.G. Wodehouse
		 
	

"
name="			A WODEHOUSE BESTIARY (P.G. WODEHOUSE COLLECTION)
"
name=name.strip()
i= tstr.index(name)+name.length
puts i
j= tstr[i..tstr.length]
puts j.strip()
  def proper_case(str)
    return str.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
  end
 

t = "INDIAN TEST CAPTAINS: SACHIN TENDULKAR, MOHAMMAD AZHARUDDIN, SUNIL GAVASKAR, SOURAV GANGULY, VIRENDER SEHWAG, MAHENDRA SINGH DHONI 	SACHIN TENDULKAR 10,000 (Paperback) Sharad Pawar "
tt = proper_case(t)

puts tt

amount="Our Price: Rs. 15490.00"
amount.sub!(/A-Za-z0-9/, '')
puts amount
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
              p xx, weight
          end
        end
                

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


tt = "Leave The Office Earlier-productivity Pro Shows You How"
s = "The Office"
puts Text::Levenshtein.distance(tt.downcase,s.downcase)

soundtt= soundex(tt)
sounds = soundex(s)
p soundtt
p sounds

p soundtt.include?(sounds)

w,c =  new_find_weight(tt,s)
p w
p c
