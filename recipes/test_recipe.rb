directory 'C:\testfiles' do
  action :create
end

file 'C:\testfiles\testfile_a.txt' do
  action :create
  content 'Test File A'
end

file 'C:\testfiles\testfile_b.txt' do
  action :create
  content 'Test File B'
end

file 'C:\testfiles\testfile_c.txt' do
  action :create
  content 'Test File C'
end

directory_sync_copy 'C:\derp' do
  source 'C:\testfiles'
end
