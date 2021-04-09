require 'test/unit'
require_relative '../classes/client'

class LoginTest < Test::Unit::TestCase
    def assertnoargs
        assert_raise(ArgumentError){
            client = Client.new("client")
        }
    end
    def assertprofilehash
        client = Client.new(3,"Hank","01234567","hank@propane.com")
        assert_instance_of(Hash,client.profile)
    end
    def clientsuccess
        client = Client.new()
        assert_instance_of(Client,client)
    end
    def client_can_save
        client = Client.new(3,"Hank","01234567","hank@propane.com")
        assert_instance_of(Hash,client.save())
    end
end