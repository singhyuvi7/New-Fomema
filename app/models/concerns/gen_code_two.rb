module GenCodeTwo
  extend ActiveSupport::Concern

  included do
    def code_two(str)
      sum = 0
      str.each_byte do |c|
        sum = sum + c
      end
      while sum.to_s.length > 1 do
        sum2 = 0
        sum.to_s.each_char do |c|
          sum2 = sum2 + c.to_i
        end
        sum = sum2
      end
      return sum
    end
    # /code_two

    def code_full(str)
      "#{str[0,1]}#{code_two(str)}#{str[1..-1]}"
    end

    def code_full_prefix_two(str)
      "#{str[0,2]}#{code_two(str)}#{str[2..3]}#{str[5..-1]}"
    end

    # str1 = CODE_PREFIX | STATE_CODE | NAME_FIRST_CHAR | 6 digit sequence
    def code_gen(prefix, state, name)
      str = sprintf("#{prefix}#{state}#{name}%06d", get_or_create_sequence("code_#{prefix}#{state}#{name}_seq".downcase))
      case prefix.length
      when 1
        code_full(str)
      when 2
        code_full_prefix_two(str)
      else
        code_full(str)
      end
    end
  end
end