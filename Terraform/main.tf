provider "aws" {
  region = "us-east-1" // Change to your desired region
}

// Define ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "hello-world-cluster"
}

// Define ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "hello-world-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  
  container_definitions = jsonencode([
    {
      name      = "hello-world-container"
      image     = "your-docker-image"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 0
        }
      ]
    }
  ])
}

// Define ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = ["subnet-xxx"] // Define your subnet IDs
    security_groups = ["sg-xxx"]      // Define your security group IDs
    assign_public_ip = true
  }
}
