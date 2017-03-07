# # encoding: utf-8

# Inspec test for recipe directory_sync::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('C:\testfiles') do
  it { should exist }
  it { should be_directory }
end

describe file('C:\testfiles\testfile_a.txt') do
  it { should exist }
end

describe file('C:\derp') do
  it { should exist }
  it { should be_directory }
end

describe file('C:\derp\testfile_a.txt') do
  it { should exist }
end
