# Plan - Add EUDR Activity Type to Forestry Output DMP

## Context
  * schemas/Forestry/v0.0.1/schema.json
  * test/fixtures/Forestry
  * all github issues with Label "ForestryOutput"
  * The four TRACES/EUDR activity types
  * Carefully study specifications/ForestryOutput/EUDR Activity Types.md

## Tasks
1. Specify an extension of the Forestry Schema which adds the information to the Forestry Output Schema
2. Present for review
3. If approved create a github issue based on .github/ISSUE_TEMPLATE/format-enhancement-proposal.md
4. Create a new branch
5. Implement the schema extension with an enumeration for the activity types.
6. Create fixtures for it
7. Test the validation of fixtures against the updated schema
8. Add it to git and create a commit without reference to Claude
9.  Update the xsl to add the Activity Type in the section "Digital Materia Passport".