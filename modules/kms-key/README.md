# KMS key

Creates a rotating customer-managed KMS key with a 30-day deletion window, an alias, and an input-scoped key policy. Account root retains key administration; supplied roles and service principals receive only data-key operations.

Required inputs: `key_description`, `alias_name`, `account_id`, `admin_role_arns`, `tags`.
