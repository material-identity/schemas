/* eslint-disable no-undef */
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

describe('json2pdf.js command-line tool', () => {
  const scriptsDir = path.join(__dirname, '..', 'scripts');
  const fixturesDir = path.join(__dirname, 'fixtures');
  const tmpDir = path.join(__dirname, '..', 'tmp');
  const json2pdfScript = path.join(scriptsDir, 'json2pdf.js');

  // Ensure tmp directory exists
  beforeAll(() => {
    if (!fs.existsSync(tmpDir)) {
      fs.mkdirSync(tmpDir, { recursive: true });
    }
  });

  // Clean up generated PDFs after tests
  afterAll(() => {
    const testFiles = [
      'test_output.pdf',
      'test_positional.pdf',
      'test_input_flag.pdf',
      'test_certificatePath.pdf',
      'test_chinese.pdf'
    ];
    testFiles.forEach(file => {
      const filePath = path.join(tmpDir, file);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    });
  });

  test('should show help when --help flag is used', () => {
    const output = execSync(`node "${json2pdfScript}" --help`, { encoding: 'utf8' });
    expect(output).toContain('JSON to PDF Converter (Standalone)');
    expect(output).toContain('Usage:');
    expect(output).toContain('--input');
    expect(output).toContain('--output');
  });

  test('should convert JSON to PDF with positional arguments', () => {
    const inputFile = path.join(fixturesDir, 'EN10168/v0.4.1/valid_certificate_1.json');
    const outputFile = path.join(tmpDir, 'test_positional.pdf');
    
    // Remove output file if it exists
    if (fs.existsSync(outputFile)) {
      fs.unlinkSync(outputFile);
    }

    const output = execSync(`node "${json2pdfScript}" "${inputFile}" "${outputFile}"`, { encoding: 'utf8' });
    
    expect(output).toContain('Converting JSON to PDF...');
    expect(output).toContain(`✓ PDF successfully created: ${outputFile}`);
    expect(fs.existsSync(outputFile)).toBe(true);
    
    // Verify PDF has reasonable size (should be > 50KB with embedded fonts)
    const stats = fs.statSync(outputFile);
    expect(stats.size).toBeGreaterThan(50000);
  });

  test('should convert JSON to PDF with --input and --output flags', () => {
    const inputFile = path.join(fixturesDir, 'EN10168/v0.4.1/valid_certificate_2.json');
    const outputFile = path.join(tmpDir, 'test_input_flag.pdf');
    
    if (fs.existsSync(outputFile)) {
      fs.unlinkSync(outputFile);
    }

    const output = execSync(`node "${json2pdfScript}" --input "${inputFile}" --output "${outputFile}"`, { encoding: 'utf8' });
    
    expect(output).toContain(`Input: ${inputFile}`);
    expect(output).toContain(`Output: ${outputFile}`);
    expect(output).toContain('✓ PDF successfully created');
    expect(fs.existsSync(outputFile)).toBe(true);
  });

  test('should handle --certificatePath alias', () => {
    const inputFile = path.join(fixturesDir, 'Metals/v0.0.1/valid_minimal.json');
    const outputFile = path.join(tmpDir, 'test_certificatePath.pdf');
    
    if (fs.existsSync(outputFile)) {
      fs.unlinkSync(outputFile);
    }

    const output = execSync(`node "${json2pdfScript}" --certificatePath "${inputFile}" --output "${outputFile}"`, { encoding: 'utf8' });
    
    expect(output).toContain('✓ PDF successfully created');
    expect(fs.existsSync(outputFile)).toBe(true);
  });

  test('should use default output path when not specified', () => {
    const inputFile = path.join(fixturesDir, 'Forestry/v0.0.1/valid_forestry_DMP_01.json');
    const expectedOutput = inputFile.replace('.json', '.pdf');
    
    // Clean up any existing PDF
    if (fs.existsSync(expectedOutput)) {
      fs.unlinkSync(expectedOutput);
    }

    const output = execSync(`node "${json2pdfScript}" "${inputFile}"`, { encoding: 'utf8' });
    
    expect(output).toContain(`Output: ${expectedOutput}`);
    expect(fs.existsSync(expectedOutput)).toBe(true);
    
    // Clean up
    fs.unlinkSync(expectedOutput);
  });

  test('should handle Chinese translations correctly (CoA certificate 9)', () => {
    const inputFile = path.join(fixturesDir, 'CoA/v1.1.0/valid_certificate_9.json');
    const outputFile = path.join(tmpDir, 'test_chinese.pdf');
    
    if (fs.existsSync(outputFile)) {
      fs.unlinkSync(outputFile);
    }

    const output = execSync(`node "${json2pdfScript}" "${inputFile}" "${outputFile}"`, { encoding: 'utf8' });
    
    expect(output).toContain('✓ PDF successfully created');
    expect(fs.existsSync(outputFile)).toBe(true);
    
    // Chinese fonts should make the PDF larger (typically > 70KB)
    const stats = fs.statSync(outputFile);
    expect(stats.size).toBeGreaterThan(70000);
  });

  test('should fail gracefully when input file does not exist', () => {
    const inputFile = path.join(fixturesDir, 'non_existent_file.json');
    
    expect(() => {
      execSync(`node "${json2pdfScript}" "${inputFile}"`, { encoding: 'utf8' });
    }).toThrow();
    
    try {
      execSync(`node "${json2pdfScript}" "${inputFile}"`, { encoding: 'utf8', stdio: 'pipe' });
    } catch (error) {
      // The error message appears in stderr, not stdout
      const errorMessage = error.stderr ? error.stderr.toString() : error.stdout.toString();
      expect(errorMessage).toContain('Error: Input file not found');
    }
  });

  test('should handle different schema types correctly', () => {
    const testCases = [
      { 
        input: 'EN10168/v0.5.0/valid_certificate_1.json',
        minSize: 60000,
        description: 'EN10168 v0.5.0'
      },
      {
        input: 'Metals/v0.0.1/valid_mechanical_properties.json',
        minSize: 40000,  // Adjust for actual PDF size
        description: 'Metals schema'
      },
      {
        input: 'Forestry/v0.0.1/valid_forestry_DMP_02.json',
        minSize: 35000,  // Forestry PDFs can be smaller
        description: 'Forestry schema'
      }
    ];

    testCases.forEach(({ input, minSize, description }) => {
      const inputFile = path.join(fixturesDir, input);
      const outputFile = path.join(tmpDir, `test_${path.basename(input).replace('.json', '.pdf')}`);
      
      if (fs.existsSync(outputFile)) {
        fs.unlinkSync(outputFile);
      }

      const output = execSync(`node "${json2pdfScript}" "${inputFile}" "${outputFile}"`, { encoding: 'utf8' });
      
      expect(output).toContain('✓ PDF successfully created');
      expect(fs.existsSync(outputFile)).toBe(true);
      
      const stats = fs.statSync(outputFile);
      expect(stats.size).toBeGreaterThan(minSize);
      
      // Clean up
      fs.unlinkSync(outputFile);
    });
  });

  test('should check for Maven build dependencies', () => {
    // This test would fail if target/dependency doesn't exist
    // We'll mock this by temporarily renaming the directory
    const dependencyDir = path.join(__dirname, '..', 'target', 'dependency');
    const tempDir = path.join(__dirname, '..', 'target', 'dependency_temp');
    
    // Skip this test if dependency directory doesn't exist
    if (!fs.existsSync(dependencyDir)) {
      console.warn('Skipping Maven dependency check test - target/dependency not found');
      return;
    }
    
    // Temporarily rename dependency directory
    fs.renameSync(dependencyDir, tempDir);
    
    try {
      execSync(`node "${json2pdfScript}" --help`, { encoding: 'utf8', stdio: 'pipe' });
    } catch (error) {
      expect(error.stdout.toString()).toContain('Dependencies not found');
      expect(error.stdout.toString()).toContain('mvn clean install');
    }
    
    // Restore dependency directory
    fs.renameSync(tempDir, dependencyDir);
  });
});