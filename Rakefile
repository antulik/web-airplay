require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

# For Bundler.with_clean_env
require 'bundler/setup'
require_relative 'lib/web_airplay'

PACKAGE_NAME = "webairplay"
VERSION = WebAirplay::VERSION
TRAVELING_RUBY_VERSION = "20150210-2.2.0"
# SQLITE3_VERSION = "1.3.9"  # Must match Gemfile

desc "Package app"
task :package => ['package:linux-x86', 'package:linux-x86_64', 'package:osx']

namespace :package do
  desc "Package your app for Linux x86"
  task 'linux-x86' => 'linux-x86:compressed'

  desc "Package your app for Linux x86_64"
  task 'linux-x86_64' => 'linux-x86_64:compressed'

  desc "Package your app for OS X"
  task :osx => 'osx:dot_app'

  namespace :osx do
    task :dot_app => :build do
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
        '-o', 'Progress Bar',
        # '-o', 'Text Window',
        '-p', '/bin/bash',
        '-V', VERSION,
        '-u', 'Anton Katunin',
        '-I', 'org.anton.WebAirplay',
        '-i', 'packaging/logo.icns',
        '-R',
        *file_args,
        '-y',
        files.first,
        "release/WebAirplay-#{VERSION}.app"
      )

      cd 'release' do
        sh "tar -czf #{package_name}.tar.gz WebAirplay-#{VERSION}.app"
      end
    end
  end

  task :clean_data do
    sh "rm -f db/data.pstore"
  end

  desc "Install gems to local directory"
  task :bundle => 'bundle:default'

  namespace :bundle do
    task :default => [
        # :clean,
        :install,
        :free_space
      ]

    task :clean do
      sh 'rm -rf packaging/vendor'
    end

    task :install do
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
    end

    task :free_space do
      # sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
      sh "rm -f packaging/vendor/*/*/cache/*"
      sh "rm -rf packaging/vendor/ruby/*/extensions"
      sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
      sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
    end
  end

  ['osx', 'linux-x86_64', 'linux-x86'].each do |target|
    package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
    package_dir = "release/#{package_name}"

    namespace target do
      task :build => [
          :clean_data,
          'assets:precompile',
          :bundle,
          :folder,
          :app,
          :ruby,
          :vendor,
        ]

      task :compressed => :build do
        cd 'release' do
          sh "rm -rf #{package_name}.tar.gz"
          sh "tar -czf #{package_name}.tar.gz #{package_name}"
          # sh "rm -rf #{package_name}"
        end
      end

      task :folder do
        sh "rm -rf #{package_dir}"
        sh "mkdir -p #{package_dir}"

        sh "cp packaging/wrapper.sh #{package_dir}/hello"
      end

      task :ruby => [
          "tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
      ] do
        sh "mkdir #{package_dir}/lib/ruby"
        sh "tar -xzf tmp/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
      end

      task :app do
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
      end

      task :vendor do
        sh "cp -pR packaging/vendor #{package_dir}/lib/"
        sh "cp Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
        sh "mkdir #{package_dir}/lib/vendor/.bundle"
        sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
      end

    end
  end
end

rule /tmp\/traveling-ruby-.+\.tar\.gz/ do |t|
  sh "cd tmp && curl -L -O --fail " +
      "http://d6r77u77i8pq3.cloudfront.net/releases/#{t.name}"
end
