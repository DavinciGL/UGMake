require 'digest'

def verify(file, checksum_file)
  unless File.exist?(file) && File.exist?(checksum_file)
    puts "ERROR: Missing file or checksum"
    exit 1
  end

  actual = Digest::SHA256.file(file).hexdigest
  expected = File.read(checksum_file).strip

  if actual == expected
    puts "Checksum OK"
  else
    puts "Checksum MISMATCH"
    puts "Expected: #{expected}"
    puts "Actual:   #{actual}"
    exit 2
  end
end

if ARGV[0] == "--verify"
  verify(ARGV[1], ARGV[2])
end
