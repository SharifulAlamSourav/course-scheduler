class University < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence :name, :message => "Name is not present"
    validates_unique   :name, :message => "Name is already taken"
  end
end
