data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
 family             = "my-ecs-task"
 network_mode       = "awsvpc"
 requires_compatibilities = ["EC2"]
 execution_role_arn = data.aws_iam_role.ecsTaskExecutionRole.arn
 cpu                = 1024
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "ARM64"
 }
 container_definitions = jsonencode([
   {
     name      = "dockergs"
     image     = "public.ecr.aws/nginx/nginx:1.27-bookworm"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
   }
 ])
}

resource "aws_ecs_service" "ecs_service" {
 name            = "my-ecs-service"
 cluster         = var.ecs_cluster_id
 task_definition = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count   = 1

 network_configuration {
   subnets         = var.subnet_ids
   security_groups = [aws_security_group.ecs-task-sg.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 triggers = {
   redeployment = timestamp()
 }

 capacity_provider_strategy {
   capacity_provider = var.ecs_capacity_provider_name
   weight            = 100
 }
}