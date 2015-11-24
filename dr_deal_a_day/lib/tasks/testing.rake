Rake::Task[:default].clear

task :default do
  Rails.configuration.test_frameworks.each do |framework|
    sh "rake #{framework}" do
      # ignore any errors so we can run multiple if we want
    end
  end
end
