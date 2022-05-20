# reMarkableTools
Utilities I put together for my reMarkable 2

# upload_templates.sh

A bash script for compressing a directory of png template files, pushing them to your tablet, and unpacking them in the proper location.
The script also generates the necessary JSON to make updating templates.json easier.

  #### Requirements
  This script should work on any platform, however it does make use of the `tar` command. This means that Windows versions
  prior to 10 will need to have tar installed manually.
    
  You will also need to know how to SSH into your reMarkable tablet, and I recommend configuring key-based authentication
  to eliminate the need to enter a password every time. Without key-based auth, you will be prompted to enter the SSH password
  at least twice during normal execution of this script. [The reMarkable wiki](https://remarkablewiki.com/tech/ssh "SSH Access") has a good
  guide for finding your tablet's SSH password and enabling key-based auth.
  
  I also recommend adding some SSH configuration settings for your tablet to make things a little easier, especially for this script:
  ```
  host remarkable
      HostName <your tablet's IP or hostname>
      User root
      IdentityFile ~/.ssh/id_rsa
  ```
  If you use a different string for the host value, update the `ssh_target` value in the script to match.
  
  The script uses a pretty generic icon code for everything it uploads, but you can change the value for any given template.
  [The reMarkable wiki](https://remarkablewiki.com/tips/templates "Templates") has instructions for changing that value,
  as well as a list of valid icon codes for the current reMarkable version.
