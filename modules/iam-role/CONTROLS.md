| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Permissions boundary | Requires a boundary ARN and attaches it to the role. | — |
| Scoped trust | Builds the assume-role policy from the supplied principals and principal type. | — |
| Reject wildcard action | Validates every inline action and rejects literal `*`. | — |
