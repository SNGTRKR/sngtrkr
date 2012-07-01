class UsersController::ConfirmableController < Devise::ConfirmableController
  before_create :flash
  def flash
        flash[:notice] = 'You still need to confirm your email change. A confirmation email was sent to <strong>tom.alan.dallimore@googlemail.com</strong>. Your email will not be changed until you complete 	this step!
    		<div id="confirm-buttons">
      		<div class="o-button font-13 signika-font norm-o-pad left">Resend confirmation</div>
      	
      		<div class="clear"></div>
    		</div>'
  end
end