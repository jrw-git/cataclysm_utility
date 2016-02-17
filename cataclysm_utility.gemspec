# Gemspec generated via script by John White at 2016-02-08 11:50:06 -0800
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = CataclysmUtility
  spec.version       = '1.0'
  spec.authors       = ["John White"]
  spec.email         = ["john@johnrw.com"]
  spec.summary       = %q{Short summary of your project}
  spec.description   = %q{Longer description of your project.}
  spec.homepage      = "https://github.com/jrw-git"
  spec.license       = "MIT"

  spec.files         = ['cataclysm_utility.rb']
  spec.executables   = ['cataclysm_utility.exe']
  spec.test_files    = ['tests/test_cataclysm_utility.rb']
  spec.require_paths = ["lib"]
end
