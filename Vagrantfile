require 'getoptlong'

# Parse CLI arguments.
opts = GetoptLong.new(
  [ '--provider',     GetoptLong::OPTIONAL_ARGUMENT ],
)

provider='virtualbox'
begin
  opts.each do |opt, arg|
    case opt
      when '--provider'
        provider=arg
    end # case
  end # each
  rescue
end

class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end

vms = {
  'kubemaster01' => {'memory' => '4096', 'cpus' => 3, 'ip' => '20'},
  'node01'       => {'memory' => '4096', 'cpus' => 1, 'ip' => '30'},
  'node02'       => {'memory' => '4096', 'cpus' => 1, 'ip' => '40'}
}

Vagrant.configure("2") do |config|
  vms.each do |name, conf|
    config.vm.define "#{name}" do |virtual|
      config.vm.box = "ubuntu/focal64"
      config.vm.box_version = "20210330.0.0"
      (0..2).each do |i|
        virtual.vm.disk :disk, size: "20GB", name: "disk-#{i}"
      end
      virtual.vm.hostname = "#{name}"
      virtual.vm.network "private_network", ip: "172.25.10.#{conf['ip']}"
      virtual.vm.provision "file", source: "files/motd", destination: ".motd"
      virtual.vm.provision "file", source: "files", destination: "/home/vagrant/"
      virtual.vm.provision "shell", inline: "sudo cp ~vagrant/.motd /etc/motd"
      virtual.vm.provider "virtualbox" do |vb, override|
        vb.name = "#{name}"
        vb.memory = "#{conf['memory']}"
        vb.cpus = "#{conf['cpus']}"
      end
      virtual.vm.provider "hyperv" do |hv, override|
        hv.vmname = "#{name}"
        hv.memory = "#{conf['memory']}"
        hv.cpus = "#{conf['cpus']}"
      end
      virtual.vm.provision "shell", path: 'provision/ssh-keys.sh'
    end
  end
  config.vm.define "controller", primary: true do |controller|
    config.vm.box = "ubuntu/focal64"
    controller.vm.box_version = "20210330.0.0"
    controller.vm.hostname = "controller"
    controller.vm.network "private_network", ip: "172.25.10.10"
    controller.vm.provision "file", source: "files/motd", destination: ".motd"
    controller.vm.provision "file", source: "files", destination: "/home/vagrant/"
    controller.vm.provision "file", source: "configure-controller", destination: "/home/vagrant/"
    controller.vm.provision "shell", inline: "sudo cp ~vagrant/.motd /etc/motd; sudo apt update; sudo apt -y install vim python3 python3-pip git"
    controller.vm.provider "virtualbox" do |vb, override|
      vb.name = "controller"
      vb.memory = "512"
      vb.cpus = 1
    end
    controller.vm.provider "hyperv" do |hv, override|
      hv.vmname = "controlle"
      hv.memory = "512"
      hv.cpus = 1
    end
    controller.vm.provision "shell", path: 'provision/ssh-keys.sh'
    controller.vm.provision "shell", path: 'provision/prepare-ansible.sh'
    controller.vm.provision "shell", path: 'provision/install_k8s.sh'
    controller.vm.provision "shell", privileged: "false", path: 'provision/configure_controller.sh'
    controller.vm.provision "shell", path: 'provision/running_sample.sh'
  end  
end
