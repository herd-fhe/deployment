module "vpc" {
  source = "../../modules/aws-network"
}

module "cluster" {
  source = "../../modules/aws-ecs"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids
  inbound_ports = [
    var.file_manager_port,
    var.herdsman_port
  ]

  ecs_instance_role = "LabRole"
}

module "storage" {
  source = "../../modules/aws-storage"

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  allowed_sgs = [module.cluster.instances_sg_id, module.worker.lambda_sg_id]
}

module "edge" {
  source = "../../modules/aws-edge"

  public_subnet_ids = module.vpc.public_subnet_ids
}

module "file_manager" {
  source = "../../modules/aws-file-manager"

  vpc_id = module.vpc.vpc_id

  ecs_id = module.cluster.ecs.id
  lb_id = module.edge.lb.id

  port = var.file_manager_port

  filesystem_id = module.storage.filesystem_id
  key_storage_ap_id = module.storage.key_storage_ap.id
  data_frame_storage_ap_id = module.storage.data_frame_storage_ap.id

  admin_username = var.admin_username
  admin_password_hash = var.admin_password_hash
}

module "worker" {
  source = "../../modules/aws-lambda-worker"

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.public_subnet_ids
  allowed_sgs = [module.cluster.instances_sg_id]

  common_storage_ap_arn = module.storage.common_ap.arn

  worker_role = "LabRole"
  worker_version = var.worker_version

  worker_log_level = "debug"
}

module "herdsman" {
  source = "../../modules/aws-herdsman"

  vpc_id = module.vpc.vpc_id

  ecs_id = module.cluster.ecs.id
  lb_id = module.edge.lb.id

  port = var.herdsman_port

  filesystem_id = module.storage.filesystem_id
  key_storage_ap_id = module.storage.key_storage_ap.id
  data_frame_storage_ap_id = module.storage.data_frame_storage_ap.id

  worker_hostname = module.worker.lambda_alb_dns_name
}