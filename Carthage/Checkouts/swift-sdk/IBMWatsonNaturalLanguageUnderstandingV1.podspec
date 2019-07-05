Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonNaturalLanguageUnderstandingV1'
  s.version               = '2.1.1'
  s.summary               = 'Client framework for the IBM Watson Natural Language Understanding service'
  s.description           = <<-DESC
IBM Watson™ Natural Language Understanding can analyze semantic features of text input,
including categories, concepts, emotion, entities, keywords, metadata, relations, semantic roles, and sentiment.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/natural-language-understanding/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'NaturalLanguageUnderstanding'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/NaturalLanguageUnderstandingV1/**/*.swift',
                            'Source/SupportingFiles/InsecureConnection.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/NaturalLanguageUnderstandingV1/Shared.swift'

  s.swift_version         = '4.2'
  s.dependency              'IBMWatsonRestKit', '~> 3.0.0'

end
