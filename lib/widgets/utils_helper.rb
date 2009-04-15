module Widgets
  module UtilsHelper
    def nocr(string)
      return string.gsub("\n", '')
    end
  
    # converts blank spaces into no breaking spaces
    # use it like <%=nbsp ...%>
    def nbsp(string)
      string.to_s.gsub " ", "&nbsp;"
    end 
  
    # generates random text to fill up not-yet-implemented interfaces
    def lorem(n=nil)
      words = %w{Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.} 
      if n 
        while (n > words.size) do words = words + words; end 
        words = words[0..n]    
      end
      return words.join(' ') 
    end
  end  
end
