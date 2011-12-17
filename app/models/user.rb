class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
  before_save :ensure_authentication_token

  field :name
  field :email
  field :ancestors, default: Array.new
  field :parent
  field :liveLinkID
  field :username
  field :group  
  field :uri  
  field :phone_number
  field :token_authenticatable
  references_many :triggers
  has_and_belongs_to_many :states, :class_name => 'State'
  has_and_belongs_to_many :friends, :class_name => 'User'
  has_and_belongs_to_many :entities, :class_name => 'Entity'
  def spaces
    return entities.where(:type => 'space')
  end
  def things
    return entities.where(:type => 'thing')
  end

  before_validation do
    if self.username
      self.username = self.username.gsub(/\s+/, "-").gsub(/[^\w-]/, "-").downcase
    end 
    if self.liveLinkID
      self.liveLinkID = self.liveLinkID.upcase.gsub(/\s+/, "")
    end
    if self.group
      self.group = self.group.downcase
    end
    if self.uri
      self.uri = self.uri.downcase
    end # self.phone_number = self.phone_number.gsub(/\D/, '')
  end
  before_save do
    # self.phone_number = self.phone_number.gsub(/\D/, '')
    if self.username
      self.username = self.username.gsub(/\s+/, "-").gsub(/[^\w-]/, "-").downcase
    end 
    if self.liveLinkID
      self.liveLinkID = self.liveLinkID.upcase.gsub(/\s+/, "")
    end
    if self.group
      self.group = self.group.downcase
    end
    if self.uri
      self.uri = self.uri.downcase
    end
  end
  validates_length_of :phone_number, :is => 11, :message => "must be 11 digits"
  validates_numericality_of :phone_number, :message => "must be 11 digit number"
  validates_presence_of :name, :email, :username, :group, :phone_number
  validates_uniqueness_of :name, :email, :username, :liveLinkID, :phone_number, :case_sensitive => false
  attr_accessible :friends, :uri, :triggers, :name, :users, :email, :password, :password_confirmation, :remember_me, :entities, :ancestors, :parent, :liveLinkID, :username, :group, :phone_number
  @@all_groups = Array["/msra/mass", "/msra/websm", "/msra/university", "/msra/graphics", "/msra/media", "/msra/innovative", "/msra/hardware", "/msra/search"]

  def self.all_groups
    return @@all_groups

  end
  #def username=(val)
  #  write_attribute(:username, val.downcase)
  #end 

end

