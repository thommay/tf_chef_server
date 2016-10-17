data "template_file" "dna-json" {
  template = "${file("${path.module}/templates/dna-json.tpl")}"

  vars {
    addons  = "${join(",", formatlist("\\"%s\\"", split(",", var.chef-server-addons)))}"
    version = "${var.chef-server-version}"
  }
}

data "template_file" "chef_bootstrap" {
  template = "${file("${path.module}/templates/chef_bootstrap.tpl")}"

  vars {
    chef-server-user           = "${var.chef-server-user}"
    chef-server-user-full-name = "${var.chef-server-user-full-name}"
    chef-server-user-email     = "${var.chef-server-user-email}"
    chef-server-user-password  = "${var.chef-server-user-password}"
    chef-server-org-name       = "${var.chef-server-org-name}"
    chef-server-org-full-name  = "${var.chef-server-org-full-name}"
  }
}

resource "aws_instance" "chef-server" {
  ami           = "${lookup(var.aws_ami, var.region)}"
  instance_type = "${var.instance_type}"

  tags {
    Name      = "chef-server"
    X-Contact = "Thom May <tmay@chef.io>"
  }

  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${split(",", var.vpc_security_group_ids)}"]
  key_name               = "${var.key_name}"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.private_ssh_key_path}")}"
    host        = "${self.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/chef/cache",
      "sudo chown ubuntu /var/chef",
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
      "sudo chef-client -z -c /var/chef/cookbooks/.chef/config.rb -j /var/chef/dna.json",
      "chmod +x /tmp/chef-server-bootstrap.sh",
      "sudo sh /tmp/chef-server-bootstrap.sh",
    ]
  }
}
