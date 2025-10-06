---
name: Feature Enhancement Proposal - Remove Status Column from PDF
about: Remove the Status column from mechanical/physical properties tables in PDF rendering
title: 'fep: Remove Status column from measurement tables in PDF'
labels: enhancement, Metals, pdf-rendering
assignees: ''
---

## Summary

Remove the "Status" column (showing ✓/✗/! symbols) from all measurement property tables in the Metals PDF rendering.

## Motivation

The Status column provides limited value and takes up valuable space in the PDF:
- The checkmark/cross symbols are redundant with the `Interpretation` field already present in the data
- Most certificates show all passing results (✓), making the column visually monotonous
- Removing it provides more horizontal space for property names and values
- The textual `Interpretation` field provides more context than a symbol

## Current Behavior

Measurement tables currently include 7 columns:
1. Property
2. Symbol
3. Actual
4. Minimum
5. Maximum
6. Method
7. **Status** (✓/✗/!)

## Proposed Changes

### XSLT Updates

Remove Status column from three property sections in `schemas/Metals/v0.1.0/stylesheet.xsl`:

#### 1. Mechanical Properties (around line 980)

**Before:**
```xml
<fo:table-column column-width="20%" />
<fo:table-column column-width="10%" />
<fo:table-column column-width="15%" />
<fo:table-column column-width="15%" />
<fo:table-column column-width="15%" />
<fo:table-column column-width="20%" />
<fo:table-column column-width="5%" />  <!-- Status column -->
```

**After:**
```xml
<fo:table-column column-width="22%" />  <!-- Property -->
<fo:table-column column-width="10%" />  <!-- Symbol -->
<fo:table-column column-width="17%" />  <!-- Actual -->
<fo:table-column column-width="17%" />  <!-- Minimum -->
<fo:table-column column-width="17%" />  <!-- Maximum -->
<fo:table-column column-width="17%" />  <!-- Method -->
```

Remove Status header cell and Status table-cell rendering logic.

#### 2. Physical Properties (around line 1140)

Apply similar changes to Physical Properties table.

#### 3. Supplementary Tests (around line 1280)

Apply similar changes to Supplementary Tests table.

### Layout Improvements

The reclaimed 5% width should be redistributed to:
- Property name column (+2%)
- Actual/Min/Max columns (+1% each)

This provides better readability for longer property names and values.

## Benefits

- **Cleaner layout**: Less visual clutter
- **More space**: Better accommodation of long property names and method descriptions
- **Simplicity**: One less column to maintain and translate
- **Consistency**: Interpretation is already available in the data model if needed

## Backward Compatibility

This is a visual/presentation change only:
- ✅ No schema changes required
- ✅ No data model changes
- ✅ Existing JSON files remain valid
- ✅ Only affects PDF rendering

## Alternative Considered

Keep Status column but make it optional based on a configuration flag. **Rejected** because:
- Adds complexity for minimal benefit
- Most users don't need status symbols when numeric values and limits are clearly shown

## Acceptance Criteria

- [ ] Status column removed from Mechanical Properties table
- [ ] Status column removed from Physical Properties table
- [ ] Status column removed from Supplementary Tests table
- [ ] Column widths redistributed for better layout
- [ ] Status rendering logic cleaned up (header, cell template calls)
- [ ] PDF regenerated for all test fixtures
- [ ] Visual regression testing confirms improved layout
- [ ] Documentation updated if Status column was referenced

## Implementation Notes

Look for these patterns in the XSLT:
- `<fo:table-column column-width="5%" />` - Status column definition
- `<fo:block font-style="italic" text-align="center">Status</fo:block>` - Header
- `<xsl:choose>` blocks checking `Interpretation` values for ✓/✗/! symbols
- `number-columns-spanned` attributes may need adjustment

## Test Plan

1. Regenerate PDFs for all Metals v0.1.0 test fixtures
2. Verify tables have 6 columns instead of 7
3. Verify column widths provide good readability
4. Verify no layout issues with long property names
5. Verify multiValue results still render correctly
