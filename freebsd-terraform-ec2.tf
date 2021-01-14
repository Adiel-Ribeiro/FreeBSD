provider "aws"                          {
 region                                 =         "us-east-1"
 shared_credentials_file                =         "/data/it/terraform/proj1/.cred"
 profile                                =         "default"
}

resource "aws_instance" "freebsd"       {
 ami                                    =         "ami-04d776585c8aa9c80"
 instance_type                          =         "t3.micro"
 vpc_security_group_ids                 =         ["sg-0dec897a4ea5e82e9"]
 subnet_id                              =         "subnet-0cf9ab75f0a689cf3"
 associate_public_ip_address            =         "1"
# iam_instance_profile                   =        "ecsInstanceRole" 
# cpu_core_count                         =        "1" 
 cpu_threads_per_core                   =         "2" 
 instance_initiated_shutdown_behavior   =         "stop"
 disable_api_termination                =         "0"
 monitoring                             =         "0" 
 tenancy                                =         "default"

root_block_device                       { 
 volume_size                            =         "10"
 delete_on_termination                  =         "true" 
 encrypted                              =         "false" 
# kms_key_id                            = 
}

ebs_block_device                        {
 device_name                            =         "/dev/sdf"
 volume_size                            =         "15"
 volume_type                            =         "gp2"
 delete_on_termination                  =         "true"
 encrypted                              =         "false"
}

tags                                    =         {
 Name                                   =         "freebsd"
} 

volume_tags                             = {
 Name                                   =         "freebsd"
}

provisioner "file"                      {
 source                                 =         "/data/it/terraform/freebsd/asot/init.sh"
 destination                            =         "/tmp/init.sh"
}

provisioner "remote-exec"               {
 inline                                 = [
 "chmod +x /tmp/init.sh",
 "/tmp/init.sh",
 ]
}

availability_zone                       =        "us-east-1a"

key_name                                =        "freebsd" 

connection                              {
 type                                   =        "ssh"
 user                                   =        "ec2-user"
 private_key                            =        "${file("/data/it/terraform/freebsd/freebsd.pem")}"
 host                                   =         self.public_ip
 port                                   =        "22"
}

}
