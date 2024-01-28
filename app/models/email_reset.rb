class EmailReset < ApplicationRecord
    STATUSES = {
        "NEW" => "New",
        "NOTFOUND" => "Not Found",
        "NOTUNIQUE" => "Not Unique",
        "COMPLETED" => "Completed",
        "EMAIL01" => "Email Used By Existing User",
        "EMAIL02" => "Email Used By Existing Employer",
    }

    audited

    belongs_to :resettable, polymorphic: true, optional: true
end
