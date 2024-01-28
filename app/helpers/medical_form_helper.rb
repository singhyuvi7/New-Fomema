module MedicalFormHelper

    def get_barcode(transaction)

		barcode_blob = Barby::Code128.new(transaction.code)

		outputter = Barby::PngOutputter.new(barcode_blob)

		outputter.height = 46

		outputter.xdim = 2

		barcode = outputter.to_image.to_data_url

	end
end