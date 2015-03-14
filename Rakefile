require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


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
    task :x86 => [:build,
        "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz",
      ] do
      create_package("linux-x86")
      compress 'linux-x86'
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:build,
        "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
      ] do
      create_package("linux-x86_64")
      compress 'linux-x86_64'
    end
  end

  desc "Package your app for OS X"
  task :osx => [:build,
      "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz",
    ] do
    create_package("osx")
    build_osx_app
  end

  task :build => [
      'assets:precompile',
      :bundle_install
    ]

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development test assets"
    end
    sh "rm -rf packaging/tmp"
    # sh "rm -f packaging/vendor/*/*/cache/*"
    # sh "rm -rf packaging/vendor/ruby/*/extensions"
    # sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    # sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    # sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  end
end


rule /tmp\/traveling-ruby-.+\.tar\.gz/ do |t|
  sh "cd tmp && curl -L -O --fail " +
      "http://d6r77u77i8pq3.cloudfront.net/releases/#{t.name}"
end

def build_osx_app
  target = 'osx'
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  package_dir = "release/#{package_name}"

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
    '-V', VERSION,
    '-u', 'Anton Katunin',
    '-I', 'org.anton.WebAirplay',
    '-R',
    *file_args,
    '-y',
    files.first,
    "release/WebAirplay-#{VERSION}.app"
  )

  cd 'release' do
    sh "tar -czf #{package_name}.tar.gz WebAirplay-#{VERSION}.app"
  end
  # sh "rm -rf release/WebAirplay-#{VERSION}.app"
end

def create_package(target)
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  package_dir = "release/#{package_name}"
  sh "rm -rf #{package_dir}"
  sh "mkdir -p #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"

  files = [
    'app',
    'bin',
    'config',
    'db',
    'lib',
    'public',
    'vendor',
    'main.rb',
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
end

def compress target
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  package_dir = "release/#{package_name}"

  if !ENV['DIR_ONLY']
    sh "rm -rf #{package_dir}.tar.gz"
    if target == 'osx'

    else
      sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
    end
    sh "rm -rf #{package_dir}"
  end

end
