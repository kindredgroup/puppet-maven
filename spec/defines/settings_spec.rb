require 'spec_helper'

describe 'maven::settings' do

  let(:facts) do {
    :concat_basedir => '/tmp/foo'
  } end

  describe 'with default settings' do
    let(:title) { 'user' }
    let(:params) do {
      :path => '/home'
    } end

    it {
      should contain_file('/home/user/.m2').with(:ensure => 'directory')
      should contain_file('/home/user/.m2/settings.xml')
    }
  end

  describe 'with source' do
    let(:title) { 'user' }
    let(:params) do {
      :path   => '/home',
      :source => 'puppet:///modules/module/settings.xml'
    } end

    it {
      should contain_file('/home/user/.m2/settings.xml').with(:source => 'puppet:///modules/module/settings.xml')
    }
  end

  describe 'with ensure => absent' do
    let(:title) { 'user' }
    let(:params) do {
      :ensure => 'absent',
      :path   => '/home'
    } end

    it {
      should contain_file('/home/user/.m2').with(:ensure => 'absent')
      should contain_file('/home/user/.m2/settings.xml').with(:ensure => 'absent')
    }
  end

end
