require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "webairplay"
VERSION = "0.5.0"
TRAVELING_RUBY_VERSION = "20150210-2.2.0"
# SQLITE3_VERSION = "1.3.9"  # Must match Gemfile

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install,
        "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz",
        # "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-sqlite3-#{SQLITE3_VERSION}.tar.gz"
      ] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install,
        "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
        # "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-sqlite3-#{SQLITE3_VERSION}.tar.gz"
      ] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install,
      "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz",
      # "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-sqlite3-#{SQLITE3_VERSION}.tar.gz"
    ] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -rf packaging/tmp"
    # sh "rm -f packaging/vendor/*/*/cache/*"
    # sh "rm -rf packaging/vendor/ruby/*/extensions"
    # sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    # sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    # sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  end

  task :osx_app do
    target = 'osx'
    package_dir = "release/#{PACKAGE_NAME}-#{VERSION}-#{target}"

    files = [
      'hello',
      'lib',
    ]
    files = files.map { |path| File.absolute_path(path, package_dir) }
    file_args = files.map { |path| ['-f', path] }.flatten

    sh('/usr/local/bin/platypus',
      '-a WebAirplay',
      '-o', 'Text Window',
      '-p', '/bin/bash',
      '-V', '0.5.0',
      '-u', 'Anton Katunin',
      '-I', 'org.anton.WebAirplay',
      '-R',
      *file_args,
      '-y',
      # '-O',
      files.first,
      "release/WebAirplay-#{VERSION}.app"
    )
  end
end



file "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end



# file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-sqlite3-#{SQLITE3_VERSION}.tar.gz" do
#   download_native_extension("linux-x86", "sqlite3-#{SQLITE3_VERSION}")
# end
#
# file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-sqlite3-#{SQLITE3_VERSION}.tar.gz" do
#   download_native_extension("linux-x86_64", "sqlite3-#{SQLITE3_VERSION}")
# end
#
# file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-sqlite3-#{SQLITE3_VERSION}.tar.gz" do
#   download_native_extension("osx", "sqlite3-#{SQLITE3_VERSION}")
# end

def create_package(target)
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  package_dir = "release/#{package_name}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"

  files = [
    'app.rb',
    'main.rb',
    'lib',
    'views',
    'public'
  ]
  files.each do |file|
    sh "cp -R #{file} #{package_dir}/lib/app/#{file}"
  end

  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/wrapper.sh #{package_dir}/hello"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  # sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-sqlite3-#{SQLITE3_VERSION}.tar.gz " +
  #     "-C #{package_dir}/lib/vendor/ruby"

  if !ENV['DIR_ONLY']
    sh "rm -rf #{package_dir}.tar.gz"
    if target == 'osx'
      Rake::Task["package:osx_app"].invoke

      # sh "rm -rf #{package_dir}.zip"
      # cd 'release' do
      #   sleep 3
      #   sh "zip -r #{package_name}.zip ./WebAirplay-#{VERSION}.app"
      # end

      sh "tar -czf #{package_dir}.tar.gz release/WebAirplay-#{VERSION}.app"
      sh "rm -rf release/WebAirplay-#{VERSION}.app"
    else
      sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
    end
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "cd tmp && curl -L -O --fail " +
      "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def download_native_extension(target, gem_name_and_version)
  sh "curl -L --fail -o packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz " +
      "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{target}/#{gem_name_and_version}.tar.gz"
end
