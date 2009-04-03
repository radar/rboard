garlic do
  repo 'nested_has_many_through', :path => '.'
  
  repo 'rails', :url => 'git://github.com/rails/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails'
  
  # target rails versions
  ['origin/2-2-stable', 'origin/2-1-stable', 'origin/2-0-stable'].each do |rails|
    # specify how to prepare app and run CI task
    target "Rails: #{rails}", :tree_ish => rails do
      prepare do
        plugin 'rspec'
        plugin 'rspec-rails' do
          `script/generate rspec -f`
        end
        plugin 'nested_has_many_through', :clone => true
      end

      run do
        cd "vendor/plugins/nested_has_many_through" do
          sh "rake spec:rcov:verify"
        end
      end
    end
  end
end
