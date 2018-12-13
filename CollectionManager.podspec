

Pod::Spec.new do |s|

 	s.name         = "CollectionManager"
	s.version      = "1.0.0"
	s.summary      = "Declarative & Reusable creation and management of CollectionViews"
	s.description  = "A declarative way to create CollectionViews with advanced Diffing features and ability for automatic loading and reloading of sections and items"
	s.homepage     = "http://raywenderlich.com"

   	s.license      = "MIT"
 
  	s.author             = { "DavidKmn" => "davidk.9889@gmail.com" }
  
   	s.platform     = :ios, "10.0"
  	
	s.source       = { :git => "https://github.com/DavidKmn/CollectionManager.git", :tag => "#{s.version}" }


    	s.source_files  = "CollectionManager"

	s.swift_version = "4.2" 


end
