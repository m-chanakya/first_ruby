class Images < ActiveRecord::Base
  def self.getRandImg(currTag)
    tmp = Images.all
    arr = []
    tmp.each do |t|
      puts currTag
      if t.tags.split(",").index(currTag)
        arr << t.name
      end
    end
    return arr
  end
  
  def self.chk(session, ans)
    img1 = session[:img1]
    img2 = session[:img2]
    img3 = session[:img3]
    img4 = session[:img4]
    t1 = Images.find_by name: img1
    t2 = Images.find_by name: img2
    t3 = Images.find_by name: img3
    t4 = Images.find_by name: img4
    if (t1["tags"].split(",").index(ans) != nil) and (t3["tags"].split(",").index(ans) != nil) and (t3["tags"].split(",").index(ans) != nil) and (t4["tags"].split(",").index(ans) != nil)
      return true
    else
      return false
    end
  end
  
end
