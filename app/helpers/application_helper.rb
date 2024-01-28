module ApplicationHelper
    # check current active views is in the controller
    # @param [Array] page_controllers
    # @return [Boolean]
    def current_controller?(page_controllers)

        page_controllers.each do |page_controller|
            if controller_name === page_controller
                return true
            end
        end

        return false
    end

    # act as php in_array
    def in_array(model, key)
        result = false
        unless model.nil?
            if model.include? key
                result = true
            end
        end
    end

    # convert array from json column data to object for easy access
    #
    def json_array_to_object(array_data)
        json_data = array_data.to_json
        JSON.parse(json_data, object_class: OpenStruct)
    end

    # Returns Controller & Action names based on folder pathing.
    def controller_action_path_name
        "#{ controller_path.titleize.gsub(" ", "") }__#{ action_name.titleize.gsub(" ", "") }"
    end

    # Returns Controller & Action name, useful for CSS/Javascript.
    def controller_action_name
        "#{controller_name}__#{action_name}"
    end

    def get_request?
        request.get?
    end

    def flash_add(key, message)
        if key.to_s == key.to_s.pluralize
            flash[key] = [] if !flash[key]
            flash[key] << message
        else
            flash[key] = message
        end
    end
end
