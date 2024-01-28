class CustomAudit < Audited::Audit
    self.primary_key = "id"

    def previous_audit
        CustomAudit.where(auditable_id: self.auditable_id, auditable_type: self.auditable_type)
        .where.not(id: self.id).where("created_at <= ?", self.created_at)
        .order(created_at: :desc, id: :desc).first
    end

    def next_audit
        CustomAudit.where(auditable_id: self.auditable_id, auditable_type: self.auditable_type)
        .where.not(id: self.id).where("created_at >= ?", self.created_at)
        .order(created_at: :asc, id: :asc).first
    end
end