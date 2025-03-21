const fs = require('fs');
const path = require('path');

const distPath = path.join(__dirname, 'ui/dist/ui/browser');
const staticPath = path.join(__dirname, 'src/main/resources/static');

// Empty the static folder
fs.rmSync(staticPath, { recursive: true, force: true });
fs.mkdirSync(staticPath, { recursive: true });

// Copy new build files
fs.cpSync(distPath, staticPath, { recursive: true });

console.log('Copying UI build files completed successfully.');
