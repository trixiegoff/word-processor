class String
	def histogram
		out = {}
		out.default = 0
		self.gsub(/[^a-z]/i, '').upcase.each_char {|c| out[c] += 1}
		out
	end

	def is_anagram (s)
		needle = self.histogram
		haystack = s.histogram
		needle.keys.each {|c| haystack[c] -= needle[c] }
		result = not(haystack.values.any?{|v| v < 0 })
		remainder = ""
		haystack.each_pair{|c, q| remainder += result ? c*q : q < 0 ? c*q.abs : "" }
		return result, remainder
	end
end


def prompt ()
	print "> "
	_s = gets.strip
	if _s[0] =~ /[[:alpha:]]/ then
		return false, _s
	else
		return _s.slice!(0), _s.upcase
	end
end



def filter_words (wordlist, haystack)
	cnt, grafiks = 0, "|/-\\".split('')

	results = []
	wordlist.each do |line|
		word = (line.class == Array) ? line[0] : line
		# puts ">>> checking to see if #{word} is an anagram of #{haystack}"
		word.gsub!(/[^a-z]/i, '')
		result, remainder = word.is_anagram haystack
		if result then
			results << [line, remainder]
			print "#{grafiks[(cnt+=1)%grafiks.length]}\033[1D"
		end
	end
	results
end

def print_results (res)
	res.sort_by{|e| e[0].length}.each do |word|
		puts("#{word[0]} \t[#{word[1]}]")
	end
end


wordlist = File.readlines('words.txt').map{|line| line.strip }

# of = "MY ALGORITHM ISNT VERY EFFICIENT"




quit = false
stack = []
results = []
of =  ""
while not quit do
	cmd, thing = prompt
	case cmd
	when '`'
		quit = true
	when '+'
		can, remainder = thing.is_anagram of
		if can then
			results.select!{|e| e.is_anagram remainder }
			print_results(results)
			of = remainder
		else
			puts "NEED#{"S" unless remainder.length == 1} #{remainder}"
		end
	when '-'
		puts thing
		of = of + thing
		results = filter_words(wordlist, of)
		print_results(results)
	when '!'
		stack = []
		of = thing
		results = filter_words(wordlist, thing)
		print_results(results)
	when "?"
		# results.map{|e| puts(e[0]) }
		puts(thing.histogram)
	when ">"
		File.write("_anagrams.log", results.join("\n"))
	else
		of = thing
		results = filter_words(wordlist, thing)
		print_results(results)
	end
	if results.first.is_a?(Array) then results.map!{|e| e[0]} end
end


# planck length