# IdGen

Generates 128 bit k-ordered ids. Exploring elixir, by translating Boundary's flake id generator


Example usage:
```elixir
IdGen.generate_id(5, :url_encoded)
["AAABYP0ajwncqQSR50IAAA==", "AAABYP0ajxHcqQSR50IAAA==",
 "AAABYP0ajxHcqQSR50IAAQ==", "AAABYP0ajxHcqQSR50IAAg==",
 "AAABYP0ajxHcqQSR50IAAw=="]
 ```
