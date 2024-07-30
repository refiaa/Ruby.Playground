require 'socket'
require 'ipaddr'
require 'win32/registry'

class NetworkInfo
  # Ruby uses the 'class' keyword to define a class

  def initialize
    # This is equivalent to the __init__ method in Python
  end

  def get_ip_address
    # The '&.' operator is used for safe navigation (nil-safe method call)
    Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }&.ip_address
  end

  def get_hostname
    Socket.gethostname
  end

  def get_network_interfaces
    # '&:name' is a shorthand for calling the 'name' method on each element
    Socket.getifaddrs.map(&:name).uniq
  end

  def get_mac_address
    mac = nil

    Win32::Registry::HKEY_LOCAL_MACHINE.open('SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}') do |reg|
      reg.each_key do |key, _|
        begin
          reg.open("#{key}\\Connection") do |conn|
            mac = conn['PermanentAddress'].to_s.unpack('H2H2H2H2H2H2').join(':')
            break if mac != '00:00:00:00:00:00'
          end
        rescue Win32::Registry::Error
          next
        end
      end
    end
    mac
  end
end