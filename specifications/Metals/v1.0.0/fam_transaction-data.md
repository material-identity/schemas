# Transaction Data

## Aspect Overview

### Aspect Name

**Name**: Transaction Data

### Aspect Category

- [ ] Physical Properties
- [ ] Chemical Properties
- [ ] Delivery Conditions
- [ ] Processing Information
- [ ] Quality Attributes
- [x] Compliance Data
- [ ] Sustainability Metrics
- [x] Other: **Business Transaction Data**

### Priority

- [x] Core (Required)
- [ ] Standard (Recommended)
- [ ] Extended (Optional)

## Data Structure

### Primary Data Elements

List the main data fields for this aspect:

| Field Name | Data Type | Required | Description | Example |
|------------|-----------|----------|-------------|---------|
| PurchaseOrder | object | Yes | Customer's purchase order information | See sub-aspect |
| PurchaseOrderConfirmation | object | No | Supplier's confirmation of the purchase order | See sub-aspect |
| SalesOrder | object | No | Supplier's internal sales order | See sub-aspect |
| DeliveryNote | object | Yes | Delivery/shipping documentation | See sub-aspect |
| ContractNumber | string | No | Framework contract or agreement number | "FA-2024-001" |
| ProjectReference | string | No | Customer's project reference | "PROJ-ABC-123" |
| IncoTerms | string | No | International commercial terms | "DAP", "EXW" |
| PaymentTerms | string | No | Payment terms agreed | "Net 30 days" |

### Sub-aspects

Break down into specific components:

#### Sub-aspect 1: Purchase Order

- **Description**: Customer's order placed with the supplier
- **Data Elements**:
  - OrderNumber: String - Customer's PO number
  - OrderDate: Date - Date PO was issued
  - OrderPosition: String - Line item on PO
  - Quantity: Number - Ordered quantity
  - QuantityUnit: String - Unit of measure
  - RequestedDeliveryDate: Date - Customer's requested date
  - CustomerProductId: String - Customer's material code
  - CustomerProductName: String - Customer's description
  - Specifications: Array[String] - Required specifications
  - SpecialRequirements: String - Additional requirements

#### Sub-aspect 2: Purchase Order Confirmation

- **Description**: Supplier's acknowledgment and confirmation of the PO
- **Data Elements**:
  - ConfirmationNumber: String - Supplier's confirmation ID
  - ConfirmationDate: Date - Date of confirmation
  - ConfirmedQuantity: Number - Quantity supplier can deliver
  - ConfirmedDeliveryDate: Date - Supplier's committed date
  - DeliverySchedule: Array - Multiple delivery dates/quantities
  - TechnicalContact: Person - Technical questions contact
  - CommercialContact: Person - Commercial questions contact
  - Deviations: Array[String] - Any deviations from PO
  - LeadTime: String - Production lead time

#### Sub-aspect 3: Sales Order

- **Description**: Supplier's internal sales order
- **Data Elements**:
  - SalesOrderNumber: String - Internal SO number
  - SalesOrderDate: Date - SO creation date
  - SalesOrderPosition: String - SO line item
  - ProductionOrderNumber: String - Link to production
  - PlannedProductionDate: Date - Production schedule
  - InternalProductId: String - Supplier's material code
  - InternalProductName: String - Supplier's description
  - ProductionLocation: String - Manufacturing site
  - SalesRegion: String - Sales territory/region

#### Sub-aspect 4: Delivery Note

- **Description**: Shipping/delivery documentation
- **Data Elements**:
  - DeliveryNoteNumber: String - Delivery note ID
  - DeliveryNoteDate: Date - Issue date
  - DeliveryPosition: String - Line item
  - DeliveredQuantity: Number - Actual shipped quantity
  - QuantityUnit: String - Unit of measure
  - GrossWeight: Number - Total weight including packaging
  - NetWeight: Number - Product weight only
  - WeightUnit: String - Weight unit (kg, lbs)
  - PackageCount: Number - Number of packages
  - PackageType: String - Type of packaging
  - ShippingDate: Date - Actual ship date
  - EstimatedArrival: Date - ETA at destination
  - TrackingNumber: String - Shipment tracking
  - TransportMode: String - Mode of transport
  - Carrier: String - Transport company
  - VehicleId: String - Truck/container number

## Validation Rules

### Required Validations

- PurchaseOrder.OrderNumber is required
- DeliveryNote.DeliveryNoteNumber is required
- Quantities must be positive numbers
- Dates must be in valid format
- DeliveredQuantity should not exceed OrderedQuantity (warning)

### Format Validations

- Date format: ISO 8601 (YYYY-MM-DD)
- IncoTerms: Valid 3-letter codes (EXW, DAP, CIF, etc.)
- Weight units: kg, t, lbs, MT
- Quantity units must be consistent across documents

### Business Rules

- PO date should precede confirmation date
- Confirmation date should precede delivery date
- Sales order links to purchase order
- Delivery note references both PO and SO
- Multiple deliveries may fulfill one PO
- Partial deliveries should be tracked
- Over-delivery may require approval

## Use Cases

### Primary Use Cases

1. **Order Tracking**: Follow order from placement to delivery
2. **Delivery Verification**: Match delivered goods to orders
3. **Invoice Matching**: Three-way match (PO-Receipt-Invoice)
4. **Supply Chain Visibility**: Track order status and delays
5. **Compliance Documentation**: Prove order fulfillment
6. **Dispute Resolution**: Reference for quantity/quality issues
7. **ERP Integration**: Sync with customer/supplier systems
8. **Audit Trail**: Complete transaction documentation

### Integration Points

Where does this aspect connect with other parts of the format?

- **Parties**: Links Customer, Supplier, GoodsReceiver
- **Product**: What was ordered and delivered
- **Measurements**: Quality per specifications
- **Certificates**: Which cert covers which delivery
- **Traceability**: Order to batch/heat mapping
- **Logistics**: Shipping and transport details

## Implementation Considerations

### Technical Requirements

- Support for multiple deliveries per order
- Handling of partial shipments
- Order change management
- Quantity unit conversions
- Date/time zone handling
- Document versioning

### Standards Compliance

- ISO 8601: Date and time format
- UN/EDIFACT: EDI standards
- Incoterms 2020: Trade terms
- GS1: Product identification
- Industry EDI standards (ANSI X12, EDIFACT)

### Industry Practices

- PO acknowledgment within 24-48 hours
- Delivery note accompanies shipment
- Electronic copies precede physical delivery
- Order changes require confirmation
- Framework contracts reference
- Batch/serial number tracking
- Certificate linked to delivery

## JSON Schema Example

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "TransactionData": {
      "type": "object",
      "properties": {
        "PurchaseOrder": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string",
              "description": "Customer's purchase order number"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string",
              "description": "Line item on the order"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "QuantityUnit": {
              "type": "string",
              "enum": ["kg", "t", "lbs", "MT", "m", "m²", "m³", "pieces", "each"]
            },
            "RequestedDeliveryDate": {
              "type": "string",
              "format": "date"
            },
            "CustomerProductId": {
              "type": "string"
            },
            "CustomerProductName": {
              "type": "string"
            },
            "Specifications": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "SpecialRequirements": {
              "type": "string"
            }
          },
          "required": ["Number", "Date", "Quantity", "QuantityUnit"]
        },
        "PurchaseOrderConfirmation": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "DeliveryDate": {
              "type": "string",
              "format": "date"
            }
          }
        },
        "SalesOrder": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string"
            },
            "ProductionOrderNumber": {
              "type": "string"
            },
            "PlannedProductionDate": {
              "type": "string",
              "format": "date"
            },
            "InternalProductId": {
              "type": "string"
            },
            "InternalProductName": {
              "type": "string"
            }
          }
        },
        "DeliveryNote": {
          "type": "object",
          "properties": {
            "Number": {
              "type": "string"
            },
            "Date": {
              "type": "string",
              "format": "date"
            },
            "Position": {
              "type": "string"
            },
            "Quantity": {
              "type": "number",
              "minimum": 0
            },
            "QuantityUnit": {
              "type": "string"
            },
            "GrossWeight": {
              "type": "number",
              "minimum": 0
            },
            "NetWeight": {
              "type": "number",
              "minimum": 0
            },
            "WeightUnit": {
              "type": "string",
              "enum": ["kg", "t", "lbs", "MT"]
            },
            "PackageCount": {
              "type": "integer",
              "minimum": 1
            },
            "PackageType": {
              "type": "string",
              "examples": ["Bundle", "Pallet", "Box", "Crate", "Container"]
            },
            "ShippingDate": {
              "type": "string",
              "format": "date"
            },
            "EstimatedArrival": {
              "type": "string",
              "format": "date"
            },
            "TrackingNumber": {
              "type": "string"
            },
            "TransportMode": {
              "type": "string",
              "enum": ["Road", "Rail", "Sea", "Air", "Multimodal"]
            },
            "Carrier": {
              "type": "string"
            },
            "VehicleId": {
              "type": "string"
            }
          },
          "required": ["Number", "Date", "Quantity", "QuantityUnit"]
        },
        "ContractNumber": {
          "type": "string"
        },
        "ProjectReference": {
          "type": "string"
        },
        "IncoTerms": {
          "type": "string",
          "pattern": "^[A-Z]{3}$",
          "examples": ["EXW", "FCA", "CPT", "CIP", "DAP", "DPU", "DDP", "FAS", "FOB", "CFR", "CIF"]
        }
      },
      "required": ["PurchaseOrder", "DeliveryNote"]
    }
  },
  "required": ["TransactionData"]
}
```

## Sample Data

```json
{
  "TransactionData": {
    "PurchaseOrder": {
      "Number": "20592692(1004321)",
      "Date": "2019-07-15",
      "Position": "10",
      "Quantity": 4.488,
      "QuantityUnit": "t",
      "RequestedDeliveryDate": "2019-09-15",
      "CustomerProductId": "BMS-7-323-STEEL",
      "CustomerProductName": "Aircraft Grade Steel per Boeing Spec",
      "Specifications": [
        "E4340M TO AMS6419",
        "BS EN10204/LSS AIRCRAFT RELEASE PROCEDURE"
      ],
      "SpecialRequirements": "Vacuum Arc Remelted, 100% UT tested"
    },
    "PurchaseOrderConfirmation": {
      "Number": "OC-CB828303-01",
      "Date": "2019-07-17",
      "Quantity": 4.488,
      "DeliveryDate": "2019-09-24",
    },
    "SalesOrder": {
      "Number": "CB828303",
      "Date": "2019-07-17",
      "Position": "10",
      "ProductionOrderNumber": "WO-8R518V",
      "PlannedProductionDate": "2019-08-15",
      "InternalProductId": "E4340M-VAR",
      "InternalProductName": "E4340M Vacuum Arc Remelted Steel",
    },
    "DeliveryNote": {
      "Number": "DN-00740730/1",
      "Date": "2019-09-24",
      "Position": "1",
      "Quantity": 4.488,
      "QuantityUnit": "t",
      "GrossWeight": 4650,
      "NetWeight": 4488,
      "WeightUnit": "kg",
      "PackageCount": 3,
      "PackageType": "Bundle",
      "ShippingDate": "2019-09-24",
      "EstimatedArrival": "2019-09-26",
      "TrackingNumber": "LSS-2019-09-24-001",
      "TransportMode": "Road",
      "Carrier": "Liberty Transport Services",
      "VehicleId": "TR-UK-1234"
    },
    "ContractNumber": "FA-BOEING-2019-001",
    "ProjectReference": "737-MAX-LANDING-GEAR",
    "IncoTerms": "DAP"
  }
}
```

## Notes

### Implementation Notes

- Support multiple PO positions in single certificate
- Handle order amendments and changes
- Track partial deliveries and backorders
- Support for call-off orders from contracts
- Multi-language support for product names
- Integration with EDI systems
- Support for dropship scenarios
- Handle quantity tolerances (+/- percentages)

### Related Aspects

- Parties (buyer, seller, ship-to addresses)
- Product (what is being ordered/delivered)
- Certificates (which cert covers which delivery)
- Traceability (order to production batch link)
- Quality (specifications and requirements)
- Logistics (detailed shipping information)
- Financial (pricing and payment terms)

### References

- ISO 8601: Date and time representations
- ISO 4217: Currency codes
- Incoterms 2020: International Commercial Terms
- UN/EDIFACT: Electronic Data Interchange standards
- ANSI X12: EDI Transaction Sets
- GS1 Standards: Global Trade Item Numbers
- Industry-specific ordering standards