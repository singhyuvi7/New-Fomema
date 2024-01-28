module ReportsPrivateMethods
private
    # returns either a date object or formatted string depending on request type
    # date param is either a Time or DateTime object
    def format_date(date)
        date    = date&.to_date
        date    = date&.strftime("%d/%m/%Y") if check_format_html # so that the webpage has the correct date format. Need safe operator for automated emails.
        date
    end

    def check_format_html # need to keep this here for the mailers
        begin
            # Can't run presence check on request. So only way is to rescue a request from email.
            response = request&.format == "html"
        rescue
            response = false
        end

        response
    end

    def styling(*list)
        [list.inject(&:merge)]
    end

    def bold
        { b: true }
    end

    def border(*list)
        edges = []
        edges << :left if list.include?(:l)
        edges << :right if list.include?(:r)
        edges << :top if list.include?(:t)
        edges << :bottom if list.include?(:b)
        color = list.find {|item| item.class == String }
        color ||= "000000"
        option = { border: { style: :thin, color: color } }
        option[:border].merge!({ edges: edges }) if edges.present?
        option
    end

    def align(*list)
        option = {}
        option.merge!({ horizontal: :center }) if list.include?(:h)
        option.merge!({ vertical: :center }) if list.include?(:v)
        option.merge!({ wrap_text: true }) if list.include?(:w)
        { alignment: option }
    end

    def excel_date
        { format_code: 'dd/MM/yyyy'}
    end

    def bg_color(color)
        { bg_color: color }
    end

    def font(name)
        { font_name: name }
    end

    def setting_extended_headers
        @extended_headers = 1
    end

    def setting_html_display_limit(worksheet)
        if check_format_html
            headers_footers = @extended_headers
            total_size      = worksheet.size - headers_footers
            worksheet       = worksheet.first(500 + headers_footers)
            showing_size    = worksheet.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @excel = [worksheet]
        return worksheet
    end

    def setting_csv_html_display_limit
        if check_format_html
            headers_footers = @extended_headers
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end
    end
end