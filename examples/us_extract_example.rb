require 'smartystreets_ruby_sdk/static_credentials'
require 'smartystreets_ruby_sdk/client_builder'
require 'smartystreets_ruby_sdk/us_extract/lookup'

class USExtractExample
  Lookup = SmartyStreets::USExtract::Lookup

  def run
    # auth_id = 'Your SmartyStreets Auth ID here'
    # auth_token = 'Your SmartyStreets Auth Token here'

    # We recommend storing your secret keys in environment variables instead---it's safer!
    auth_id = ENV['SMARTY_AUTH_ID']
    auth_token = ENV['SMARTY_AUTH_TOKEN']

    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)

    client = SmartyStreets::ClientBuilder.new(credentials).build_us_extract_api_client

    text = "Here is some text.\r\nMy address is 3785 Las Vegs Av." \
           "\r\nLos Vegas, Nevada." \
           "\r\nMeet me at 1 Rosedale Baltimore Maryland, not at 123 Phony Street, Boise Idaho."

    # Documentation for input fields can be found at:
    # https://smartystreets.com/docs/cloud/us-extract-api

    lookup = Lookup.new(text)
    lookup.aggressive = true
    lookup.addresses_have_line_breaks = false
    lookup.addresses_per_line = 2

    result = client.send(lookup)

    metadata = result.metadata
    puts "Found #{metadata.address_count} addresses."
    puts "#{metadata.verified_count} of them were valid."
    puts

    addresses = result.addresses

    puts "Addresses: \r\n**********************\r\n"
    addresses.each do |address|
      puts "\"#{address.text}\"\n\n"
      puts "Verified? #{address.verified}"
      if address.candidates.any?
        puts("\nMatches:")

        address.candidates.each do |candidate|
          puts candidate.delivery_line_1
          puts candidate.last_line
          puts
        end

      else
        puts
      end

      puts "**********************\n"
    end
  end
end

USExtractExample.new.run
