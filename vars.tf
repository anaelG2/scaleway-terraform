variable "public_ssh_key" {
  description = "clé ssh de la machine qui va jouer le rôle de node manager"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOB/UqmPhWAcfzKyFbLeZMQsbBVF9tJJfpUHuDbfQUqqEN1fzT7JSIWk/C+kSyuE0TVTbzMd88CCyowKIPDzYJoPvx3QToSn72eX9GTAl4lM+IAx3Rw9AacYIPr2kxdVLzWdHRB8tgpe3ZmZtlFQSQVc69RQszBn6FzdY96Sqkv9gh977CcejXtYIRF2qEYE24BphGXZgJoBaKWnYm6Fj8hB2fy0dBr+gQ2HtkjRgNSJ52/UvDnNuv7jE50mBHYmwxiY/J9r6M+Va/BPsrYwcjyteyHBfPOq1vaUFBflC60+cG2D4VtW7SbV9lwZhDYi5ppxyLNcMCIzNmyWQDBxQ7oRS67T5qwCAk/oSZhNq2jf5gSnJ6mOg+6vl7pdiMY+7xTUJZAuMPvNJbd6m0ntySbJdxXeqdyaytH/CZoASJQwumYdzmsjAEAe/+l4Mrs8puSUyMzRbCc1Jdg7OlawW8AWU5sbVBdbU9imunTF81eba6FaN+wOiKi1+iV4cbJo0= anaelg@DELL-XPS"
}

variable "scaleway_project_id" {
  description = "id du projet scaleway"
  type        = string
  default     = "6f2db06c-78f0-4b7b-8ec0-ffda407257b1"
}

variable "scaleway_loadbalancer_name" {
  description = "nom donné au loadbalancer scaleway"
  type        = string
  default     = "scaleway-lb"
}

