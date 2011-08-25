Gem::Specification.new do |s|
  s.name = "cfiber"
  s.author = "Jean-Denis Vauguet <jd@vauguet.fr>"
  s.email = "jd@vauguet.fr"
  s.homepage = "http://www.github.com/chikamichi/cfiber"
  s.summary = "Ruby Fibers using Ruby Continuations"
  s.description = "Continuations used to implement Fibers as provided by Ruby 1.9. Works in 1.8 as well."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "README.md", "CHANGELOG.md"]
  s.version = '0.0.1'
  s.add_development_dependency 'logg'
end
