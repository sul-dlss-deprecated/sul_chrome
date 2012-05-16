# -*- encoding : utf-8 -*-
require 'rails/generators'
require 'rails/generators/migration'     
class SulChromeGenerator < Rails::Generators::Base

    #source_root File.expand_path('../templates', __FILE__)


    desc """
  This generator makes the following changes to your application:
   1. Adds Controller behavior to the application level ApplicationController.
   2. Adds a line in your application.css and application.js to load the SUL Chrome assets.
   3. Adds necessary lines into the application level Gemfile.
         """ 

    # Add SulChrome to the application controller.
    def inject_sul_chrome_controller_behavior   
      unless IO.read("app/controllers/application_controller.rb").include?("SulChrome::Controller")
        inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
          "  # Adds a few additional behaviors into the application controller\n" +        
          "  include SulChrome::Controller\n\n"
        end
      end
    end
  
    # insert require statements into application level CSS/JS manifestes.
    def assets
      unless IO.read("app/assets/stylesheets/application.css").include?("Required by SULChrome")
        insert_into_file "app/assets/stylesheets/application.css", :after => "/*" do
  %q{
 * Required by SULChrome:
 *= require sul_chrome/sul_chrome_base
 *}
        end
      end
      unless IO.read("app/assets/javascripts/application.js").include?("Required by SULChrome")
        insert_into_file "app/assets/javascripts/application.js", :before => "//= require_tree ." do
%q{// Required by SULChrome:
//= require sul_chrome/sul_chrome_base
}
       end
     end
    end
    
    # insert required dependencies into Gemfile
    def gemfile
      g_file = IO.read("Gemfile")
      unless g_file.include?("compass-rails")
        insert_into_file "Gemfile", :after => /^.*sul_chrome.*$/ do
          "\ngem 'compass-rails', :group => :assets\n"
        end
      end
      unless g_file.include?("compass_twitter_bootstrap")
        insert_into_file "Gemfile", :after => /^.*sul_chrome.*$/ do
          "\ngem 'compass_twitter_bootstrap', :group => :assets \n"
        end
      end
    end
    
end
