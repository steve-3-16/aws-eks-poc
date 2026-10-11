variable "name" {
  type = string
}

variable "namespace" {
  type = string
  default = ""
}

variable "image_tag_mutability" {
  type = string
  default = "IMMUTABLE"
}

variable "force_delete" {
  type = bool
  default = false
}

variable "scan_on_push" {
  type = bool
  default = true
}

variable "encryption_type" {
  type = string
  default = "KMS"
}

variable "kms_key" {
  type = string
  default = null
}

variable "create_lifecycle_policy" {
  type = bool
  default = true
}

variable "lifecycle_policy_json" {
  type = string
  default = null
}

variable "tags" {
  type = map(string)
  default = {}
}