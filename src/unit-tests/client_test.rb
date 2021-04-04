require 'test/unit'
require_relative '../classes/client'

class LoginTest < Test::Unit::TestCase
    def assertnoargs
        assert_raise(ArgumentError){
            client = Client.new("client")
        }
    end
    def assertprofilehash
        client = Client.new
        assert_instance_of(Hash,client.profile)
    end
end