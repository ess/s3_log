module S3Logger
  class Error < StandardError ; end

  class InvalidConfigError < Error
    def initialize(missing)
      super("Missing configuration keys (#{missing.join(', ')})")
    end
  end

  class Unconfigured < Error
    def initialize(garbage = nil)
      super("You must first run S3Logger.configure")
    end
  end
end
