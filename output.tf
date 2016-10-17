output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
