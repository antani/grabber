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


