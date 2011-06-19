require 'amatch'
include Amatch
#puts "just for fun linus".longest_substring_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".longest_substring_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
puts "wodehouse what ho".longest_subsequence_similar("Sketches of Irish Political Characters, of the Present Day, Shewing the Parts They Respectively Take on the Question of the Union, What Places They Ho ")

#puts "just for fun linus".jarowinkler_similar("Linux: Linus Torvalds, Alan Cox, Tux, Agenda Vr3, Fedora, Liste Des Distributions Linux, Processus de Developpement de Linux")
#puts "just for fun linus".jarowinkler_similar("Just For Fun: The Story Of An Accidental Revolutionary Linus Torvalds")

#puts "just for fun linus".longest_subsequence_similar("Just for Girls Sarah Delmege")
#puts "just for fun linus".jarowinkler_similar("Just for Girls Sarah Delmege")


price_text = [" Rs. 357 ", " Rs. 495 ", " Rs. 1584 "]
name_text =["India After Gandhi: The History Of The World's Largest Democracy ", "India After Gandhi ", "Vengeance: India After The Assassination Of Indira Gandhi "] 
author_text = ["Ramachandra Guha", "Guha Ranachandra", "Pranay Gupte"]
puts name_text.length
(0...price_text.length).each do |i|
	puts name_text[i] + " " + author_text[i]
end

price = "Rs. 1584 "
puts price.tr('A-Za-z.,','')
