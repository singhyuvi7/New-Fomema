Audited.ignored_attributes = %w(lock_version)

Audited.config do |config|
    config.audit_class = CustomAudit
end