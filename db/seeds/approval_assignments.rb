# approval assignments
[
    {category: "FOREIGN_WORKER_AMENDMENT", last_approval_approver_id: 0},
    {category: "EMPLOYER_REGISTRATION", last_approval_approver_id: 0},
    {category: "CHANGE_OF_EMPLOYER", last_approval_approver_id: 0},
    {category: "EMPLOYER_AMENDMENT", last_approval_approver_id: 0},
    {category: "TRANSACTION_SPECIAL_RENEWAL", last_approval_approver_id: 0},
    {category: "TRANSACTION_BYPASS_FINGERPRINT", last_approval_approver_id: 0},
].each do |data|
    b = ApprovalAssignment.where(category: data[:category]).first_or_create
    b.update(data)
end

puts("approval assignments seeded")