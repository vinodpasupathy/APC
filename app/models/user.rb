class User
  include Mongoid::Document
  field :name
  field :password
 validates:name, :presence=>true,:uniqueness=>true
 validates:password, :presence=>true,length: {in: 6..12}
end
