class ApplicationService
    def self.call(*args, &block)
        new(*args, &block).call
    end
    
    private
    def self.vd(*p2)
        require 'pp'
        puts "=============== vd start ==============="
        p2.each.with_index do |p, index|
            puts "" if index > 0
            puts p.class
            pp p
        end
        puts "=============== vd end   ==============="
    end
    
    def self.flash_add(key, message)
        if key.to_s == key.to_s.pluralize
            flash[key] = [] if !flash[key]
            flash[key] << message
        else
            flash[key] = message
        end
    end
end