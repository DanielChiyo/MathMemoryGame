#https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/launch_container_instance.html


resource "aws_launch_template" "ecs_lt" {
 name_prefix   = var.ecs_cluster_name
 image_id      = var.ecs_ami
 instance_type = "t4g.nano"

 vpc_security_group_ids = [aws_security_group.ecs-ec2-sg.id]
 iam_instance_profile {
   name = "ecsInstanceRole" #The role was created appart from this module
 }

 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp3"
   }
 }

 tag_specifications {
   resource_type = "instance"
    tags = {
        Name = format("%s ECS ASG Instance", var.project_name)
        Project = var.project_name
        Environment = var.environment
    }
 }

  user_data = base64encode(templatefile("${path.module}/ecs_user_data.sh.tpl", {
    cluster_name = var.ecs_cluster_name
  }))
}

resource "aws_autoscaling_group" "ecs_asg" {
 name                = format("%s ASG", var.project_name)
 vpc_zone_identifier = var.asg_subnet_ids
 desired_capacity    = 1
 max_size            = 1
 min_size            = 1

 launch_template {
   id      = aws_launch_template.ecs_lt.id
   version = "$Latest"
 }

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }

}