#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                = "SQLConnect"
  s.version             = "1.2.0"
  s.summary             = "Connects apps to SQL Server"
  s.description         = <<-DESC
                            A library for connecting Objective-C & Swift apps to SQL Server
                        DESC
  s.homepage            = "http://importblogkit.com"
  s.license             = 'MIT'
  s.authors             = { "Nick Griffith" => "nhgrif@gmail.com" }
  s.social_media_url    = 'https://twitter.com/importBlogKit'
  s.source              = { :git => "https://github.com/nhgrif/SQLConnect.git", :tag => s.version.to_s }

  s.platform                = :ios, '8.0'
  s.ios.deployment_target   = '8.0'
  s.requires_arc            = true
  s.public_header_files     = 'SQLConnect/*.h', 'SQLConnect/SQLSettings/*.h', 'SQLConnect/SQLControllers/*.h', 'SQLConnect/SQLConnection/*.h'
  s.source_files            = 'SQLConnect/**/*.{h,m}'
  s.preserve_paths          = 'SQLConnect/**/*.*'
  s.vendored_libraries      = 'SQLConnect/FreeTDS/libfreetds.a'
  s.=libraries              = 'iconv'
  s.xcconfig                = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/SQLConnect/**" }
end
