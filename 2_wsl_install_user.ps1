#Run this WSL script as your user!
$username = Read-Host -Prompt 'Input your username (no periods!)'
$securedPassword = Read-Host -AsSecureString -Prompt 'Input your password'
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedPassword)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
wsl --update
wsl --set-default-version 2
$null = New-Item -ItemType Directory -Force -Path C:\temp
Write-Host Downloading Ubuntu... Please Wait! `(Progress bar disabled for speed`)
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://cloud-images.ubuntu.com/wsl/jammy/current/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz -OutFile C:\temp\ubuntu.tar.gz -UseBasicParsing
$null = New-Item -ItemType Directory -Force -Path $home\wsl\Ubuntu
wsl --import Ubuntu $home\wsl\Ubuntu C:\temp\ubuntu.tar.gz
Remove-Item C:\temp\ubuntu.tar.gz
wsl --setdefault Ubuntu
wsl -u root apt update
wsl -u root apt -y upgrade
wsl -u root apt install -y dos2unix
wsl useradd -s /bin/bash -d /home/${username} -m -G sudo ${username}
#A bit ugly could probably make this better, but it works, and /tmp is wiped after the wsl restart.
wsl -u root /bin/bash -c "echo ${username}:${password} > /tmp/temppass" | wsl -u root dos2unix /tmp/temppass | wsl -u root cat /tmp/temppass | wsl -u root /bin/bash -c 'cat /tmp/temppass | chpasswd'
wsl -u root /bin/bash -c "echo $username > /tmp/username" | wsl -u root /bin/bash -c  'cat /tmp/username' | wsl -u root /bin/bash -c 'cat << EOF > /etc/wsl.conf
[boot]
systemd=true
[user]
default=`cat /tmp/username`
EOF'
wsl -u root mv /etc/wsl* /etc/wsl.conf | wsl -u root dos2unix /etc/wsl.conf
Start-Process -Wait wsl --shutdown
wsl -u root apt -y install apt-transport-https ca-certificates curl software-properties-common
wsl -u root /bin/bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/trusted.gpg.d/docker.asc'
wsl -u root /bin/bash -c "add-apt-repository -y 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'"
wsl -u root apt install -y docker-ce docker-ce-cli  docker-compose-plugin
wsl -u root /bin/bash -c "systemctl enable docker; systemctl start docker"
wsl -u root usermod -a -G docker ${username}
