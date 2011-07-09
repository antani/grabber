require 'amatch'
include Amatch
#puts "just for fun linus".longest_substring_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".longest_substring_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "wodehouse what ho".longest_subsequence_similar("Sketches of Irish Political Characters, of the Present Day, Shewing the Parts They Respectively Take on the Question of the Union, What Places They Ho ")

#puts "just for fun linus".jarowinkler_simila"Sketches of Irish Political Characters, of the Present Day, Shewing the Parts They Respectively Take on the Question of the Union, What Places They Ho "r("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".jarowinkler_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Just for Girls Sarah Delmege")
#puts "just for fun linus".jarowinkler_similar("Just for Girls Sarah Delmege")
puts "harry potter".longest_subsequence_similar("Harry Potter and the Deathly Hallows (Harry Potter Series #7)")
puts "harry potter".longest_subsequence_similar ("Harry Potter & Deathly Hallows Adult (Harry Potter)")
puts "harry potter".longest_subsequence_similar ("Harry Potter And The Deathly Hallows [Signature Edition]")

m = LongestSubsequence.new("Harry Potter and the Deathly Hallows (Harry Potter Series #7)")
weight = m.match("harry potter")
puts weight

m = LongestSubsequence.new("Harry Potter & Deathly Hallows Adult (Harry Potter)")
weight = m.match("harry potter")
puts weight

m = LongestSubsequence.new("Harry Potter And The Deathly Hallows [Signature Edition]")
weight = m.match("harry potter")
puts weight

m = LongestSubsequence.new("Harry Potter Chamber Of Secrets [celeb. Edn]")
weight = m.match("harry potter")
puts weight

m = LongestSubsequence.new("Harry Potter and the Order of the Phoenix")
weight = m.match("harry potter")
puts weight

m = LongestSubsequence.new("Harry Potter And The Prisoner Of Azkaban (celebratory Edition)")
weight = m.match("harry potter")
puts weight


t="Price: Rs.  99.00".gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr('.00','').strip
puts ">>#{t}<<"

t="1006.00".gsub(/$00/,'')
puts t

t = "173/-".tr('/-','').strip
puts t
