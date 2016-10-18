# tf\_chef\_server

Terraform module to create a Chef Server.

## Outputs

  * public\_ip  - The public IP of the Chef Server
  * public\_dns - The public hostname of the Chef Server
  * private\_ip - The private IP of the Chef Server

## Variables

### EC2 and machine details
  * region                      - The AWS region
  * subnet\_id                  - The EC2 subnet ID
  * vpc\_security\_group\_ids   - A comma separated string of security group IDs
  * ami                         - EC2 AMI
  * instance\_type              - Instance Type
  * key\_pair                   - Your AWS key pair
  * private\_ssh\_key\_path     - Path to your ssh private key
  * ssh\_user                   - User to SSH as

### Chef details
  * chef\_server\_version - The version of Chef Server to install
  * chef\_server\_user - The account name of the chef admin user
  * chef\_server\_user\_full\_name - The full name of the chef admin user
  * chef\_server\_user\_email - The email of the chef admin user
  * chef\_server\_user\_password - The password of the chef admin user
  * chef\_server\_org\_name - The name of the chef organization
  * chef\_server\_user\_full\_name - The display name of the chef organization
  * chef\_server\_addons - A comma separated string of chef server addons
  
## Example

```
module "tf_chef_server" {
  source = "github.com/thommay/tf_chef_server"
  region = "us-west-2"

  subnet_id = "${aws_subnet.primary.id}"

  vpc_security_group_ids = "${aws_security_group.access.id}"

  key_name                   = "${var.aws_key_pair}"
  private_ssh_key_path       = "${var.private_ssh_key_path}"
  ami                        = "${var.ami}"
  ssh_user                   = "ubuntu"

  chef_server_version        = "12.9.1"
  chef_server_addons         = "manage,reporting"
  chef_server_user           = "admin"
  chef_server_user_full_name = "Admin User"
  chef_server_user_email     = "Admin@example.com"
  chef_server_user_password  = "p@ssword"
  chef_server_org_name       = "my_org"
  chef_server_org_full_name  = "my org"
}
```

# LICENSE

Apache2 - See the included LICENSE file for more details.
