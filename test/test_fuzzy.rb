require 'amatch'
include Amatch
require 'stemmer'

#puts "just for fun linus".longest_substring_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".longest_substring_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "wodehouse what ho".longest_subsequence_similar("Sketches of Irish Political Characters, of the Present Day, Shewing the Parts They Respectively Take on the Question of the Union, What Places They Ho ")

#puts "just for fun linus".jarowinkler_simila"Sketches of Irish Political Characters, of the Present Day, Shewing the Parts They Respectively Take on the Question of the Union, What Places They Ho "r("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".jarowinkler_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Just for Girls Sarah Delmege")
#puts "just for fun linus".jarowinkler_similar("Just for Girls Sarah Delmege")
#puts "harry potter".longest_subsequence_similar("Harry Potter and the Deathly Hallows (Harry Potter Series #7)")
#puts "harry potter".longest_subsequence_similar ("Harry Potter & Deathly Hallows Adult (Harry Potter)")
#puts "harry potter".longest_subsequence_similar ("Harry Potter And The Deathly Hallows [Signature Edition]")

#m = LongestSubsequence.new("Harry Potter and the Deathly Hallows (Harry Potter Series #7)")
#weight = m.match("harry potter")
#puts weight

#m = LongestSubsequence.new("Harry Potter & Deathly Hallows Adult (Harry Potter)")
#weight = m.match("harry potter")
#puts weight

#m = LongestSubsequence.new("Harry Potter And The Deathly Hallows [Signature Edition]")
#weight = m.match("harry potter")
#puts weight

#m = LongestSubsequence.new("Harry Potter Chamber Of Secrets [celeb. Edn]")
#weight = m.match("harry potter")
#puts weight

#m = LongestSubsequence.new("Harry Potter and the Order of the Phoenix")
#weight = m.match("harry potter")
#puts weight

 STOP_WORDS = %w[
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    an and are as at be by for from has he in is it its
    of on that the to was were will with upon without among
    ].inject({}) { |h,v| h[v] = true; h }
  
    def tokenize(string)
      stripped = string.to_s.gsub(/[^a-z0-9\-\s\']/i, "") # removes punctuation
      words = stripped.split(/\s+/).reject { |word| word.match(/^\s*$/) }.map(&:downcase)  #.map(&:stem)
      words.reject { |word| STOP_WORDS.key?(word) }.uniq
      return words
    end


    def find_weight(source_string, search_string)
            
              weight,wt=0,0
              begin
              

                    search_string = strip_invalid_utf8_chars(search_string + ' ')[0..-2]
                    source_string = strip_invalid_utf8_chars(source_string + ' ')[0..-2]
                    
                    search_string = de_canonicalize_isbn(search_string)
                    source_string = tokenize(source_string).join(" ").gsub(/\W/," ")
                    search_string = tokenize(search_string).join(" ").gsub(/\W/," ")   
                    
                    
                    m = LongestSubsequence.new(source_string.downcase)
                    weight = m.match(search_string.downcase)
                    
                    source_string = source_string.gsub("\n","").gsub("\t","").downcase
                    source_text = [source_string]
                    
                    #engine = VSS::Engine.new(source_text)
                    #results= engine.search(search_string.downcase)
                    ###@@logger.info(results)
                    #results.each do |e|
                    #          weight = weight + e.rank 
                              #@@logger.info (weight)
                    #end
                    m = Jaro.new(source_string)
                    weight = weight + m.match(search_string)   
            
                    #wt = get_custom_weight(source_string.downcase, search_string.downcase)
                    #weight = weight + wt
                    # #@@logger.info(source_string)
                    # #@@logger.info(search_string)
                    
                    puts("#{source_string} - #{search_string} : #{weight}")
                    
                    
              rescue => ex
                    puts ("#{ex.class} : #{ex.message}")
                    puts (ex.backtrace)
              end

              return weight+wt,0
        end

        def de_canonicalize_isbn(text)
              unless text.nil?
               text.to_s.gsub('+', ' ')
              end
        end

	    def proper_case(str)
		    st = str.to_s
		    #return st.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
		    #return str.titleize unless str.nil?

	    end
	    def strip_invalid_utf8_chars(str)
          unless str.valid_encoding?
            buf = []
            str.each_char do |ch|
              
              buf << ch if ch.valid_encoding?
            end
            return buf.join
          else
            return str
          end
       end



#m = LongestSubsequence.new("Expert One On One J2EE Development Without EJB")
#weight = m.match("Expert One-on-One J2EE Design and Development")
#puts weight


#m = Jaro.new("Harry Potter And The Chamber Of Secrets")
#puts m.match("Harry Potter Chamber Of Secrets")

#m = Jaro.new("Harry Potter and the Chamber of Secrets")
#puts m.match("Harry Potter Chamber Of Secrets")

 

puts find_weight("Harry Potter and the Chamber of Secrets j k rowling","Harry Potter Chamber Of Secrets Rowling")
puts find_weight("Harry Potter and the Chamber of Secrets Frederic P Miller","Harry Potter Chamber Of Secrets")
puts find_weight("Just for Fun: The Story of an Accidental Revolutionary Linus Torvalds", "just for fun linus")
puts find_weight("Just for Fun: The Story of an Accidental Revolutionary", "just for fun linus")

#t="Price: Rs.  99.00".gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr('.00','').strip
##puts ">>#{t}<<"

#t="1006.00".gsub(/$00/,'')
##puts t

#t = "173/-".tr('/-','').strip
##puts t
