#!/usr/bin/env python3
"""
Migrate HeatTreatment from Product to top-level in DigitalMaterialPassport
"""
import json
import sys

def migrate_heat_treatment(data):
    """Move HeatTreatment from Product to DigitalMaterialPassport level"""
    if 'DigitalMaterialPassport' not in data:
        return data, False

    dmp = data['DigitalMaterialPassport']

    # Check if Product has HeatTreatment
    if 'Product' not in dmp or 'HeatTreatment' not in dmp['Product']:
        return data, False

    # Extract HeatTreatment from Product
    heat_treatment = dmp['Product'].pop('HeatTreatment')

    # Find where to insert - after Product, before ChemicalAnalysis
    new_dmp = {}
    for key, value in dmp.items():
        new_dmp[key] = value
        if key == 'Product':
            new_dmp['HeatTreatment'] = heat_treatment

    data['DigitalMaterialPassport'] = new_dmp
    return data, True

def main():
    if len(sys.argv) < 2:
        print("Usage: migrate_heat_treatment.py <json_file>")
        sys.exit(1)

    filepath = sys.argv[1]

    with open(filepath, 'r') as f:
        data = json.load(f)

    migrated_data, changed = migrate_heat_treatment(data)

    if changed:
        with open(filepath, 'w') as f:
            json.dump(migrated_data, f, indent=2)
        print(f"✓ Migrated: {filepath}")
    else:
        print(f"- No changes needed: {filepath}")

if __name__ == '__main__':
    main()
