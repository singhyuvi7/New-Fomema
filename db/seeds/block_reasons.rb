# block reasons
[
    {category: "BLOCK", code: "SUSPECTFRAUD", description: "Suspected fraud"},
    {category: "BLOCK", code: "PAYMENTISSUE", description: "Payment issue"},
    {category: "BLOCK", code: "EMPREQUEST", description: "Request by employer"},
    {category: "BLOCK", code: "OTHER", description: "Others"},
    {category: "BLOCK", code: "DOCVERIFY", description: "Pending document verification"},
    {category: "UNBLOCK", code: "VERIFICATIONDONE", description: "Verification done"},
    {category: "UNBLOCK", code: "PAYMENTUPDATE", description: "Payment update"},
    {category: "UNBLOCK", code: "EMPREQUEST", description: "Request by employer"},
    {category: "UNBLOCK", code: "OTHER", description: "Others"},
    {category: "BLOCK", code: "MOHCASE", description: "MOH allowed one year approval"},
    {category: "UNBLOCK", code: "MOHCASE", description: "MOH allowed one year approval"},
    {category: "BLOCK", code: "SUSPECTED_BIOMETRIC_FRAUD", description: "Suspected biometric fraud"},
].each do |data|
    b = BlockReason.where(code: data[:code], category: data[:category]).first_or_create
    b.update(data)
end

puts("block reasons seeded")
