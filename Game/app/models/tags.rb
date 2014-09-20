class Tags < ActiveRecord::Base
  validates_presence_of :tag
  validates_presence_of :freq
  validates_uniqueness_of :tag
  
  def self.getRandTag
    n = Tags.count
    while true
      xx = rand(n)+1
      x = Tags.find_by id: xx
      @currTag = x["tag"]
      if(x["freq"]>=4)
        break
      end
    end
    return x["tag"]
  end  
end
