class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def vd(*p2)
      require 'pp'
      puts "=============== vd start ==============="
      p2.each.with_index do |p, index|
          puts "" if index > 0
          puts p.class
          pp p
      end
      puts "=============== vd end   ==============="
  end

  def vdr(p)
      p.pretty_inspect
  end
end
