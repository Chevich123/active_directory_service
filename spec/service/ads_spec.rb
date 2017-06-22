require 'spec_helper'

RSpec.describe ActiveDirectoryService do
  subject { ActiveDirectoryService::Service.new('username', 'password', false) }

  it 'should exists' do
    expect(subject).to_not be_nil
  end

  describe 'should authorize user with ActiveDirectory' do
    it 'should have ldap_config params loaded from yaml file' do
      expect(subject.ldap_config['host']).to eq('127.0.0.1')
      expect(subject.ldap_config['basic_port']).to eq(401)
      expect(subject.ldap_config['ssl_port']).to eq(404)
      expect(subject.ldap_config['attribute']).to eq('cnt')
      expect(subject.ldap_config['ca_file_path']).to eq('/corpRootCa.cer')
      expect(subject.ldap_config['verify_certificate']).to eq(false)
      expect(subject.ldap_config['ssl_version']).to eq('TLSv1_2')
      expect(subject.ldap_config['base']).to eq('ou=people,dc=test,dc=com')
      expect(subject.ldap_config['ssl']).to eq(true)
    end

    it 'should build correct DN' do
      dn = subject.send(:dn)
      expect(dn).to eq('cnt=username,ou=people,dc=test,dc=com')
    end

    it 'should build correct LDAP' do
      expect(subject.ssl).to be_falsey
      ldap = subject.send(:ldap)
      expect(ldap.host).to eq(subject.ldap_config['host'])
      expect(ldap.port).to eq(subject.ldap_config['basic_port'])

      subject = ActiveDirectoryService::Service.new('username', 'password', true)
      expect(subject.ssl).to be_truthy
      ldap = subject.send(:ldap)
      expect(ldap.host).to eq(subject.ldap_config['host'])
      expect(ldap.port).to eq(subject.ldap_config['ssl_port'])
    end

    it 'should bind LDAP connect' do
      expect_any_instance_of(Net::LDAP).to receive(:bind).and_return(true)
      expect(subject.valid_ldap_authentication?).to be_truthy
    end

    it 'should return error_message' do
      expect_any_instance_of(Net::LDAP).to receive(:get_operation_result)
      expect(subject.error_message).to be_nil
    end

    it 'should build encode password in microsoft way' do
      dn = subject.send(:microsoft_encode_password, 'AAA')
      expect(dn).to eq("\"\u0000A\u0000A\u0000A\u0000\"\u0000")

      dn = subject.send(:microsoft_encode_password, 'BBB')
      expect(dn).to eq("\"\u0000B\u0000B\u0000B\u0000\"\u0000")

      dn = subject.send(:microsoft_encode_password, 'ЮЮЮ')
      expect(dn).to eq("\"\u0000Ю\u0000Ю\u0000Ю\u0000\"\u0000")
    end
  end
end
