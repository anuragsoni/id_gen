defmodule IdGenTest.Util do
  use ExUnit.Case
  doctest IdGen.Util

  test "can return the first valid interface from given list" do
    interfaces = [
      {'foo',
       [
         flags: [:up, :loopback, :running, :multicast],
         addr: {127, 0, 0, 1}
       ]},
      {'PQR', [flags: []]},
      {'qe1',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: [10, 1, 9, 12, 11, 46]
       ]},
      {'second',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: [18, 2, 18, 1, 6, 0]
       ]}
    ]

    assert IdGen.Util.extract_interface(interfaces) == 'qe1'
  end

  test "can correctly filter null mac address" do
    interfaces = [
      {'foo',
       [
         flags: [:up, :loopback, :running, :multicast],
         addr: {127, 0, 0, 1}
       ]},
      {'PQR', [flags: []]},
      {'qe1',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: [0, 0, 0, 0, 0, 0]
       ]},
      {'second',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: [18, 2, 18, 1, 6, 0]
       ]}
    ]

    assert IdGen.Util.extract_interface(interfaces) == 'second'
  end

  test "can correctly filter nil mac address" do
    interfaces = [
      {'foo',
       [
         flags: [:up, :loopback, :running, :multicast],
         addr: {127, 0, 0, 1}
       ]},
      {'PQR', [flags: []]},
      {'qe1',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: nil
       ]},
      {'second',
       [
         flags: [:up, :broadcast, :running, :multicast],
         hwaddr: [18, 2, 18, 1, 6, 0]
       ]}
    ]

    assert IdGen.Util.extract_interface(interfaces) == 'second'
  end
end
