class Trigger 
  include Mongoid::Document

  field :name, :type => String
  field :description, :type => String
  field :triggering_entity, :type => String
  field :triggering, :type => Hash
  field :triggered_entity, :type => String
  field :triggered, :type => Hash
  field :owner, :type => String 
  referenced_in :user
 
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end

  validates_presence_of :name, :triggering_entity, :triggering, :triggered_entity, :triggered, :owner
  attr_accessible :name, :description, :triggering_entity, :triggering, :triggered_entity, :triggered, :owner
 
  index(
    [
      "triggering_entity", "triggering.name", "triggering.type", "triggering.args"
    ]
  )
end
