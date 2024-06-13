import fs, { writeFileSync } from "fs";
import { PathOrFileDescriptor, readFileSync, promises as fsPromises } from "fs";
const { mkdtemp } = fsPromises;
import { Builder } from "xml2js";
import { exec } from "child_process";
import { promisify } from "util";
import * as SaxonJS from "saxon-js";
import path from "path";

const execPromise = promisify(exec);

/**
 * Applies translations to the input JSON.
 * @param {string[]} inputLanguages - The languages to use for translations.
 * @param {object} inputJson - The input JSON object.
 * @returns {object} The JSON object with the Translations field appended.
 */
const applyTranslations = (
  inputLanguages: string[],
  inputJson: any,
  translationsPath: string
): any => {
  try {
    const translations = JSON.parse(readFileSync(translationsPath, "utf-8"));
    const result = { ...inputJson, Translations: { Certificate: {} } };

    Object.keys(translations[inputLanguages[0]].Certificate).forEach((key) => {
      const secondLanguageExists =
        inputLanguages.length > 1 && translations[inputLanguages[1]];

      result.Translations.Certificate[key] = secondLanguageExists
        ? `${translations[inputLanguages[0]].Certificate[key]} / ${
            translations[inputLanguages[1]].Certificate[key]
          }`
        : translations[inputLanguages[0]].Certificate[key];
    });

    return result;
  } catch (error) {
    console.error("Error during translation application:", error);
    throw error;
  }
};

/**
 * Converts JSON to XML.
 * @param {string} jsonPath - The path to the JSON file.
 * @param {string[]} inputLanguages - The languages to use for translations.
 * @returns {string} The converted XML string.
 */
const convertJsonToXml = (
  jsonPath: PathOrFileDescriptor,
  inputLanguages: string[],
  translationsPath: string
): string => {
  try {
    const json = readFileSync(jsonPath, "utf-8");
    const jsonObj = JSON.parse(json);

    const translatedJson = applyTranslations(
      inputLanguages,
      jsonObj,
      translationsPath
    );

    const builder = new Builder({ rootName: "Root" });
    const xmlString = builder.buildObject(translatedJson);

    return xmlString;
  } catch (error) {
    console.error("Error during JSON to XML conversion:", error);
    throw error;
  }
};

/**
 * Transforms XML to XSL-FO using the provided XSLT stylesheet.
 * @param {string} xmlString - The XML string.
 * @param {PathOrFileDescriptor} sefPath - The path to the JSON SEF file.
 * @param {PathOrFileDescriptor} foOutputPath - The path to the output XSL-FO file.
 */
const transformXmlToXslFo = async (
  xmlString: string,
  sefPath: PathOrFileDescriptor,
  foOutputPath: string
): Promise<void> => {
  try {
    const output = await SaxonJS.transform(
      {
        stylesheetLocation: sefPath,
        sourceText: xmlString,
        destination: "serialized",
      },
      "async"
    );
    writeFileSync(foOutputPath, output.principalResult);
    console.log("XSL-FO transformation complete.");
  } catch (error) {
    console.error("Error during XML to XSL-FO transformation:", error);
    throw error;
  }
};

/**
 * Compiles an XSLT file to a JSON SEF file.
 * @param xslPath - The path to the XSLT file.
 * @param sefPath - The path to save the compiled SEF file.
 * @returns A promise that resolves when the compilation is complete.
 */
const compileXSLTToSEF = async (
  xslPath: string,
  sefPath: string
): Promise<void> => {
  if (fs.existsSync(sefPath)) {
    console.log("SEF file already exists. Skipping compilation.");
    return;
  }

  try {
    await execPromise(`npx xslt3 -xsl:${xslPath} -export:${sefPath} -nogo`);
    console.log("XSLT compilation to SEF complete.");
  } catch (error) {
    console.error("Error during XSLT to SEF compilation:", error);
    throw error;
  }
};

/**
 * Generates a PDF from the provided XSL-FO content.
 * @param {PathOrFileDescriptor} foPath - The path to the XSL-FO file.
 * @param {PathLike} pdfOutputPath - The path to the output PDF file.
 * @returns {Promise<void>}
 */
const generatePdfFromFo = async (
  foPath: fs.PathOrFileDescriptor,
  pdfOutputPath: string,
  fopConfigPath: string
): Promise<void> => {
  await execPromise(
    `fop -fo ${foPath} -pdf ${pdfOutputPath} -c ${fopConfigPath}`
  );
};

/**
 * Attaches a file to a PDF using pdftk command.
 * @param {string} pdfPath - The path of the PDF file.
 * @param {string} attachmentPath - The path of the file to be attached.
 * @param {string} outputPath - The path of the output PDF file.
 * @returns {Promise<void>}
 */
const attachFileToPDF = async (
  pdfPath: string,
  attachmentPath: string,
  outputPath: string
): Promise<void> => {
  await execPromise(
    `pdftk ${pdfPath} attach_files ${attachmentPath} output ${outputPath}`
  );
};

/**
 * Chains the generation of a PDF and attaching a file to it.
 * @param {PathOrFileDescriptor} foPath - The path to the XSL-FO file.
 * @param {PathLike} attachmentPath - The path of the file to be attached.
 * @param {PathLike} finalPdfOutputPath - The path of the final output PDF file.
 * @returns {Promise<void>}
 */
const generateAndAttachPdf = async (
  foPath: PathOrFileDescriptor,
  attachmentPath: string,
  finalPdfOutputPath: string,
  fopConfigPath: string,
  attachJson: boolean = false
): Promise<void> => {
  const tempDir = await mkdtemp(path.join(require("os").tmpdir(), "pdf-temp-"));
  const tempPdfPath = path.join(tempDir, "temp.pdf");

  try {
    await generatePdfFromFo(foPath, tempPdfPath, fopConfigPath);

    // TODO: remove fo file after pdf generation

    if (attachJson) {
      await attachFileToPDF(tempPdfPath, attachmentPath, finalPdfOutputPath);
      console.log("PDF generation and attachment complete.");
    } else {
      await execPromise(`mv ${tempPdfPath} ${finalPdfOutputPath}`);
      console.log("PDF generation complete.");
    }
  } catch (error) {
    console.error("Error during PDF generation and attachment:", error);
    throw error;
  } finally {
    // Clean up the temporary directory and file
    await execPromise(`rm -rf ${tempDir}`);
    console.log("Temporary files cleaned up.");
  }
};

// TODO: These should be dynamicically determined according to schema type and version (fetched from "resources" file)
const xslPath = "stylesheet.xsl";
const sefPath = "stylesheet.sef.json";
const jsonPath = "coa-certificate-1.1.0-valid.json";
const translationsPath = "translations.json";

// constants
const foOutputPath = "output-fo.xml";
const fopConfigPath = "fop.xconf";
const outputPdf = "output.pdf";

// user input
const attachJson = true;
const inputLanguages = ["EN", "DE"];

(async () => {
  try {
    const xmlString = convertJsonToXml(
      jsonPath,
      inputLanguages,
      translationsPath
    );
    await compileXSLTToSEF(xslPath, sefPath);
    await transformXmlToXslFo(xmlString, sefPath, foOutputPath);
    await generateAndAttachPdf(
      foOutputPath,
      jsonPath,
      outputPdf,
      fopConfigPath,
      attachJson
    );
  } catch (error) {
    console.error("Unexpected error:", error);
  }
})();
