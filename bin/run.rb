require_relative '../lib/src.1.rb'

network_info = NetworkInfo.new

puts "IP Address: #{network_info.get_ip_address}"
puts "Hostname: #{network_info.get_hostname}"
puts "Network Interfaces: #{network_info.get_network_interfaces.join(', ')}"
puts "MAC Address: #{network_info.get_mac_address}"