# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  config.vm.define :victim do |c|
    c.disksize.size = '50GB'
    c.vm.provider 'virtualbox' do |vb|
      vb.memory = 512 * 2
      vb.cpus = 2
    end
    %w(80 443).each do |port|
      c.vm.network 'forwarded_port', guest: port, host: "10#{port.rjust(3, '0')}"
    end
    c.vm.synced_folder './provision', '/data'
    c.vm.provision 'shell', path: 'provision/containers.sh'
    c.vm.provision 'shell', inline: 'hostnamectl set-hostname victim.example'
    c.vm.hostname = 'victim.example'
    c.vm.network :private_network, ip:'192.168.31.10'
  end

  config.vm.define :dest do |c|
    c.disksize.size = '50GB'
    c.vm.provider 'virtualbox' do |vb|
      vb.memory = 512 * 2
      vb.cpus = 2
    end
    %w(80 443).each do |port|
      c.vm.network 'forwarded_port', guest: port, host: "11#{port.rjust(3, '0')}"
    end
    c.vm.synced_folder './provision', '/data'
    c.vm.provision 'shell', path: 'provision/containers.sh'
    c.vm.provision 'shell', inline: 'hostnamectl set-hostname dest.example'
    c.vm.hostname = 'dest.example'
    c.vm.network :private_network, ip:'192.168.31.20'
  end

  autostart_bench = !!ENV['BENCH']

  config.vm.define :bench, autostart: autostart_bench do |c|
    c.disksize.size = '50GB'
    c.vm.provider 'virtualbox' do |vb|
      vb.memory = 512 * 2
      vb.cpus = 4
    end
    c.vm.synced_folder './out', '/opt/out'
    c.vm.synced_folder './bench', '/opt/bench'
    c.vm.provision 'shell', inline: (<<-SHELL)
apt update
apt -y install apache2-utils
    SHELL
    c.vm.network 'private_network', ip: '192.168.199.20'
  end

  autostart_smtp = !!ENV['SMTP']

  config.vm.define 'smtp-server', autostart: autostart_smtp do |c|
    c.vm.provision 'file', source: './provision/hosts', destination: '/tmp/hosts'
    c.vm.provision 'shell', path: 'provision/smtp.sh'
    c.vm.hostname = 'smtp-server'
    c.vm.network :private_network, ip:'192.168.30.11'
  end

  config.vm.define 'smtp-client', autostart: autostart_smtp do |c|
    c.vm.provision 'file', source: './provision/hosts', destination: '/tmp/hosts'
    c.vm.provision 'file', source: './provision/sender.sh', destination: '/tmp/sender.sh'
    c.vm.provision 'shell', path: 'provision/smtp.sh'
    c.vm.hostname = 'smtp-client'
    c.vm.network :private_network, ip:'192.168.30.12'
  end

  config.vm.define 'smtp-rcpt', autostart: autostart_smtp do |c|
    c.vm.provision 'file', source: './provision/hosts', destination: '/tmp/hosts'
    c.vm.provision 'shell', path: 'provision/smtp.sh'
    c.vm.hostname = 'smtp-rcpt'
    c.vm.network :private_network, ip:'192.168.30.13'
  end

  config.vm.define 'smtp-tarpit', autostart: autostart_smtp do |c|
    c.vm.provision 'file', source: './provision/hosts', destination: '/tmp/hosts'
    c.vm.provision 'file', source: './provision/mxtarpit.service', destination: '/tmp/mxtarpit.service'
    c.vm.provision 'shell', path: 'provision/smtp-tarpit.sh'
    c.vm.hostname = 'smtp-tarpit'
    c.vm.network :private_network, ip:'192.168.30.14'
  end
end
