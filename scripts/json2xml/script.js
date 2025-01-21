import pkg from "jstoxml";
const { toXML } = pkg;
import fs from "fs";
import path from "path";

// Get the JSON file path from command-line arguments
const jsonFilePath = process.argv[2];

if (!jsonFilePath) {
  console.error("Please provide a JSON file path as an argument.");
  process.exit(1);
}

// Read the JSON file
fs.readFile(jsonFilePath, "utf8", (err, data) => {
  if (err) {
    console.error("Error reading the JSON file", err);
    process.exit(1);
  }

  let content;
  try {
    content = JSON.parse(data);
  } catch (parseErr) {
    console.error("Error parsing JSON file", parseErr);
    process.exit(1);
  }

  // Configure the XML output according to the jstoxml documentation (https://github.com/davidcalhoun/jstoxml)
  const config = {
    indent: "    ",
  };

  const xmlOutput = toXML(content, config);

  // Save the XML output to a file
  const outputFilePath =
    path.basename(jsonFilePath, path.extname(jsonFilePath)) + ".xml";
  fs.writeFile(outputFilePath, xmlOutput, (writeErr) => {
    if (writeErr) {
      console.error("Error writing to file", writeErr);
      process.exit(1);
    } else {
      console.log(`File has been saved as ${outputFilePath}`);
    }
  });
});
