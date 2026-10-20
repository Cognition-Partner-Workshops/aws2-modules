# IAM role

Creates an assumable workload role with a mandatory permissions boundary and optional inline policy statements. A literal wildcard action is rejected during input validation.

Required inputs: `role_name`, `permissions_boundary_arn`, `assume_role_principals`, `tags`.

Optional inputs: `inline_policy_statements`, `inline_policy_name`, `assume_role_principal_type`.
