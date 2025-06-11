const pkg = require('jstoxml');
const { toXML } = pkg;
const fs = require('fs/promises');
const path = require('path');

// Get the JSON file path from command-line arguments
const jsonFilePath = process.argv[2];

if (!jsonFilePath) {
  console.error('Please provide a JSON file path as an argument.');
  process.exit(1);
}

// Transform arrays to work with jstoxml
function transformArraysForXML(obj, parentKey = '') {
  if (Array.isArray(obj)) {
    // For arrays, we need to wrap each item with its parent's singular form
    const singularKey = parentKey.endsWith('ies') ? 
      parentKey.slice(0, -3) + 'y' : 
      parentKey.endsWith('s') ? 
        parentKey.slice(0, -1) : 
        parentKey;
    
    return obj.map(item => ({
      _name: singularKey || 'item',
      _content: transformArraysForXML(item, singularKey)
    }));
  } else if (obj && typeof obj === 'object') {
    const transformed = {};
    
    for (const [key, value] of Object.entries(obj)) {
      if (Array.isArray(value)) {
        // Special handling for specific array types
        if (key === 'DataPoints' && obj.ResultType === 'structuredArray') {
          // Handle structuredArray DataPoints - create cleaner structure
          transformed[key] = value.map(row => ({
            _name: 'DataPoint',
            _content: Array.isArray(row) ? row.map(cell => ({
              _name: 'Value',
              _content: cell
            })) : row
          }));
        } else if (key === 'Parameters' && obj.ResultType === 'structuredArray') {
          // Handle Parameters for structuredArray - create Parameter elements
          transformed[key] = value.map(param => ({
            _name: 'Parameter',
            _content: param
          }));
        } else if (key === 'ParameterUnits' || key === 'Values' || 
                   key === 'Street' || key === 'AllowedValues') {
          // These arrays should be repeated elements with the same name
          transformed[key] = value;
        } else if (key === 'Parameters') {
          // Handle regular Parameters arrays
          transformed[key] = value;
        } else if (key === 'MechanicalProperties' || key === 'PhysicalProperties' || key === 'SupplementaryTests') {
          // These arrays need special handling - each item should be its own element with the parent name
          transformed[key] = value.map(item => ({
            _name: key.slice(0, -1), // Use the parent name for each item
            _content: transformArraysForXML(item, key)
          }));
        } else {
          // For other arrays, transform them to individual elements
          transformed[key] = transformArraysForXML(value, key);
        }
      } else {
        transformed[key] = transformArraysForXML(value, key);
      }
    }
    
    return transformed;
  }
  
  return obj;
}

async function convertJsonToXml(jsonFilePath) {
  try {
    // Read the JSON file
    const data = await fs.readFile(jsonFilePath, 'utf8');

    let content;
    try {
      content = JSON.parse(data);
    } catch (parseErr) {
      console.error('Error parsing JSON file', parseErr);
      process.exit(1);
    }

    // Transform the content to handle arrays properly
    const transformedContent = transformArraysForXML(content);

    // 'Root' will be the root element as implemented in the transformation to XML
    const wrappedContent = {
      Root: transformedContent  
    };

    // Configure the XML output according to the jstoxml documentation (https://github.com/davidcalhoun/jstoxml)
    const config = {
      indent: '    ',
    };

    let xmlOutput = toXML(wrappedContent, config);

    // Performs three string replacements on the XML text to unescape variables for processing in FO:
    // The /g flag makes the replacement global (all occurrences), not just the first match
    xmlOutput = xmlOutput.replace(/&lt;variable/g, '<variable')
      .replace(/\/&gt;/g, '/>')
      .replace(/&apos;/g, "'");
      
    // Save the XML output to a file
    const outputFilePath = jsonFilePath.replace('.json', '.xml');
    await fs.writeFile(outputFilePath, xmlOutput);
    console.log(`File has been saved as ${outputFilePath}`);
  } catch (err) {
    console.error('Error converting JSON to XML', err);
    process.exit(1);
  }
}

convertJsonToXml(jsonFilePath);
