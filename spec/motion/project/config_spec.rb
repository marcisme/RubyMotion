require 'rake'
require 'motion/project/config'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
end

module Motion
  module Project
    describe Config do
      describe '#spec_files' do

        def ep(path); File.expand_path(path); end

        before(:each) { FileUtils.mkpath('lib/motion') }
        before(:each) { ENV['files'] = nil }

        let(:config) { Config.new('.', :development) }

        context 'with spec in top-level directory' do

          before(:each) do
            FileUtils.mkpath('spec')
            FileUtils.touch('spec/foo_spec.rb')
          end

          it 'finds spec with no filter' do
            config.spec_files.should == [ep('spec.rb'), ep('spec/foo_spec.rb')]
          end

          it 'finds spec with name filter' do
            ENV['files'] = 'foo_spec'
            config.spec_files.should == [ep('spec.rb'), ep('spec/foo_spec.rb')]
          end

          it 'finds spec with file filter' do
            ENV['files'] = 'spec/foo_spec.rb'
            config.spec_files.should == [ep('spec.rb'), ep('spec/foo_spec.rb')]
          end

        end

        context 'with spec in sub-directory' do

          before(:each) do
            FileUtils.mkpath('spec/bar')
            FileUtils.touch('spec/bar/bar_spec.rb')
          end

          it 'finds spec with no filter' do
            config.spec_files.should == [ep('spec.rb'), ep('spec/bar/bar_spec.rb')]
          end

          it 'finds spec with name filter' do
            ENV['files'] = 'bar_spec'
            config.spec_files.should == [ep('spec.rb'), ep('spec/bar/bar_spec.rb')]
          end

          it 'finds spec with file filter' do
            ENV['files'] = 'spec/bar/bar_spec.rb'
            config.spec_files.should == [ep('spec.rb'), ep('spec/bar/bar_spec.rb')]
          end

        end

        context 'with spec and helper' do

          it 'finds helper only once' do
            FileUtils.mkpath('spec/helpers')
            FileUtils.touch('spec/helpers/foo_helper.rb')
            FileUtils.touch('spec/foo_spec.rb')
            config.spec_files.should == [ep('spec.rb'), ep('spec/helpers/foo_helper.rb'), ep('spec/foo_spec.rb')]
          end

        end

      end

    end
  end
end
