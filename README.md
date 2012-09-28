SSH Proxy Connect
===================

# Configuration

This ssh proxy connect utilty documentation explains how to connect with your ssh client to a ssh server, located on the internet from a local network protected by a firewall or NAT through a proxy(HTTPS for example). Then show you how to configure your ssh client to use the proxy when ssh client tries to connect to your ssh server.

Requirement are :

* Your firewall has to allow HTTPS connections through a proxy
* You need to have root access to the server where ssh is listening

1. Install the connect software :

* Get source and compiling:

  $ cd /tmp/

  $ git clone https://github.com/ShuminHuang/ssh-proxy.git

  $ make

  $ sudo cp connect /usr/local/bin/ ; chmod +x /usr/local/bin/connect

2. Configure your ssh client.

* Open or create your ~/.ssh/config file and add these lines :

  #### Outside of the firewall, with HTTPS proxy
  Host my-ssh-server-host.net
      ProxyCommand connect -H proxy.free.fr:3128 %h 443

  #### Inside the firewall (do not use proxy)
  Host *
      ProxyCommand connect %h %p

3. Configure the ssh server.

* Edit this file (on debian system) /etc/ssh/sshd\_config and add this line : 

  Port 443

  Then restart the daemon :

  sudo /etc/init.d/ssh restart

## Then pray and test the connection :

   $ ssh my-ssh-server-host.net

## SSH to another server through the tunnel

For example to connect to in ssh github.com :

Host github.com
    ProxyCommand=ssh my-ssh-server-host.net "/bin/nc -w1 %h %p"

# Reference
[zeitoun.net] http://www.zeitoun.net/articles/ssh-through-http-proxy/start "SSH through HTTP proxy"
[SaulChristie] http://www.saulchristie.com/how-to/bypass-firewalls "Bypass Any Firewall"
[proxytunnel] http://proxytunnel.sourceforge.net "ProxyTunnel: punching holes in HTTP(S) proxy"
[gotoh] https://bitbucket.org/gotoh/connect "OpenSSH proxy command for socket connection using SOCKS4/5 or HTTP tunnel."
