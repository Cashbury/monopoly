class ApiError < Exception
  attr_reader :status_code
  def initialize(message, status_code = 422)
    super(message)
    @status_code = status_code
  end

  def to_xml(*args)
    {
      :errors => [message]
    }.to_xml
  end
end
