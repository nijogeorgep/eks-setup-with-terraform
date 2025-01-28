locals {
  region = var.region_name
  istio_chart_url     = "https://istio-release.storage.googleapis.com/charts"
  istio_chart_version = "1.20.2"
  
  tags = {
    created-by = "platform_ninja"
    env        = var.environment_name
    name        = var.cluster_name
  }
}
