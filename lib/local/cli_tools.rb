
class String
  def flag?; self[0,1]=='-' end
  def shift; self.slice! 0,1 end
end

class Array
  def duplicate; *copy = *self.map{|a|a.dup} end
end

module CliTools
  def request_value words=nil
    printf words+' ' if words
    $stdin.gets.chop
  end

  def make_sure words='', default='Y', other='n'
    answer = request_value(words+" [#{default}/#{other}]")
    return true if answer==''
    if answer.downcase == default.downcase or answer.downcase == other.downcase
      return answer.downcase == default.downcase
    else
      return make_sure(words, default, other)
    end
  end

  def choice say, array, with=nil
    return nil if with == ''
    new_array = []
    array.size.times do |i|
      if (array[i].to_s=~/#{with}/) || (with.to_i==i+1)
        new_array << array[i]
        puts "\t#{new_array.size}: #{new_array.last.to_s}"
      end
    end
    new_array.empty? ? nil : (new_array.size==1 ? new_array.first : choice(say, new_array, request_value(say)))
  end
end

module Flagger
  def clear_arguments
    @flags ={}
    @active_keys = {}
    @active_flags = {}
    @potential_flags = {}
    @associated_blocks  = {}
    @remaining_argument = []
    @potential_keywords = []
  end

  def process(args=nil)
    seperate(args) if args
    process_input 
  end

  def seperate(args=nil)
    return nil unless args
    args = args.duplicate
    while !args.empty? and not args.first.flag?
      if @potential_keywords.include?(args.first.to_sym)
        @active_keys.merge! args.shift.to_sym => nil
      else
        @remaining_argument << args.shift
      end
    end
    @flags = args
  end

  def run_flags
    process_flags parse_flags(@flags)
  end

  def run_keys
    process_flags @active_keys
  end

  def process_input &blk
    run_flags
    run_keys
  end
  
  def trip_flag which, with_value=nil
    start_flag_checking
    @active_flags.merge!({which => (with_value || true)})
  end

  def start_flag_checking
    @active_flags ||= {}
  end

  def parse_flags(args)
    start_flag_checking
    while not args.empty?
      flag_set  = args.shift
      flag_set.shift
      unless flag_set.flag?
        while not flag_set.empty?
          @active_flags.merge!({flag_key_for(flag_set.shift) => (flag_set.empty? && args.first) ? (args.first.flag? or args.shift ) : nil})
        end
      else
        flag_set.shift
          @active_flags.merge!({flag_key_for(flag_set) => (args.first ? (args.first.flag? or args.shift) : nil) })
      end
    end
    @active_flags
  end
  
  def flag_key_for(which)
    return which.to_sym if @potential_flags.member? which.to_sym
    try = @potential_flags.invert
    return try[which] if try.member? which
    return nil
  end

  def flag option, &blk
    set_flag  option
    set_block option, blk
  end
  alias key flag
  
  def flag_and_key option, &blk
    flag option, &blk
    option.each { |k, v| flag k, &blk }
  end
  
  def set_flag(option)
    if option.respond_to? :merge!
      @potential_flags.merge! option 
    else
      @potential_keywords << option
    end
  end

  def set_block(option, blk=nil)
    @associated_blocks||= {}
    blk ||= lambda{}
    tmp = {}
    if option.kind_of? Symbol
      tmp[option] = blk
    else
      option.each {|key, value| tmp[key] = blk}
    end
    @associated_blocks.merge! tmp
  end
  
  def process_flags(options)
    options.each { |key, value|
      @associated_blocks[key.to_sym][value] rescue help_docs
    }
  end

  def help_docs
    exit
  end
  
  def active_options
    active_flags.merge active_keys
  end
  def remaining_arguments
    @remaining_argument||[]
  end
  def remaining_argument
    @remaining_argument.join(' ')
  end

  def active_keys
    @active_keys || {}
  end

  def active_flags
    @active_flags || {}
  end
end


