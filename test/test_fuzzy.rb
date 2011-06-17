require 'amatch'
include Amatch
puts "just for fun linus".longest_substring_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
puts "just for fun linus".longest_substring_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

puts "just for fun linus".longest_subsequence_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
puts "just for fun linus".longest_subsequence_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

puts "just for fun linus".jarowinkler_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
puts "just for fun linus".jarowinkler_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

puts "just for fun linus".longest_subsequence_similar("Just for Girls Sarah Delmege")
puts "just for fun linus".jarowinkler_similar("Just for Girls Sarah Delmege")
