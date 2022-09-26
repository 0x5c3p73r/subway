class ApplicationController < ActionController::Base
  rescue_from Encryptor::NotMatchedError, with: :unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::Encryption::Errors::Decryption, with: :internal_server_error
  rescue_from URI::InvalidURIError, ActiveRecord::NotNullViolation, with: :not_accepted

  protected

  def verify_ticket
    @ticket = params[:ticket] || cookies[@coach.ticket_key]
    if @ticket.present? && @coach.encrypt_matches?(@ticket)
      return cookies[@coach.ticket_key] ||= @ticket
    end

    raise Encryptor::NotMatchedError, "Invalid ticket"
  end

  def not_found(exception)
    error_handler(404, exception.message)
  end

  def unauthorized(exception)
    error_handler(401, exception.message)
  end

  def internal_server_error(exception)
    error_handler(500, exception.message)
  end

  def not_accepted(exception)
    error_handler(406, exception.message)
  end

  def error_handler(code, message = nil)
    message ||= Rack::Utils::HTTP_STATUS_CODES[code]

    respond_to do |format|
      format.any  { render plain: message, status: code, formats: [:html] }
      format.json { render json: { error: message }, status: code }
    end
  end
end
