# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{transitions}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jakub Ku\305\272ma"]
  s.date = %q{2010-09-21}
  s.description = %q{Lightweight state machine extracted from ActiveModel}
  s.email = %q{qoobaa@gmail.com}
  s.files = [".gitignore", "Gemfile", "Gemfile.lock", "LICENSE", "README.rdoc", "Rakefile", "lib/active_record/transitions.rb", "lib/transitions.rb", "lib/transitions/event.rb", "lib/transitions/machine.rb", "lib/transitions/state.rb", "lib/transitions/state_transition.rb", "lib/transitions/version.rb", "test/helper.rb", "test/test_active_record.rb", "test/test_event.rb", "test/test_event_arguments.rb", "test/test_event_being_fired.rb", "test/test_machine.rb", "test/test_state.rb", "test/test_state_transition.rb", "test/test_state_transition_guard_check.rb", "transitions.gemspec"]
  s.homepage = %q{http://github.com/qoobaa/transitions}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{transitions}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{State machine extracted from ActiveModel}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1"])
      s.add_development_dependency(%q<test-unit>, ["~> 2"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, ["~> 3"])
    else
      s.add_dependency(%q<bundler>, ["~> 1"])
      s.add_dependency(%q<test-unit>, ["~> 2"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<activerecord>, ["~> 3"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1"])
    s.add_dependency(%q<test-unit>, ["~> 2"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<activerecord>, ["~> 3"])
  end
end
