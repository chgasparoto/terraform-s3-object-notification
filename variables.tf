variable "name" {
  description = "Bucket unique name. It can contain only number, letter and dash."
  type        = string
}

variable "acl" {
  description = "Access Control Lists. It defines which AWS accounts or groups are granted access and the type of access"
  type        = string
  default     = "private"
}

variable "policy" {
  description = "Bucket policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "Bucket tags"
  type        = map(string)
  default     = {}
}

variable "key_prefix" {
  description = "Prefix to put your key(s) inside the bucket. E.g.: logs -> all files will be uploaded under logs/"
  type        = string
  default     = ""
}

variable "filepath" {
  description = "The local path where the desired files will be uploaded to the bucket"
  type        = string
  default     = ""
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "website" {
  description = "Map containing website configuration."
  type        = map(string)
  default     = {}
}

variable "logging" {
  description = "Map containing logging configuration."
  type        = map(string)
  default     = {}
}

variable "notification_topic" {
  description = "Map containing topic notification configuration."
  type        = map(string)
  default     = {}
}

variable "notification_queue" {
  description = "Map containing queue notification configuration."
  type        = map(string)
  default     = {}
}

variable "notification_lambda" {
  description = "Map containing lambda notification configuration."
  type        = map(string)
  default     = {}
}
