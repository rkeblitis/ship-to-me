require 'active_shipping'

class PackagesController < ApplicationController
  include ActiveMerchant::Shipping
  def rates



    packages = [
      Package.new(
      100,                        # 100 grams
      [93,10],                    # 93 cm long, 10 cm diameter
      :cylinder => true           # cylinders have different volume calculations
      ),

      Package.new(
      (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
      [15, 10, 4.5],              # 15x10x4.5 inches
      :units => :imperial)        # not grams, not centimetres
    ]

    # You live in Beverly Hills, he lives in Ottawa
    origin = Location.new(      :country => 'US',
    :state => 'WA',
    :city => 'Seattle',
    :zip => '98103')

    destination = Location.new( :country => 'US',
    :state => params["destination"]["state"],
    :city => params["destination"]["city"],
    :zip => params["destination"]["zip"])

    # Find out how much it'll be.
    # ups = UPS.new(:login => 'auntjudy', :password => 'secret', :key => 'xml-access-key')
    # response = ups.find_rates(origin, destination, packages)

    # ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["UPS Standard", 3936],
    #     ["UPS Worldwide Expedited", 8682],
    #     ["UPS Saver", 9348],
    #     ["UPS Express", 9702],
    #     ["UPS Worldwide Express Plus", 14502]]

    # Check out USPS for comparison...
    # usps = USPS.new(:login => 'developer-key')
    # response = usps.find_rates(origin, destination, packages)

    # usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["USPS Priority Mail International", 4110],
    #     ["USPS Express Mail International (EMS)", 5750],
    #     ["USPS Global Express Guaranteed Non-Document Non-Rectangular", 9400],
    #     ["USPS GXG Envelopes", 9400],
    #     ["USPS Global Express Guaranteed Non-Document Rectangular", 9400],
    #     ["USPS Global Express Guaranteed", 9400]]




      # make take params of the request from the client
      # send to the fedex api to get the quote

      fedex = FedEx.new(:login => ENV["FEDEX_LOGIN"], :password => ENV["FEDEX_PASSWORD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"], :test => true)
      puts fedex.inspect
      response = fedex.find_rates(origin, destination, packages)
      render json: response


      #tracking_info = fedex.find_tracking_info('11111111111', :carrier_code => 'fedex_ground') # Ground package
      # tracking_info.shipment_events.each do |event|
        #puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
      #end
      # => Package information transmitted to FedEx at NASHVILLE LOCAL, TN on Thu Oct 23 00:00:00 UTC 2008.
      # Picked up by FedEx at NASHVILLE LOCAL, TN on Thu Oct 23 17:30:00 UTC 2008.
      # Scanned at FedEx sort facility at NASHVILLE, TN on Thu Oct 23 18:50:00 UTC 2008.
      # Departed FedEx sort facility at NASHVILLE, TN on Thu Oct 23 22:33:00 UTC 2008.
      # Arrived at FedEx sort facility at KNOXVILLE, TN on Fri Oct 24 02:45:00 UTC 2008.
      # Scanned at FedEx sort facility at KNOXVILLE, TN on Fri Oct 24 05:56:00 UTC 2008.
      # Delivered at Knoxville, TN on Fri Oct 24 16:45:00 UTC 2008. Signed for by: T.BAKER
  end

end
