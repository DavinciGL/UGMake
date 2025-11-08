# resolve_deps.rb

def parse_deps(file)
  lines = File.readlines(file).map(&:strip)
  graph = {}
  current_task = nil

  lines.each do |line|
    if line =~ /^(\w+)\s+deps:$/
      current_task = $1
      graph[current_task] ||= []
    elsif current_task && !line.empty?
      graph[current_task] << line
    end
  end

  graph
end

def resolve(task, graph, visited = [], result = [])
  return if visited.include?(task)
  visited << task
  (graph[task] || []).each { |dep| resolve(dep, graph, visited, result) }
  result << task
end

def generate_gmake_file(path)
  files = Dir.entries(path).select { |f| File.file?(File.join(path, f)) }
  gmake = []

  # Detect languages and assign compilers or commands
  go_files = files.select { |f| f.end_with?(".go") }
  c_files = files.select { |f| f.end_with?(".c") }
  cpp_files = files.select { |f| f.end_with?(".cpp") }
  py_files = files.select { |f| f.end_with?(".py") }
  java_files = files.select { |f| f.end_with?(".java") }

  # Go
  unless go_files.empty?
    gmake << "# Go build tasks\n"
    go_files.each do |file|
      name = File.basename(file, ".go")
      gmake << "task build_#{name}:\n"
      gmake << "go build #{file}\n\n"
    end
  end

  # C
  unless c_files.empty?
    gmake << "$compiler = gcc\n\n"
    c_files.each do |file|
      name = File.basename(file, ".c")
      gmake << "task build_#{name}:\n"
      gmake << "$compiler #{file} -o #{name}.out\n\n"
    end
  end

  # C++
  unless cpp_files.empty?
    gmake << "$compiler = g++\n\n"
    cpp_files.each do |file|
      name = File.basename(file, ".cpp")
      gmake << "task build_#{name}:\n"
      gmake << "$compiler #{file} -o #{name}.out\n\n"
    end
  end

  # Python
  unless py_files.empty?
    py_files.each do |file|
      name = File.basename(file, ".py")
      gmake << "task run_#{name}:\n"
      gmake << "python #{file}\n\n"
    end
  end

  # Java
  unless java_files.empty?
    java_files.each do |file|
      name = File.basename(file, ".java")
      gmake << "task build_#{name}:\n"
      gmake << "javac #{file}\n\n"
    end
  end

  File.write("GMake", gmake.join)
end


# Entry point
if ARGV[0] == "--init"
  path = ARGV[1] || "."
  generate_gmake_file(path)
  puts "GMake file generated in #{path}"
  exit
end

# Dependency resolution
def parse_deps(file)
  lines = File.readlines(file).map(&:strip)
  graph = {}
  current_task = nil

  lines.each do |line|
    if line =~ /^(\w+)\s+deps:$/
      current_task = $1
      graph[current_task] ||= []
    elsif current_task && !line.empty?
      graph[current_task] << line
    end
  end

  graph
end

def resolve(task, graph, visited = [], result = [])
  return if visited.include?(task)
  visited << task
  (graph[task] || []).each { |dep| resolve(dep, graph, visited, result) }
  result << task
end

file = ARGV[0]
target = ARGV[1]
graph = parse_deps(file)

result = []
resolve(target, graph, [], result)
puts result.join("\n")

result = []
resolve(target, graph, [], result)
puts result.join("\n")

