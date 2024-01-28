# xray providers

require 'digest'

[
    {code: "SHC", name: "Salinee Health Care", passphrase: Digest::MD5.hexdigest("Peppermint123"), provider_url: "https://xray.fomema.my/FM_NIOS/FM_NIOS_Salinee.asmx?WSDL"}
].each do |data|
    DigitalXrayProvider.create(data)
end

puts "digital xray providers seeded"