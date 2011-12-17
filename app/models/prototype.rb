class Prototype
  include Mongoid::Document
  field :name, :type => String
  field :states, :type => Array
  field :methods, :type => Array
  field :events, :type => Array
  field :ancestors, :type => Array
  field :parent, :type => String

  @@types = Array["Light","Computer","Refrigerator","Coffee Machine"]

  def self.types
    @@types
  end

end
