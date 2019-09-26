require_relative 'city'
require_relative 'zip_code'

module SmartyStreets
  module USZipcode
    # See "https://smartystreets.com/docs/cloud/us-zipcode-api#root"
    class Result
      attr_reader :reason, :input_id, :input_index, :cities, :zipcodes, :status

      def initialize(obj)
        @status = obj['status']
        @reason = obj['reason']
        @input_id = obj['input_id']
        @input_index = obj['input_index']
        @cities = obj.fetch('city_states', [])
        @zipcodes = obj.fetch('zipcodes', [])

        @cities = convert_cities
        @zipcodes = convert_zipcodes
      end

      def valid?
        @status.nil? and @reason.nil?
      end

      def convert_cities
        converted_cities = []

        @cities.each do |city|
          converted_cities.push(City.new(city))
        end

        converted_cities
      end

      def convert_zipcodes
        converted_zipcodes = []

        @zipcodes.each do |zipcode|
          converted_zipcodes.push(ZipCode.new(zipcode))
        end

        converted_zipcodes
      end
    end
  end
end
