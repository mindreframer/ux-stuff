desc 'Start Jekyll server and watch Sass files'
task :serve do
  puts "Starting the Jekyll server and watching Sass files."
  jekyllPid = Process.spawn('jekyll serve --watch')
  sassPid = Process.spawn('sass --watch stylesheets/scss:stylesheets')

  trap("INT") {
    [jekyllPid, sassPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, sassPid].each { |pid| Process.wait(pid) }
end

