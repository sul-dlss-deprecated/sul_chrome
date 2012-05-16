module SulChrome::Controller
  def self.included(base)
    base.send :layout, :which_layout
  end
  
  protected
  
  def which_layout
    "sul_chrome/application"
  end
end