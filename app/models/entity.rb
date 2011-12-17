class Entity
  include Mongoid::Document

  field :name, :type => String
  field :livePulseID, :type => String
  field :desc, :type => String
  field :uri, :type => String
  field :type, :type => String
  field :subtype, :type => String
  field :states
  field :methods
  field :events
  field :triggers, :type => Array
  field :ownership, :type => String
  field :ancestors, :type => Array
  field :parent, :type => String
  field :coordinates, :type => String
  field :dimensions, :type => String
  has_many :readings, :class_name => 'Energy'
  has_and_belongs_to_many :users, :class_name => 'User'
  
  @@ownershipTypes = Array["Private","Public"]

  before_validation do
    self.name = self.name.gsub(/\s+/, "-").gsub(/[^\w-]/, "-").downcase    
    self.livePulseID = self.livePulseID.upcase.gsub(/\s+/, "")
  end


  def self.ownershipTypes
    @@ownershipTypes
  end
  
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end

  def self.all_spaces
    @allCurrentSpacesArray = Entity.where(:type => "space")
    @allCurrentSpaces = Array.new
    @allCurrentSpacesArray.each do |space|
      ancestors = space.ancestors
      path = ""
      ancestors.each do |ancestor|
        path = path + "/" + ancestor
      end
      path = path + "/" + space.name
      @allCurrentSpaces << path
    end
    return @allCurrentSpaces
  end
  def self.all_thing_types
    return Prototype.any_in(ancestors:['thing']).to_a.collect{|x| x.name}
  end
  def self.all_space_types
    return Prototype.any_in(ancestors:['space']).to_a.collect{|x| x.name}
  end
  validates_presence_of :name, :uri, :type, :subtype
  attr_accessible :name, :livePulseID, :desc, :uri, :type, :subtype, :states, :methods, :events, :triggers, :ownership, :ancestors, :parent, :coordinates, :dimensions
end
