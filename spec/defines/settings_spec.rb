require 'spec_helper'

describe 'maven::settings' do

  let(:facts) do {
    :concat_basedir => '/tmp/foo'
  } end

  describe 'with default settings' do
    let(:title) { 'user_settings' }
    let(:params) do {
      :user => 'user',
      :path => '/home/user/.m2/settings.xml'
    } end

    it {
      should contain_file('/home/user/.m2').with(:ensure => 'directory')
      should contain_concat('/home/user/.m2/settings.xml')
      should have_concat__fragment_resource_count(8)
    }
  end

  describe 'with source' do
    let(:title) { 'user_settings' }
    let(:params) do {
      :user   => 'user',
      :path   => '/home/user/.m2/settings.xml',
      :source => 'puppet:///modules/module/settings.xml'
    } end

    it {
      should have_concat_resource_count(0) 
      should have_concat__fragment_resource_count(0)
      should contain_file('/home/user/.m2/settings.xml').with(:source => 'puppet:///modules/module/settings.xml')
    }
  end

  describe 'with ensure => absent' do
    let(:title) { 'user_settings' }
    let(:params) do {
      :ensure => 'absent',
      :user   => 'user',
      :path   => '/home/user/.m2/settings.xml'
    } end

    it {
      should contain_file('/home/user/.m2').with(:ensure => 'absent')
      should contain_concat('/home/user/.m2/settings.xml').with(:ensure => 'absent')
      should have_concat__fragment_resource_count(0)
    }
  end

end
