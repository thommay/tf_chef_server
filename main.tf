data "template_file" "dna-json" {
  template = "${file("${path.module}/templates/dna-json.tpl")}"

  vars {
    addons  = "${join(",", formatlist("\\"%s\\"", split(",", var.chef_server_addons)))}"
    version = "${var.chef_server_version}"
  }
}

data "template_file" "chef_bootstrap" {
  template = "${file("${path.module}/templates/chef_bootstrap.tpl")}"

  vars {
    chef-server-user           = "${var.chef_server_user}"
    chef-server-user-full-name = "${var.chef_server_user_full_name}"
    chef-server-user-email     = "${var.chef_server_user_email}"
    chef-server-user-password  = "${var.chef_server_user_password}"
    chef-server-org-name       = "${var.chef_server_org_name}"
    chef-server-org-full-name  = "${var.chef_server_org_full_name}"
  }
}

resource "aws_instance" "chef-server" {
  ami           = "${lookup(var.ami, var.region)}"
  instance_type = "${var.instance_type}"

  tags {
    Name = "chef-server"
  }

  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${split(",", var.vpc_security_group_ids)}"]
  key_name               = "${var.key_name}"

  connection {
    type        = "ssh"
    user        = "${var.ssh_user}"
    private_key = "${file("${var.private_ssh_key_path}")}"
    host        = "${self.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/chef/cache",
      "sudo chown ${var.ssh_user}: /var/chef",
    ]
  }

  # install the set of cookbooks and create a repository
  provisioner "local-exec" {
    command = "chef install ${path.module}/Policyfile.rb && chef export ${path.module}/Policyfile.rb cookbooks -f"
  }

  provisioner "file" {
    source      = "${path.module}/cookbooks"
    destination = "/var/chef"
  }

  provisioner "file" {
    content     = "${data.template_file.dna-json.rendered}"
    destination = "/var/chef/dna.json"
  }

  provisioner "file" {
    content     = "${data.template_file.chef_bootstrap.rendered}"
    destination = "/tmp/chef-server-bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -L https://www.chef.io/chef/install.sh | sudo bash",
      "sudo mkdir /etc/chef",
      "cd /var/chef/cookbooks",
      "sudo chef-client -z -j /var/chef/dna.json",
      "chmod +x /tmp/chef-server-bootstrap.sh",
      "sudo sh /tmp/chef-server-bootstrap.sh",
    ]
  }
}
