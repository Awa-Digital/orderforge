class ApiError < StandardError
  class RequestFailed < ApiError
  end

  class BaseUrlMissing < ApiError
  end

  class ClientError < ApiError
  end

  class ProviderError < ApiError
  end

  class UnexpectedResponse < ApiError
  end
end
