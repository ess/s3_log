require 'spec_helper'
require 's3_log'

describe S3Log do
  let(:access_key_id) {'ACCESS_KEY_ID'}
  let(:secret_access_key) {'SECRET_ACCESS_KEY'}
  let(:bucket) {'bucket'}
  let(:path) {'path/to/a/file'}
  let(:content) {'line 1'}

  before(:each) do
    Fog::Mock.reset
    Fog.mock!
  end

  describe '.configure' do
    let(:good_options) {{
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      bucket: bucket
    }}
    
    it 'requires an aws access key id' do
      expect{described_class.configure(good_options)}.
        not_to raise_error

      good_options.delete(:access_key_id)

      expect{described_class.configure(good_options)}.
        to raise_error(S3Log::InvalidConfigError)
    end

    it 'requires an aws secret access key' do
      expect{described_class.configure(good_options)}.
        not_to raise_error

      good_options.delete(:secret_access_key)

      expect{described_class.configure(good_options)}.
        to raise_error(S3Log::InvalidConfigError)

    end

    it 'requires a bucket name' do
      expect{described_class.configure(good_options)}.
        not_to raise_error

      good_options.delete(:bucket)

      expect{described_class.configure(good_options)}.
        to raise_error(S3Log::InvalidConfigError)
    end
  end

  describe '.read' do
    before(:each) do
      described_class.configure(
        access_key_id: 'ACCESS_KEY_ID',
        secret_access_key: 'SECRET_ACCESS_KEY',
        bucket: 'bucket'
      )
    end

    it 'requires that the module be configured' do
      described_class.clear_configuration
      expect {described_class.read(path)}.
        to raise_error(described_class::Unconfigured)
    end

    it 'is a string' do
      expect(described_class.read(path)).to be_a(String)
    end

    context 'for a non-existent path' do
      it 'is an empty string' do
        expect(described_class.read(path)).to eql('')
      end
    end

    context 'for an existing path' do
      it 'is the content of the file' do
        described_class.write(path, content)
        expect(described_class.read(path)).to eql(content)
      end
    end
  end

  describe '.write' do
    before(:each) do
      described_class.configure(
        access_key_id: 'ACCESS_KEY_ID',
        secret_access_key: 'SECRET_ACCESS_KEY',
        bucket: 'bucket'
      )
    end

    it 'requires that the module be configured' do
      described_class.clear_configuration
      expect {described_class.write(path, content)}.
        to raise_error(described_class::Unconfigured)
    end

    it 'reads the file' do
      expect(described_class).
        to receive(:read).with(path).and_call_original

      described_class.write(path, content)
    end

    it 'creates the file on s3' do
      expect(described_class.read(path)).to eql('')

      described_class.write(path, content)

      expect(described_class.read(path)).to eql(content)
    end

    it 'appends to an exsiting s3 file' do
      more_content = 'more content'
      described_class.write(path, content)
      expect(described_class.read(path)).to eql(content)

      described_class.write(path, "more content")
      expect(described_class.read(path)).to eql("#{content}\n#{more_content}")
    end

    it 'returns the logger itself' do
      expect(described_class.write(path, content)).to eql(described_class)
    end
  end
end
