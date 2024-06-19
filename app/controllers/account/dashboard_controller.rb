class Account::DashboardController < AccountController
  before_action :set_current_accommondations, only: [:home]
  
  def home
    @title = "Account Dashboard"
    @accommondations = current_account.accommondations
  end

  def revert_masquerade
    # Ensure the current user is an admin and is masquerading as another user
    if current_account && user_masquerade?
      # Clear the masquerade_user_id from the session
      session.delete(:masquerade_user_id)
      # session.delete(:account_id)
      sign_out(current_account)

      redirect_to admin_dashboard_path, notice: "You have reverted back to your admin account."
    else
      # Handle unauthorized access or non-masquerade mode
      redirect_to admin_dashboard_path, alert: "You are not currently masquerading as another user."
    end
  end

  private

  def set_current_accommondations
    @has_active_accommondation = current_account.accommondations.exists?(active: true)
  end

end
