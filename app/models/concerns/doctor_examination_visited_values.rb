module DoctorExaminationVisitedValues
    VISITED_FIELDS = [
        :visited_history_1,
        :visited_history_2,
        :visited_physical,
        :visited_system_1,
        :visited_system_2,
        :visited_laboratory_result,
        :visited_xray_facility_result,
        :visited_condition,
        :visited_certification,
        :visited_follow_up
    ]

    VISITED_FIELDS.each do |method_name|
        define_method("#{ method_name }") do
            set_visited_hash unless defined?(@visited_hash)
            @visited_hash[method_name]
        end
    end

    def set_visited_hash
        @visited_hash = if transmitted_at?
            VISITED_FIELDS.map {|x| [x, true] }.to_h
        elsif doctor_examination_visited
            doctor_examination_visited.slice(VISITED_FIELDS)
        else
            VISITED_FIELDS.map {|x| [x, nil] }.to_h
        end
    end

    def save_visited_values(parameters)
        de_visited = doctor_examination_visited
        de_visited ||= DoctorExaminationVisited.new(doctor_examination_id: id)
        de_visited.update(parameters)
    end

    def remove_visited_record
        doctor_examination_visited.destroy if doctor_examination_visited
    end
end