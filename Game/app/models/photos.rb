class Photos < ActiveRecord::Base
  def self.getRandImg
    n = Photos.count
    xx = rand(n)+1
    x = Photos.find_by id: xx
    @tags = x["tags"]
    return x["files"].split(',')
  end
  
  def self.chk(ans)
    if ans == @tags
      return true
    else
      return false
    end
  end
end
