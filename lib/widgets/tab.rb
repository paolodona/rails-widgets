module Widgets
  class Tab
    attr_accessor :highlights, :link, :name, :title, :html
    
    def initialize(opts={})
      @name = opts[:name] 
      @title = opts[:title]
      @link = opts[:link] || {}
      @highlights = opts[:highlights] || []
      @html = opts[:html] || {} 
    
      yield(self) if block_given?
      
      @highlights << @link if link? # it does highlight on itself
      raise ArgumentError, 'you must provide a name' unless @name
    end
    
    def highlights_on rule
      @highlights << rule
    end
    
    # takes in input a Hash (usually params)
    # or a string/Proc that evaluates to true/false
    # it does ignore some params like 'only_path' etc..
    # we have to do this in orderr to support restful routes
    def highlighted? options={}
      option = clean_unwanted_keys(options)
      #puts "### '#{name}'.highlighted? #{options.inspect}"
      result = false
       
      @highlights.each do |highlight| # for every highlight(proc or hash)
        highlighted = true
        h = highlight.kind_of?(Proc) ? highlight.call : highlight # evaluate highlights
        if (h.is_a?(TrueClass) || h.is_a?(FalseClass))
          highlighted &= h
        else
          check_hash h, 'highlight'
          h = clean_unwanted_keys(h)
          #puts "# #{h.inspect}"
          h.each_key do |key|   # for each key
            highlighted &= h[key].to_s==options[key].to_s   
          end 
        end
        result |= highlighted
      end
      return result
    end
    
    def link?
      @link && !@link.empty?
    end
       
    private 
    
    def check_string_or_proc(param, param_name)
      unless param.kind_of?(String) or param.kind_of?(Proc) 
        raise "param #{param_name} should be a String or a Proc but is a #{param.class}"
      end 
      param 
    end
    
    def check_hash_or_proc(param, param_name)
      unless param.kind_of?(Hash) or param.kind_of?(Proc) 
        raise "param #{param_name} should be a Hash or a Proc but is a #{param.class}"
      end
      param 
    end
    
    def check_string(param, param_name)
      return if param.nil?
      raise "param #{param_name} should be a String but is a #{param.class}" unless param.kind_of?(String)  
      param
    end
    
    def check_hash(param, param_name)
      raise "param '#{param_name}' should be a Hash but is #{param.inspect}" unless param.kind_of?(Hash)
      param
    end
    
    # removes unwanted keys from a Hash 
    # and returns a new hash
    def clean_unwanted_keys(hash)
      ignored_keys = [:only_path, :use_route]
      hash.dup.delete_if{|key,value| ignored_keys.include?(key)}
    end 
  end
end