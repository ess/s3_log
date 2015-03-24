require 'fog/aws/storage'
require 's3_log/exceptions'

# This module is a singleton that implements an append-style S3 file writer.

module S3Log
  RequiredOptions = [:access_key_id, :secret_access_key, :bucket]

  # Return the singleton's S3 Storage object
  #
  # @return [Fog::Storage::AWS] if the logger is configured
  #
  # @return [BilClass] if the logger is not configured

  def self.storage
    @storage
  end

  # Return the singleton's S3 bucket
  #
  # @return [Fog::Storage::AWS::Directory] if the logger is configured
  #
  # @return [NilClass] if the logger is not configured

  def self.bucket
    @bucket
  end

  # Is the logger configured?
  #
  # @return [Boolean] true if the logger is configured, false otherwise

  def self.configured?
    storage && bucket
  end

  # Configure the logger so it can be used to write logs
  #
  # @param options [Hash] The :access_key_id, :secret_access_key, and :bucket
  #   keys are required
  #
  # @return [S3Log] the singleton logger
  #
  # @raise [S3Log::InvalidConfigError] if not provided all required
  #   configuration options

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

  # Append the given content to the given S3 path
  #
  # @return [S3Log] the singleton logger
  #
  # @raise [S3Log::Unconfigured] if the logger has not been configured

  def self.write(path, content)
    unless configured?
      raise Unconfigured
    end

    bucket.files.create(
      key: path,
      body: read(path).split("\n").push(content).join("\n"),
      public: false
    )

    self
  end

  # Read the given path
  #
  # @return [String] the content of the requested S3 file if present
  #
  # @return [String] the empty string if the requested S3 file is not present
  #
  # @raise [S3Log::Unconfigured] if the logger has not been configured

  def self.read(path)
    unless configured?
      raise Unconfigured
    end

    file = bucket.files.get(path)
    file.nil? ? '' : file.body.to_s
  end

  # Clear the singleton logger's configuration
  #
  # @return [NilClass]

  def self.clear_configuration
    @bucket = @storage = nil
  end
end
