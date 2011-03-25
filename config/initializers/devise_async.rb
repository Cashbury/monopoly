module Devise
  module Models
    module Confirmable
      alias_method :send_confirmation_instructions_without_delay, :send_confirmation_instructions
      handle_asynchronously :send_confirmation_instructions
    end

    module Recoverable
      alias_method :send_reset_password_instructions_without_delay, :send_reset_password_instructions
      handle_asynchronously :send_reset_password_instructions
    end

    module Lockable
      alias_method :send_unlock_instructions_without_delay, :send_unlock_instructions
      handle_asynchronously :send_unlock_instructions
    end
  end
end