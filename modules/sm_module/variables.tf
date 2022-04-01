variable "secret_name" {
  type        = list(any)
  description = "Human readable name of the new secret."
}

variable "environment" {
  description = "The application development stage or environment."
  type        = string
  validation {
    condition     = contains(["development", "testing", "staging", "production"], var.environment)
    error_message = "Environment must be one of \"development\", \"testing\", \"staging\", \"production\"."
  }
}

variable "key_name" {
  type        = string
  description = "EC2 key-pare name."
}
