require 'rmagick'

module Watermark
    def add_watermark(document)
        if document.content_type == "application/pdf"
            begin
                watermark = CombinePDF.load(Rails.root + "public/files/fomema_use_only.pdf").pages[0]
                pdf = CombinePDF.load(document.path)
                pdf.pages.each {|page| page << watermark} # notice the << operator is on a page and not a PDF object.
                pdf.save document.path
            rescue Exception => e
            end
        else
            img = Magick::ImageList.new(document.path)

            watermark_img = Magick::Image.new(img.rows, img.columns) do |c|
                c.background_color= "none"
            end

            default_watermark_text = "FOR FOMEMA USE ONLY    FOR FOMEMA USE ONLY    FOR FOMEMA USE ONLY    FOR FOMEMA USE ONLY"
            alternate_watermark_text = "FOR FOMEMA \n USE ONLY"
            default_text_size = 80

            img_diagonal = Math.sqrt(img.rows**2 + img.columns**2)

            if img.rows < 800 || img.columns < 800 || img_diagonal < 1000
                watermark_text = default_watermark_text
                text_size = 0.5 * default_text_size
            else
                watermark_text = default_watermark_text
                text_size = default_text_size
            end

            draw = Magick::Draw.new
            gravity_array = [Magick::NorthGravity, Magick::CenterGravity, Magick::SouthGravity]

            gravity_array.each do |gravity|
                draw.annotate(watermark_img, 0, 0, 0, 0, watermark_text) do
                    # place the text in the centre of the canvas
                    draw.gravity = gravity #Magick::NorthWestGravity #Magick::CenterGravity
                    # set text height in points where 1 point is 1/72 inches
                    draw.pointsize = text_size
                    draw.font_family = "Times" # set font
                    draw.fill = "black" # set text color
                    draw.stroke = "none" # remove stroke
                end
            end

            # rotate this mark by 45 degrees anticlockwise (optional)
            # if we do not specify 'background_color' on 'mark' then on rotation the background color will be black.
            # we want it to be transparent.
            watermark_img = watermark_img.rotate(-45)

            img = img.watermark(watermark_img, 0.2, 0, Magick::CenterGravity)
            img.write(document.path)    # Destination image
        end

    end
end