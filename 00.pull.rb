#!/usr/bin/env ruby
##### inspired by:
## http://code.dimilow.com/git-subtree-notes-and-workflows/

if ARGV[0]
  PROJECTS = []
  PROJECTS << ARGV[0]
else
  PROJECTS = File.read("projects.txt").split("\n").sort_by{|x| x.downcase}
end

def remote_name(git_url)
  cleanup_str("remote_#{git_url.split("/").last[0..-5]}")
end

def name(git_url)
  path = git_url.split("//").last
  path = path.gsub(/\.git$/, "")
end

def add_remote(git_url)
  cmd = "git remote add #{remote_name(git_url)} #{git_url}"
  execute(cmd)
end

def add_project(git_url)
  ensure_folder_exists(git_url)
  #cmd = "git subtree add --prefix=#{name(git_url)} --squash #{git_url} #{branch_name(git_url)}"
  cmd = "git subtree add -P #{name(git_url)} --squash #{remote_name(git_url)}/#{branch_name(git_url)}"
  execute(cmd)
end

def ensure_folder_exists(git_url)
  cmd =  "mkdir -p #{File.dirname(name(git_url))}"
  execute(cmd)
end

def fetch_project(git_url)
  cmd =  "git fetch #{remote_name(git_url)}"
  execute(cmd)
end

def branch_name(git_url)
  # TODO: proper handling for branch names, right now hardcoded
  git_url =~ /Effeckt|beautiful\-web\-type/ ? "gh-pages" : "master"
end

def update_project(git_url)
  cmd = "git subtree pull --prefix #{name(git_url)} --squash #{git_url} #{branch_name(git_url)}"
  execute(cmd)
end

def handle_project(git_url)
  if File.exist?(name(git_url))
    update_project(git_url)
  else
    add_remote(git_url)
    fetch_project(git_url)
    add_project(git_url)
  end
end

def execute(cmd)
  puts cmd
  `#{cmd}`
end

def cleanup_str(str)
  str.gsub(".", "_").downcase
end

### update projects
PROJECTS.each do |p| handle_project(p) end
