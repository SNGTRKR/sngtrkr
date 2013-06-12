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

## Configuring The Dev Environment
[Vagrant](http://www.vagrantup.com/) is used to virtualise the entire development environment to ensure consistent environments for all developers, and make moving the dev environment to production that much easier. You will need both Vagrant and [VirtualBox](https://www.virtualbox.org/) installed before continuing.

Next you need to create `data_bags/secrets.json` which will store API keys and other such sensitive data not held in the repo. Duplicate the example file and make the necessary adjustments.

After that's done the process is simply to `cd` into the project, then run `vagrant up`! If the configuration process has any problems, run `vagrant reload` to restart the PC and continue. This should not be a problem, if it is, contact Matt. When the configuration process is complete, you can access the machine with `vagrant ssh`. Check out `Vagrantfile` to get an idea of what servers are installed for you and are automatically running.

For further boots, the server can be suspended with `vagrant suspend` and resumed again with `vagrant up`. 

## Hosts Configuration
To enable facebook login during development, you need to change your `/etc/hosts` file
to point `dev.sngtrkr.com` at `127.0.0.1`. Now to develop go to `http://dev.sngtrkr.com:3000`.

