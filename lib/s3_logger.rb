require 'fog/aws/storage'
require 's3_logger/exceptions'

module S3Logger
  RequiredOptions = [:access_key_id, :secret_access_key, :bucket]

  def self.storage
    @storage
  end

  def self.bucket
    @bucket
  end

  def self.configured?
    storage && bucket
  end

  def self.configure(options = {})
    missing = RequiredOptions - options.keys
    raise InvalidConfigError.new(missing) unless missing.empty?

    clear_configuration

    @storage = Fog::Storage::AWS.new(
      aws_access_key_id: options[:access_key_id],
      aws_secret_access_key: options[:secret_access_key]
    )

    @bucket = @storage.directories.create(
      key: options[:bucket],
      public: false
    )
    self
  end

  def self.write(path, content)
    unless storage && bucket
      raise Unconfigured
    end

    bucket.files.create(
      key: path,
      body: read(path).split("\n").push(content).join("\n"),
      public: false
    )

    self
  end

  def self.read(path)
    unless storage && bucket
      raise Unconfigured
    end

    file = bucket.files.get(path)
    file.nil? ? '' : file.body.to_s
  end

  def self.clear_configuration
    @bucket = @storage = nil
  end
end
