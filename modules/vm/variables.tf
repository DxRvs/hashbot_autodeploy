variable "cpu_cores" {
  description = "cores count"
  type        = string
}

variable "memgb" {
  description = "momory GB count"
  type        = string
}

variable "platform_id" {
  description = "type of platform"
  type        = string
  default = "standard-v1"
}

  