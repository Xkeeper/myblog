module ApplicationHelper
  def author
    Struct.new(:name, :email).new(enki_config[:author][:name], enki_config[:author][:email])
  end
end
