variable "bucket" {
  description = "Bucket name to create the notification with"
  type        = string
}

variable "topic" {
  description = "Map containing topic configuration."
  type        = map(string)
  default     = {}
}

variable "queue" {
  description = "Map containing topic configuration."
  type        = map(string)
  default     = {}
}

variable "lambda_function" {
  description = "Map containing topic configuration."
  type        = map(string)
  default     = {}
}
