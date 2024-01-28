module XrayRetakeRequest
    def create_retake_request(status: 'DRAFT')
        retake_data = {
            requestable_type: self.to_s,
            requestable_id: self.id,
            transaction_id: self.transactionz.id,
            xray_facility_id: self.transactionz.xray_facility_id,
            xray_film_type: self.transactionz.xray_film_type,
            status: status
        }

        self.xray_retakes.create(retake_data)
    end
end