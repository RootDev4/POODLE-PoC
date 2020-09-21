# Another POODLE attack PoC
See forked [Poodle PoC repository of mpgn](https://github.com/mpgn/poodle-PoC) to learn more about  the POODLE attack.

## :zap: General setup
I recommend VirtualBox with NAT network. In this example, the assigned IP subnet is 10.0.2.0/24. You can find my video of this PoC and the full attack on [YouTube](https://www.youtube.com/watch?v=9w1x6_UI64c).

## :computer: Vulnerable server
Download Ubuntu 12.04 (server install CD) from [here](http://releases.ubuntu.com/12.04/) and get a running server in VirtualBox. After installation, log in and become root. DO NOT RUN ANY SYSTEM UPDATES! Then type
```console
wget https://raw.githubusercontent.com/RootDev4/poodle-PoC/master/install-nginx-server.sh && chmod +x install-nginx-server.sh && ./install-nginx-server.sh
```
to install and configure a vulnerable nginx web server.  
Get assigned IP address of server with ```ip a``` (in this example, it's 10.0.2.14).

## :computer: Victim's machine
Download any OS of your choice (I used [Ubuntu Desktop 20.04](https://ubuntu.com/download)) and install it in VirtualBox. After installation, log in and download a [legacy version of Firefox browser](https://ftp.mozilla.org/pub/firefox/releases/) (successfully tested with [Firefox v33.0](https://ftp.mozilla.org/pub/firefox/releases/33.0/)).

## :computer: Attacker's machine
Download latest [Kali Linux](https://www.kali.org/downloads/) (or any other Linux distribution of your choice) and install it in VirtualBox. After installation, log in and become root. Clone this repository to your computer by running
```console
git clone https://github.com/RootDev4/poodle-PoC.git
```
and type
```console
chmod +x recompile-openssl.sh && ./recompile-openssl.sh
```
to recompile the installed OpenSSL software with SSLv3.0 support since these protocol is disabled by default.  
Get assigned IP address of attacker's machine with ```ip a``` (in this example, it's 10.0.2.17).
## :bomb: Attack!
On the attacker's machine, run the following in separate terminal tabs/windows.

### Terminal tab/window 1
```console
python3 httpserver.py https://10.0.2.14/
```
where https://10.0.2.14/ is the URL to the nginx server website.

### Terminal tab/window 2
```console
./start-mitm-attack.sh
```
and follow instructions shown in the terminal's window.

### Terminal tab/window 3
```console
python3 ./poodle-exploit.py 10.0.2.17 4443 10.0.2.14 443 --start-block 49 --stop-block 52
```
where 10.0.2.17 is the attacker's IP address and 10.0.2.14 is the nginx server's IP address. Adjust the cookie's block position of HTTP header in --start-block and --stop-block.

Keep terminal tab/window 1 and 2 open in the background and only focus on tab/window 3.

Open https://10.0.2.14/ (nginx server's IP address) on the victim's machine and sign in with John:mypasswd to create an user session/cookie. Open http://10.0.2.17/ (attacker's IP address) in another browser tab and click the button "Ping HTTPS Server" to check, if the MitM attack is working. Back on the attacker's machine, the script should now output the received package length.
 
If SSL protocol is not SSLv3.0, type ```downgrade``` to start a TLS downgrade attack. This might not work, so as a workaround, you have to manually downgrade the browser's TLS protocol support on the attacker's machine. Open _about:config_ in a new tab of the browser and set _security.tls.version.max_ to 0. Read more about that issue [here](https://github.com/mpgn/poodle-PoC/issues/4).

Then type ```search``` and hit the button "Find CBC block length" on the victim's machine to find the right block length. After the script have found the block length, type ```active``` and hit the button "Run decryption" on the victim's machine. This will start the decryption attack.
