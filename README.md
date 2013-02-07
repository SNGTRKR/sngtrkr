# SNGTRKR

## SSH Configuration
Add this to your `~/.ssh/config` file (change `IdentityFile` as needed)

		Host *.sngtrkr.com
		  IdentityFile "~/Google Drive/SNGTRKR/linode_public_key.pub"
		  User deploy
		  ForwardAgent yes

## Git Configuration
The repo is set to use GitHub's HTTPS method, so no SSH keys are involved here. As long as 
your client is [configured to use](https://help.github.com/articles/set-up-git) the credential
helper, you won't have to remember any passwords or SSH key locations this way!

On deployment, the server is set to cache login details to GitHub for months. In the unlikely
event it doesn't remember the login details, you will need to SSH into it and run a command that
prompts for credentials. This will do:

	git ls-remote https://github.com/MattBessey/sngtrkr.git