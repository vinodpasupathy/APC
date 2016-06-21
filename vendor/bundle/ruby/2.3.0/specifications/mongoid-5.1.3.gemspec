# -*- encoding: utf-8 -*-
# stub: mongoid 5.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid".freeze
  s.version = "5.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Durran Jordan".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDfDCCAmSgAwIBAgIBATANBgkqhkiG9w0BAQUFADBCMRQwEgYDVQQDDAtkcml2\nZXItcnVieTEVMBMGCgmSJomT8ixkARkWBTEwZ2VuMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTE1MTEwMzE0NTUwNFoXDTE2MTEwMjE0NTUwNFowQjEUMBIGA1UEAwwL\nZHJpdmVyLXJ1YnkxFTATBgoJkiaJk/IsZAEZFgUxMGdlbjETMBEGCgmSJomT8ixk\nARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANFdSAa8fRm1\nbAM9za6Z0fAH4g02bqM1NGnw8zJQrE/PFrFfY6IFCT2AsLfOwr1maVm7iU1+kdVI\nIQ+iI/9+E+ArJ+rbGV3dDPQ+SLl3mLT+vXjfjcxMqI2IW6UuVtt2U3Rxd4QU0kdT\nJxmcPYs5fDN6BgYc6XXgUjy3m+Kwha2pGctdciUOwEfOZ4RmNRlEZKCMLRHdFP8j\n4WTnJSGfXDiuoXICJb5yOPOZPuaapPSNXp93QkUdsqdKC32I+KMpKKYGBQ6yisfA\n5MyVPPCzLR1lP5qXVGJPnOqUAkvEUfCahg7EP9tI20qxiXrR6TSEraYhIFXL0EGY\nu8KAcPHm5KkCAwEAAaN9MHswCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0O\nBBYEFFt3WbF+9JpUjAoj62cQBgNb8HzXMCAGA1UdEQQZMBeBFWRyaXZlci1ydWJ5\nQDEwZ2VuLmNvbTAgBgNVHRIEGTAXgRVkcml2ZXItcnVieUAxMGdlbi5jb20wDQYJ\nKoZIhvcNAQEFBQADggEBAMwy++EdX3KKnivddRt3S9et0WVYusH2PwDRX9o4REcF\nmNcAtKnhN8OQ+irEGVNrqJFiHhUmuMo+v9FWJ5OA0/gKRUfFJAWj4WfBi3sRCPxv\n7Hmy3V7Cz+nLCdUl4uoe0bn6wY/zpX8tHCtcLBLCy2aQ0ijbDwA5TdlkV8q5vPId\nZS0pBTqHap4VMl2F63o6+qWdqhvikKM1NVYkTxUmvRlDjKM5sQAph7JOAaWjA6Fh\nZIvvwAhgCjVW5QCi2I1noxXLmtZ3XDawWu8kaGtu8giHXcwL3941m8hvFZ/Wr9Yi\nJvcXJt2a4/JvwnIs2hmKuyfhZmB9HEE5wQQaCMnnC14=\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2016-04-21"
  s.description = "Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby.".freeze
  s.email = ["mongodb-dev@googlegroups.com".freeze]
  s.homepage = "http://mongoid.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubyforge_project = "mongoid".freeze
  s.rubygems_version = "2.6.4".freeze
  s.summary = "Elegant Persistence in Ruby for MongoDB.".freeze

  s.installed_by_version = "2.6.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>.freeze, ["~> 4.0"])
      s.add_runtime_dependency(%q<tzinfo>.freeze, [">= 0.3.37"])
      s.add_runtime_dependency(%q<mongo>.freeze, ["~> 2.1"])
      s.add_runtime_dependency(%q<origin>.freeze, ["~> 2.2"])
    else
      s.add_dependency(%q<activemodel>.freeze, ["~> 4.0"])
      s.add_dependency(%q<tzinfo>.freeze, [">= 0.3.37"])
      s.add_dependency(%q<mongo>.freeze, ["~> 2.1"])
      s.add_dependency(%q<origin>.freeze, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<activemodel>.freeze, ["~> 4.0"])
    s.add_dependency(%q<tzinfo>.freeze, [">= 0.3.37"])
    s.add_dependency(%q<mongo>.freeze, ["~> 2.1"])
    s.add_dependency(%q<origin>.freeze, ["~> 2.2"])
  end
end
