# Create an ECS cluster
resource "aws_ecs_cluster" "netflix-clone-cluster" {
  name = "netflix-clone"
}

# Create a task definition for the backend service
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  container_definitions     = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
  cpu                      = "256"
  memory                   = "512"
}

# Create an ECS service for the backend
resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.netflix-clone-cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public_subnet.*.id
    security_groups = [aws_security_group.ecs_service_sg.id]
  }
}
