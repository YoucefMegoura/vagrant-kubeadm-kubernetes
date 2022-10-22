NUM_WORKER_NODES=2
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
  #config.ssh.forward_agent = true
  #config.ssh.insert_key = false
  config.ssh.password = "vagrant"
  #config.ssh.private_key_path = "/home/youcefmegoura/.ssh/id_rsa"
  config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
      apt-get update -y
      echo "$IP_NW$((IP_START)) nfs-node" >> /etc/hosts
      echo "$IP_NW$((IP_START+1)) master-node" >> /etc/hosts
      echo "$IP_NW$((IP_START+2)) worker-node01" >> /etc/hosts
      echo "$IP_NW$((IP_START+3)) worker-node02" >> /etc/hosts
  SHELL
  
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.box_check_update = true

  config.vm.define "nfs" do |nfs|
    # nfs.vm.box = "bento/ubuntu-18.04"
    nfs.vm.hostname = "nfs-node"
    nfs.vm.network "private_network", ip: IP_NW + "#{IP_START}"
    nfs.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
    end
    nfs.vm.provision "shell", path: "scripts/nfs.sh"
  end

  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: IP_NW + "#{IP_START + 1}"
    master.vm.provider "virtualbox" do |vb|
        vb.memory = 4048
        vb.cpus = 2
    end
    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh"
  end

  (1..NUM_WORKER_NODES).each do |i|

  config.vm.define "node0#{i}" do |node|
    node.vm.hostname = "worker-node0#{i}"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + 1 + i}"
    node.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 1
    end
    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end

  end
end 
