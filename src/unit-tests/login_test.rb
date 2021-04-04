require 'test/unit'
require_relative '../login'

class LoginTest < Test::Unit::TestCase
    def assertnoargs
        assert_raise(ArgumentError){
            login_prompt()
        }
    end
    def args_must_be_array
        assert_raise(TypeError){
            login_prompt("admin")
        }
    end
    def assertnoerror
        assert_not_nil(login_prompt(username: "admin", password: "admin"))
    end
end