class Organization < ApplicationRecord
    audited
    include CaptureAuthor

    extend ActsAsTree::TreeView
    extend ActsAsTree::TreeWalker
    acts_as_tree order: 'name'

    TYPES = {
        'HEADQUARTER' => "Headquarter", 
        'BRANCH' => "Branch", 
        "WAREHOUSE" => "Warehouse"
    }

    STATUSES = {
        'ACTIVE' => "Active", 
        'INACTIVE' => "Inactive"
    }

    belongs_to :parent, :class_name => "Organization", optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :zone, optional: true
    has_many :childs, class_name: "Organization", foreign_key: "parent_id"
    has_many :users, as: :userable

    scope :active, -> { where(status: "ACTIVE") }
    scope :inactive, -> { where(status: "INACTIVE") }

    validates :name, :address1, :state_id, :town_id, :postcode, :phone, :email, presence: true, if: Proc.new {|e| e.status != "INACTIVE" }
    validate :validate_code

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('organizations.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('organizations.name ILIKE ?', "%#{name}%")
    end

    def self.search_status(status)
        return all if status.blank?
        status = status.strip
        where('organizations.status = ?', status)
    end

    def create_user(skip_confirmation: nil, role_id: nil, email: nil, name: nil, username: nil, password: nil, title_id: nil)
        if role_id.nil?
            raise "Role is required"
        end
        data = {
            username: username.upcase,
            name: name.nil? ? username : name,
            email: email || self.email,
            userable: self,
            role_id: role_id,
            password: password || "!aB2" + SecureRandom.hex(8)
        }
        if (!title_id.nil?)
            data[:title_id] = title_id
        end
        user = User.new(data)

        user.skip_confirmation! if skip_confirmation
        user.save!
    end

    # recursive function to create tree object
    def to_node
        { "attributes" => self.attributes,
        "children"   => self.children.map { |c| c.to_node }
        }
    end

    def validate_code
        if self.org_type == 'BRANCH'
            if self.code.blank?
                errors.add :code, "is required"
            end
            if Organization.where.not(id: self.id).where("code ilike ?", self.code).count > 0
                errors.add :code, "has already been taken"
            end
        end
    end

end
