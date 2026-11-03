**Puppet + Docker Practical: Server and One Agent**  
**Step 1 — Check Docker**  
**WINDOWS CMD:**  
docker --version  
 docker info  
   
If Docker is working, continue.  
**Step 2 — Download Puppet Server image**  
**WINDOWS CMD:**  
docker pull puppet/puppetserver  
   
Check:  
docker images  
   
You should see:  
puppet/puppetserver  
   
**Step 3 — Download Puppet Agent image**  
**WINDOWS CMD:**  
docker pull puppet/puppet-agent  
   
Check:  
docker images  
   
**Step 4 — Create Puppet Server container**  
**WINDOWS CMD:**  
docker run -d --name puppet-server --hostname puppet-server -p 8140:8140 puppet/puppetserver  
   
**Meaning:**  
| | |  
|-|-|  
| **Flag** | **Description** |   
| -d | Run in background |   
| --name puppet-server | Container name |   
| --hostname puppet-server | Hostname |   
| -p 8140:8140 | Port mapping |   
| puppet/puppetserver | Image |   
   
**Step 5 — Check Puppet Server**  
**WINDOWS CMD:**  
docker ps  
   
You should see:  
puppet-server  
   
For more information:  
docker ps -a  
   
**Step 6 — Check Puppet Server logs**  
**WINDOWS CMD:**  
docker logs puppet-server  
   
If you want to continuously watch the logs:  
docker logs -f puppet-server  
   
Press:  
Ctrl + C  
   
to stop watching.  
**Step 7 — Download/create Puppet Agent container**  
**WINDOWS CMD:**  
docker run -dit --name puppet-agent --hostname puppet-agent puppet/puppet-agent agent --verbose --no-daemonize --server puppetserver  
   
Check:  
docker ps  
   
You should now have:  
puppet-server  
 puppet-agent  
   
**Step 8 — Find Puppet Server IP**  
Since we are not creating a custom Docker network, we will find the server's Docker IP.  
**WINDOWS CMD:**  
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" puppet-server  
   
For example:  
172.17.0.2  
   
Your IP may be different.  
Let's assume:  
SERVER_IP = 172.17.0.2  
   
From this point, replace 172.17.0.2 with your actual IP.  
**Step 9 — Check Agent IP**  
**WINDOWS CMD:**  
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" puppet-agent  
   
For example:  
172.17.0.3  
   
So you might have:  
Puppet Server = 172.17.0.2  
 Puppet Agent  = 172.17.0.3  
   
**Step 10 — Enter Puppet Agent**  
**WINDOWS CMD:**  
docker exec -it puppet-agent bash  
   
Now you are inside the agent container.  
You should see something similar to:  
root@puppet-agent:/#  
   
**Step 11 — Check hostname**  
**AGENT CONTAINER:**  
hostname  
   
Expected:  
puppet-agent  
   
**Step 12 — Check Puppet version**  
**AGENT CONTAINER:**  
puppet --version  
   
**Step 13 — Check Agent configuration**  
**AGENT CONTAINER:**  
puppet config print server  
   
It may show the default Puppet server configuration.  
We want it to use:  
172.17.0.2  
   
**Step 14 — Set Puppet Server address**  
Inside the agent:  
puppet config set server 172.17.0.2 --section main  
   
Replace 172.17.0.2 with your actual server IP.  
Check:  
puppet config print server  
   
Expected:  
172.17.0.2  
   
**Step 15 — Check Agent certificate name**  
**AGENT CONTAINER:**  
puppet config print certname  
   
It should normally be:  
puppet-agent  
   
To explicitly set it:  
puppet config set certname puppet-agent --section main  
   
Check again:  
puppet config print certname  
   
Expected:  
puppet-agent  
   
**Step 16 — Test Puppet Agent**  
**AGENT CONTAINER:**  
puppet agent --test  
   
The first time, you should get a certificate request.  
You may see something similar to:  
Info: Creating a new SSL key for puppet-agent  
 Info: Creating a new SSL certificate request for puppet-agent  
 Info: Certificate Request fingerprint ...  
   
Keep this terminal open.  
**Step 17 — Open a second CMD window**  
Do not close the agent terminal.  
Open another Windows CMD.  
Now check certificate requests.  
**WINDOWS CMD:**  
docker exec -it puppet-server puppetserver ca list  
   
You should see:  
puppet-agent  
   
**Step 18 — Sign the Agent Certificate**  
**WINDOWS CMD:**  
docker exec -it puppet-server puppetserver ca sign --certname puppet-agent  
   
Expected:  
Successfully signed certificate request for puppet-agent  
   
**Step 19 — Check certificate**  
**WINDOWS CMD:**  
docker exec -it puppet-server puppetserver ca list --all  
   
You should see the certificate for:  
puppet-agent  
   
**Step 20 — Run Puppet Agent again**  
Go back to the Agent container terminal.  
Run:  
puppet agent --test  
   
Now the agent should successfully communicate with the server.  
You may see:  
Info: Using configured environment 'production'  
 Info: Retrieving pluginfacts  
 Info: Retrieving plugin  
 Info: Loading facts  
 Info: Applying configuration version ...  
 Notice: Finished catalog run  
   
At this point:  
Puppet Server  
       ↓  
 Configuration  
       ↓  
 Puppet Agent  
       ↓  
 Apply configuration  
   
**Step 21 — Create Puppet manifest directory**  
Now we need to create a Puppet manifest on the server.  
Open another CMD if necessary.  
Enter the server:  
**WINDOWS CMD:**  
docker exec -it puppet-server bash  
   
Now you are inside:  
root@puppet-server:/#  
   
**Step 22 — Create manifests directory**  
**SERVER CONTAINER:**  
mkdir -p /etc/puppetlabs/code/environments/production/manifests  
   
Check:  
ls /etc/puppetlabs/code/environments/production  
   
You should see:  
manifests  
   
**Step 23 — Create site.pp**  
**SERVER CONTAINER:**  
touch /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
Check:  
ls -l /etc/puppetlabs/code/environments/production/manifests  
   
You should see:  
site.pp  
   
**Step 24 — Put Puppet code into site.pp**  
You can use vi:  
vi /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
Press:  
i  
   
Then enter:  
file { '/tmp/hello.txt':  
   ensure  => file,  
   content => "Hello from Puppet!\n",  
   mode    => '0644',  
 }  
   
Save:  
Esc  
 :wq  
 Enter  
   
**Step 25 — Check manifest**  
**SERVER CONTAINER:**  
cat /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
You should see:  
file { '/tmp/hello.txt':  
   ensure  => file,  
   content => "Hello from Puppet!\n",  
   mode    => '0644',  
 }  
   
**Step 26 — Validate Puppet manifest**  
**SERVER CONTAINER:**  
puppet parser validate /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
If there is no output, the syntax is valid.  
**Step 27 — Exit Puppet Server**  
exit  
   
You are now back in Windows CMD.  
**Step 28 — Run Puppet Agent**  
Now run:  
**WINDOWS CMD:**  
docker exec -it puppet-agent puppet agent --test  
   
Puppet should retrieve the manifest from the server.  
You should see something similar to:  
Notice: /Stage[main]/Main/File[/tmp/hello.txt]/ensure: created  
 Notice: Finished catalog run  
   
**Step 29 — Check the created file**  
**WINDOWS CMD:**  
docker exec -it puppet-agent cat /tmp/hello.txt  
   
Expected:  
Hello from Puppet!  
   
🎉 You have successfully created a file on the Puppet Agent using Puppet Server.  
**Step 30 — Demonstrate Configuration Drift**  
Now manually change the file.  
**WINDOWS CMD:**  
docker exec -it puppet-agent sh -c "echo 'Manual change' > /tmp/hello.txt"  
   
Check:  
docker exec -it puppet-agent cat /tmp/hello.txt  
   
Output:  
Manual change  
   
**Step 31 — Run Puppet again**  
docker exec -it puppet-agent puppet agent --test  
   
Puppet detects the difference and changes the file back.  
Check:  
docker exec -it puppet-agent cat /tmp/hello.txt  
   
Expected:  
Hello from Puppet!  
   
This demonstrates configuration drift correction.  
**Step 32 — Add Package Management**  
Let's now make Puppet install a package.  
Enter server:  
docker exec -it puppet-server bash  
   
Edit:  
vi /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
Change the manifest to:  
file { '/tmp/hello.txt':  
   ensure  => file,  
   content => "Hello from Puppet!\n",  
   mode    => '0644',  
 }  
   
 package { 'curl':  
   ensure => installed,  
 }  
   
Save:  
Esc  
 :wq  
 Enter  
   
**Step 33 — Validate manifest again**  
**SERVER CONTAINER:**  
puppet parser validate /etc/puppetlabs/code/environments/production/manifests/site.pp  
   
**Step 34 — Exit server**  
exit  
   
**Step 35 — Apply package configuration**  
**WINDOWS CMD:**  
docker exec -it puppet-agent puppet agent --test  
   
**Step 36 — Check curl**  
docker exec -it puppet-agent curl --version  
   
If installed successfully, the curl version will be displayed.  
**Step 37 — Check Puppet Agent status**  
docker exec -it puppet-agent puppet agent --test  
   
Run it again.  
This time, you should see that there are no changes if everything is already in the desired state.  
**Step 38 — Stop containers**  
When your practical is finished:  
docker stop puppet-agent  
 docker stop puppet-server  
   
Check:  
docker ps  
   
**Step 39 — Start them again**  
Next time you want to continue:  
docker start puppet-server  
 docker start puppet-agent  
   
Check:  
docker ps  
   
