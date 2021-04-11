require 'test/unit'
require_relative '../methods/files'

class FilesTest < Test::Unit::TestCase
    def assertnoargs
        assert_raise(ArgumentError){
            saveinvoice()
        }
    end
    def getsclientlist
        assert_instance_of(Hash,get_invoices())
    end
    def getsinvoicelist
        assert_instance_of(Hash,get_invoices())
    end
    def cansaveinvoices
        assert_instance_of(File,saveinvoice())
    end
end