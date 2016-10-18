output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.chef-server.public_dns}"
}

output "private_dns" {
  value = "${aws_instance.chef-server.private_dns}"
}
