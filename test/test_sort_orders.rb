require 'minitest/autorun'
require 'lcsort'

# Assorted tests of proper sort orders taken from various places. 
class TestSortOrders < Minitest::Test


  def test_colostate_examples
    # http://lib.colostate.edu/howto/others/callnlce.html
    assert_sorted_order ["R 169.1 .B59 1990", "R 184.7 .N49", "R 185 .B52x"]
    assert_sorted_order ["TX 719 .M613 1977", "TX 719.M613 1983", "TX719.W47"]
    assert_sorted_order ["R 146.5 .C196", "R 146.61.N49", "R146.93.B9"]
    assert_sorted_order ["R 241 .F2498 1994", "R 241.F5 B297", "R 241 .F5 .B8", "R 241 .J18 1990", "R 418 .P72 P47", "R 2418 .J42 T14"]
  end

  def test_umich_examples
    # http://guides.lib.umich.edu/content.php?pid=41228
    assert_sorted_order ["PN 70 .P441", "PN 6231 .E29", "PN 6231 .E295", "PN 6231 .E4", "PN 6231 .E74", "PN 6231 .F44"]
    assert_sorted_order ["QE 862 .D5 L22", "QE 862 .D5 L4571", "QE 862 .D5 L461", "QE 862 .D5 M3311", "QE 862 .D5 M37"]
  end

  def test_dueber_gem_examples
    # https://github.com/billdueber/lc_callnumber/blob/master/test/test_lc_callnumber.rb#L32
    # examples taken from there, but they aren't actually listed in proper sort order
    assert_sorted_order ["A 7", "A 50", "B 528.S298", "B 528.S43", "QA 500", "QA 500.M500", "QA 500.M500 T59", "QA 500.M500 T60", "QA 500.M500 T60 A1", "QA 500.M500 T60 Z54"]
  end

  def test_stanford_examples
    # some really terrible examples from 
    # https://github.com/sul-dlss/solrmarc-sw/blob/0e3c0e8cb3378b2992edc28b25c955943df67338/core/test/src/org/solrmarc/tools/CallNumberUnitTests.java#L1114
    
    # We are taking from Stanford's "currentOrderList", which even in Stanford's
    # code diverges from what they consider "properOrderList"

    # We can't neccesarily sort all of Stanford's current order list the way
    # Stanford does either -- we comment out elements that we can't handle below. 

    # Not sorting "35th" properly yet, at least according to stanford's librarians
    list1 = [
        "AB9 L3",
        "AB9.22 L3",
        "ABR92.L3",
        "B8.14 L3",
        #"B9 20th L3",
        "B9 2000",
        #"B9 2000 35TH",
        "B9 2000 L3",
        "B9 L3",
        #"B9 SVAR .L3",
        "B9.2 2000 L3",
        "B9.2 L3",
        "B9.22 L3"
    ]
    assert_sorted_order list1

    list2 = [
        "B82 2000 L3",
        "B82 L3",
        "B82.2 1990 L3",
        "B82.2 L3",

        "B820 2000 L3",
        "B820.2 2000 L3",
        "B820.2 L3",
        "B822 L3",

        "B8200 L3",
        "B8220 L3"
    ]
    assert_sorted_order list2

    list3 = [
        "M5 K4",
        "M5 .L",
        "M5 L299",

        # first cutter L3 vol/part info 1902
        "M5 L3 1902",

        # Lcsort, can't handle volume information properly yet
        #"M5 L3 1902 V.2",
        #"M5 L3 1902 V2",
        #"M5 .L3 1902 V2 TANEYTOWN",
        #"M5 L3 1902V",
        # first cutter L3 vol/part info 2000
        "M5 .L3 2000 .K2 1880",

        # first cutter L3 vol/part info: K.2,13 2001
        # LCsort, nope, can't do this. 
        #"M5 .L3 K.2,13 2001"
    ]
    assert_sorted_order list3

    # I think we're just lucky on MOST of these, we can't
    # really do that volume information right. many commented out. 
    list4 = [
        # first cutter L3 second cutter K2
        "M5.L3.K2",
        "M5 .L3 K2 1880",
        "M5 .L3 K2 1880 M", # vol info 1880 M
        # first cutter L3 K2 1880
        "M5 .L3 K2 1880 .Q2 1777",
        "M5 .L3 K2 1882",
        "M5 .L3 K2 D MAJ 1880",
        "M5 .L3 K2 K.240", # vol info K.240
        "M5 .L3 K2 K.240 1880 F", # vol info K.240 1880 F
        "M5 .L3 K2 M V.1", # vol info M V.1
        "M5 .L3 K2 NO.1 1880", # vol info NO.1
        "M5 .L3 K2 OP.7:NO.6 1880",
        "M5 .L3 K2 OP.7:NO.6 1882",
        #"M5 .L3 K2 OP.7:NO.51 1880",  # can't do this yet
        # "M5 .L3 K2 OP.8",
        # "M5 .L3 K2 OP.79",
        # "M5 .L3 K2 OP.789",
        # "M5 .L3 K2 Q2 1880" # suffix Q2
    ]
    assert_sorted_order list4

    list5 = [
        # "M5 L3 .K240",
        # "M5 L3 K240 1900",
        # "M5 .L3 K240A",
        # "M5 .L3 K240B M",
        # "M5 L3 K240 DB",
        # "M5 .L3 K2 1880 .Q2 1777",  # TODO: Wrong - suffix vs. cutter norm
        # "M5 .L3 K2 .Q2 MD:CRAPO*DMA 1981",
        "M5 .L3 K2 Q2 .A1",

        # "M5 L3 V.188", # title/part suffix
        "M5 L3 V188", # second cutter

    ]
    assert_sorted_order list5

    list6 = [        
        # back to solid territory
        "M5 L31",
        "M5 L31902",
        "M5 M2"
    ]
    assert_sorted_order list6

    # they should all be in order too

    assert_sorted_order list1 + list2 + list3 + list4 + list5 + list6
  end

  def test_with_large_decimals
    assert_sorted_order([
      "R 241.23 .F2498 1994",
      "R 241.230001 .F2498 1994",
      "R 241.231 .F2498 1994",
      "R 241.244444 .F2498 1994",
      "R 241.244445 .F2498 1994",
      "R 241.3 .A498 1994"
    ])
  end


  def assert_sorted_order(array)
    assert_equal array, array.shuffle.sort_by {|call_num| Lcsort.normalize(call_num)}
  end

end