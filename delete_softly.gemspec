# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delete_softly}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benjamin ter Kuile"]
  s.date = %q{2010-12-17}
  s.description = %q{Add soft delete functionality to your ActiveRecord models}
  s.email = %q{bterkuile@gmail.com}
  s.extra_rdoc_files = ["README", "lib/class_methods.rb", "lib/delete_softly.rb", "lib/instance_methods.rb"]
  s.files = ["MIT-LICENSE", "README", "Rakefile", "delete_softly.gemspec", "init.rb", "install.rb", "lib/class_methods.rb", "lib/delete_softly.rb", "lib/instance_methods.rb", "test/delete_softly_test.rb", "test/test_helper.rb", "uninstall.rb", "Manifest"]
  s.homepage = %q{http://github.com/bterkuile/delete_softly}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Delete_softly", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{delete_softly}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Add soft delete functionality to your ActiveRecord models}
  s.test_files = ["test/delete_softly_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.3.0') then
      s.add_runtime_dependency(%q<meta_where>, [">= 0"])
    else
      s.add_dependency(%q<meta_where>, [">= 0"])
    end
  else
    s.add_dependency(%q<meta_where>, [">= 0"])
  end
end
