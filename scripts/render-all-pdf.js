#!/usr/bin/env node

const { readdir, stat, mkdir } = require('fs/promises');
const { join, parse } = require('path');
const { convertJsonToPdf } = require('./json2pdf');

async function findFixtureFiles() {
  const fixturesDir = 'test/fixtures';
  const fixtures = [];

  try {
    const schemaTypes = await readdir(fixturesDir);

    for (const schemaType of schemaTypes) {
      const schemaPath = join(fixturesDir, schemaType);
      const schemaStats = await stat(schemaPath);

      if (schemaStats.isDirectory() && schemaType !== 'LICENSE' && schemaType !== 'E-CoC') {
        const versions = await readdir(schemaPath);

        for (const version of versions) {
          const versionPath = join(schemaPath, version);
          const versionStat = await stat(versionPath);

          if (versionStat.isDirectory()) {
            const files = await readdir(versionPath);

            for (const file of files) {
              if (file.endsWith('.json') &&
                !file.includes('invalid') &&
                !file.includes('missing') &&
                file.includes('valid')) {

                const inputPath = join(versionPath, file);
                const baseName = parse(file).name;
                const outputPath = join('tmp', `${schemaType}_${version}_${baseName}.pdf`);

                fixtures.push({
                  input: inputPath,
                  output: outputPath,
                  schemaType,
                  version,
                  filename: file
                });
              }
            }
          }
        }
      }
    }
  } catch (error) {
    console.error('Error reading fixtures directory:', error.message);
    process.exit(1);
  }

  return fixtures;
}

async function renderAllPdfs() {
  console.log('🔍 Finding fixture files...');

  const fixtures = await findFixtureFiles();
  console.log(`📄 Found ${fixtures.length} fixture files to process\n`);

  // Ensure tmp directory exists
  await mkdir('tmp', { recursive: true }).catch();

  const results = {
    success: [],
    failed: [],
    total: fixtures.length
  };

  for (let i = 0; i < fixtures.length; i++) {
    const fixture = fixtures[i];
    const progress = `[${i + 1}/${fixtures.length}]`;

    try {
      console.log(`${progress} Processing ${fixture.schemaType}/${fixture.version}/${fixture.filename}...`);

      await convertJsonToPdf(fixture.input, fixture.output);

      // Check file size to verify font embedding
      const stats = await stat(fixture.output);
      const sizeKB = Math.round(stats.size / 1024);

      results.success.push({
        ...fixture,
        sizeKB
      });

      console.log(`   ✅ Success: ${fixture.output} (${sizeKB}KB)`);

    } catch (error) {
      results.failed.push({
        ...fixture,
        error: error.message
      });

      console.log(`   ❌ Failed: ${error.message}`);
    }
  }

  // Summary
  console.log('\n📊 Summary:');
  console.log(`   Total files: ${results.total}`);
  console.log(`   Successful: ${results.success.length}`);
  console.log(`   Failed: ${results.failed.length}`);

  if (results.success.length > 0) {
    const sizes = results.success.map(r => r.sizeKB);
    const avgSize = Math.round(sizes.reduce((a, b) => a + b, 0) / sizes.length);
    const minSize = Math.min(...sizes);
    const maxSize = Math.max(...sizes);

    console.log(`\n📏 PDF Sizes (font embedding verification):`);
    console.log(`   Average: ${avgSize}KB`);
    console.log(`   Range: ${minSize}KB - ${maxSize}KB`);
    console.log(`   ${sizes.filter(s => s > 50).length}/${sizes.length} PDFs > 50KB (good font embedding)`);
  }

  if (results.failed.length > 0) {
    console.log('\n❌ Failed files:');
    results.failed.forEach(f => {
      console.log(`   ${f.input}: ${f.error}`);
    });
  }

  console.log(`\n🎯 All generated PDFs are stored in tmp/`);
}

// Handle process termination
process.on('SIGINT', () => {
  console.log('\n⚠️  Process interrupted');
  process.exit(1);
});

process.on('SIGTERM', () => {
  console.log('\n⚠️  Process terminated');
  process.exit(1);
});

// Run if called directly
if (require.main === module) {
  renderAllPdfs().catch((error) => {
    console.error(`💥 Unexpected error: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { renderAllPdfs, findFixtureFiles };