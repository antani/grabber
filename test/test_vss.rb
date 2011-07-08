require "vss"
require 'amatch'
include Amatch


@docs=[
"Unauthorized Harry Potter And The Deathly Hallows News: Harry Potter Book Seven And Half-Blood Prince Analysis W. Frederick Zimmerman",
"Harry Potter & the Deathly Hallows Part 2 Electronic Arts",
"Harry Potter & the Deathly Hallows Part 2 Electronic Arts",
"Harry Potter & the Deathly Hallows Part 2 Electronic Arts", 
"Harry Potter & Deathly Hallows Adult (Harry Potter) J K Rowling", 
"Harry Potter And The Deathly Hallows [Signature Edition] J. K. Rowling", 
"Harry Potter and the Deathly Hallows J K Rowling", 
"Harry Potter And The Deathly Hallows J K Rowling", 
"Harry Potter Andamp The Deathly HallowsJ K Rowling", 
"Harry Potter And The Deathly Hallows (Harry Potter Series #7) Rowling", 
"Harry Potter and the Deathly Hallows Jk Rowling", 
"Harry Potter And The Deathly Hallows # 7 J K Rowling", 
"Harry Potter And the Deathly Hallows [In Hindi]",
"Harry Potter And The Deathly Hallows (Book 7) (Deluxe Edition)",
"Harry Potter and the Deathly Hallows",
"Harry Potter & Deathly Hallows Adult (Harry Potter) J K Rowling",
"Harry Potter & The Deathly Hallows : J. K.J Rowling",
"Harry Potter And The Deathly HallowsJ. K. Rowling",
"Harry Potter And The Deathly Hallows 2DVD Special Editi",
"Harry Potter and the Deathly Hallows POS Pack",
"Harry Potter And The Deathly Hallows Agnes F Vandome",
"Unauthorized Harry Potter and the Deathly Hallows News: Harry PottW. Frederick Zimmerman",
"Harry Potter And The Deathly Hallows Film Poster Book Bbc",
"Harry Potter And The Deathly Hallows Rowling J. K., Grandpre Mary",
"Harry Potter and the Deathly Hallows (Book 7) J.K. Rowling",
"Unauthorized Harry Potter and the Deathly Hallows W Frederick Zimmerman",
"Unauthorized Harry Potter And The Deathly Hallows News: Harry Potter Book Seven And Half-blood Prince Analysis W. Frederick Zimmerman",
"Harry Potter and the Deathly Hallows Frederic P Miller ",
"Harry Potter and & the Deathly Hallows Part 1 (PC Game)",
"Harry Potter and & the Deathly Hallows Part 1 (PC Game)",
"Harry Potter And The Deathly Hallows J. K. Rowling ",
"HARRY POTTER AND THE DEATHLY HALLOWS[Harry Potter and the Deathly ...",
"Harry Potter And The Deathly Hallows J.k. Rowling ",
"Harry Potter and the Deathly Hallows J. K. Rowling ",
"Harry Potter And The Deathly Hallows Rowling J K "]
text=["Canon LBP2900B","Canon EOS 550D SLR with Kit (EF S18-55 IS) Lens (Black)"]
engine = VSS::Engine.new(@docs)
results= engine.search("Harry Potter and the Deathly Hallows") #=> ["hello", "hello, hello!", "hello and goodbye", "goodbye"]
#puts results
results.each do |e|
#	puts e + "(#{e.rank})"
end


#    @doc1 = "I'm not even going to mention any TV series."
#    @doc2 = "The Wire is the best thing ever. Fact."
#    @doc3 = "Some would argue that Lost got a bit too wierd after season 2."
#    @doc4 = "Lost is surely not in the same league as The Wire."
#    @doc5 = "You cannot compare the The Wire and Lost."
#    @doc6 = "How can you compare The Wire with Lost?"
#    @docs = [@doc1, @doc2, @doc3, @doc4, @doc5, @doc6]
#    @engine = VSS::Engine.new(@docs)
#
#
#results = @engine.search("How can you compare The Wire with Lost?")
#results.each do |e|
##	puts e.rank
#end
#
#@doc1="Samsung i9100 Galaxy S 2 Gel Case Cover New stand built"
#@doc2="Samsung Galaxy S2"
#
#    @docs = [@doc1, @doc2]
#    @engine = VSS::Engine.new(@docs)
#
#
#results = @engine.search("Samsung Galaxy S2")
#results.each do |e|
##	puts e.rank
#end
#
#
#require 'stemmer'
#require 'active_support'
#
#STOP_WORDS = %w[
#  a b c d e f g h i j k l m n o p q r s t u v w x y z
#  an and are as at be by for from has he in is it its
#  of on that the to was were will with upon without among
#]
#
#def tokenize(string)
#  stripped = string.to_s.gsub(/[^a-z0-9\-\s\']/i, "") # remove punctuation
#  tokens = stripped.split(/\s+/).reject(&:blank?).map(&:downcase).map(&:stem)
#  tokens.reject { |t| STOP_WORDS.include?(t) }.uniq
#end
#doc1 = "I'm not even going to mention any TV series."
#doc2 = "The Wire is the best thing ever. Fact."
#doc3 = "Some would argue that Lost got a bit too wierd after season 2."
#doc4 = "Lost is surely not in the same league as The Wire."
#@docs = [doc1, doc2, doc3, doc4]
#@vocab = tokenize(@docs.join(" "))
#@vector_keyword_index = begin
#  index, offset = {}, 0      
#
#  @vocab.each do |keyword|
#    index[keyword] = offset
#    offset += 1
#  end
#
#  puts index
#end
def get_custom_weight(source_string, search_string)
  # find the maximum substring weightage first.
  weight = 0
  source_string.downcase!()
  search_string.downcase!()
  m = LongestSubsequence.new(source_string)
  weight = m.match(search_string)
  #puts ("Weight 1          " + weight.to_s)
  # Get unique strings from the search string
  normalized_search_string="" 
  search_string.split.each do |ss|
    normalized_search_string="#{normalized_search_string} #{ss}" unless normalized_search_string.include?(ss)
  end
  # calculate number of words in the source_string
  source_count=0 
  source_string.split.each do |sss|
    source_count += 1
  end
  #How many (unique) words of search string are present in source string ?
  search_count=0
  normalized_search_string.split.each do |s|
    search_count +=1 if source_string.include?(s)
  end
  #puts search_count
  #puts normalized_search_string
  wt = search_count.fdiv(source_count)
  weight = weight + (search_count.fdiv(source_count))
  #puts "#{source_string} - #{wt}"
  weight

end

cameras=[
"Canon EOS 550D SLR with Kit (EF S18-55 IS) Lens (Black)",
"Canon EOS 550D SLR with Kit II (EF S18-135 IS) Lens (Black) ",
"Canon EOS 550D SLR with Body only (Black) ",
"Canon EOS550D EF-S18-55mm IS + 4 GB Memory Card Free (Black) ",
"Canon EOS 550D with EF S18-135mm IS Kit ",
"Canon EOS 550D Kit EF S 18-135mm... ",
"CANON EOS 550D DSLR CAMERA WITH 18-55IS LENS 4 GBMEMORY ",
"CANON EOS 550D DSLR CAMERA WITH 18-55IS LENS 4 GBMEMORY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR CAMERA WITH 18-55IS LENS 4GB MEMORY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"Canon EOS 550D DSLR + 18-55 ISmm Lens  -2year Warranty ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+2YRS WARRANTY",
"CANON EOS 550D DSLR CAMERA WITH 18-135 IS LENS 4 GB BAG ",
"CANON EOS 550D DSLR CAMERA TWO18-55IS+55-250 I.S LENSES ",
"CANON EOS 550D DSLR +18-55mm IS LENS +4GB+CANON WARRNTY ",
"CANON EOS 550D DSLR CAMERA TWO18-55IS+55-250 I.S LENSES ",
"CANON EOS 550D DSLR CAMERA TWO18-55IS+55-250 I.S LENSES ",
"CANON EOS 550D DSLR CAMERA WITH 18-55IS LENS 4 GBMEMORY ",
"CANON EOS 550D DSLR CAMERA 18-200 IS LENS 4 GB MEMORY ",
"CANON EOS 550D DSLR CAMERA+18-55IS+75-300I.S+50mm1.8NEW ",
"CANON EOS 550D DSLR CAMERA WITH 18-135 IS LENS 4GB BAG ",
"CANON EOS 550D DSLR KIT 18-135 IS LENS 4 GB CLASS6CARD ",
"CANON EOS 550D DSLR KIT 18-135 IS LENS 4 GB CLASS6CARD  ",
"CANON EOS 550D DSLR CAMERA TWO18-55IS+55-250 I.S LENSES ",
"CANON EOS 550D DSLR KIT 18-135 IS LENS 4 GB CLASS6CARD  ",
"CANON EOS 550D DSLR KIT 18-135 IS LENS 4 GB CLASS6CARD  "]

engine = VSS::Engine.new(cameras)
results= engine.search("Canon EOS 550D".downcase) #=> ["hello", "hello, hello!", "hello and goodbye", "goodbye"]
#puts results
cameras.each do |c|
  puts get_custom_weight(c, "Canon EOS 550D")
end


results.each do |e|
#	puts e + "(#{e.rank})"
    
end
def strip_invalid_utf8_chars(str)
  unless str.valid_encoding?
    buf = []
    str.each_char do |ch|
      puts ch
      buf << ch if ch.valid_encoding?
    end
    return buf.join
  else
    return str
  end
end
#puts get_custom_weight('Chupke Chupke movie','Chupke Chupke chupke chupke') 

#invalid_string="Dork Decade: The Dork Tower Ten Year Anniversary … "
#ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
valid_string = strip_invalid_utf8_chars("Dork Decade: The Dork Tower Ten Year Anniversary … ")
puts valid_string.gsub("\n","").gsub("\t","").downcase

