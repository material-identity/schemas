# Handling of measurement units in JSON schemas

## Input
* A JSON schema Forestry Source which defines a JSON capturing the harvest of wood.
* A JSON schema Forestry Output which defines a JSON describing transactions further down the value chain, linking back to Source DMPs. 
* Measurement units are stored in a database for retrieval
CommonCode | DisplayCode | Use in EU | Description
-- | -- | -- | --
BDMT | BDMT | false | Bone Dry Metric Ton
BDT | BDT | false | Bone Dry Ton
BDU | BDU | false | Bone Dry Unit
MTQ | m³ | true | Cubic Meter
EA | Each | true | Each (individual unit)
GRO | Gross | true | Gross (144 units)
GRT | GT | true | Gross Register Tonnage/Gross Tonnage
KGM | kg | true | Kilogram
STN | ton (short) | false | Short Ton
MTK | m² | true | Square Meter
MBF | MBF | false | Thousand Board Foot
MBFM | MFBM (thousand; Scribner) | false | Thousand Board Feet (Scribner scale)
2PR | Pairs | true | Pair (2 units)
LTN | ton (long) | false | Long Ton
TNE | tonne | true | Metric Ton
* A specification for a JSON schema update which introduces 3 measurement values, volume, net weight and a supplementary unit.


## Challenges

1. In import/export/customs HS code specific units are assigned from the UNECE measurement unit lists.
2. 