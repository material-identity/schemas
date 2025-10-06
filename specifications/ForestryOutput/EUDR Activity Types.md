# EUDR Activity Types

## 1. Import
When to use: Relevant products enter the EU and are declared for release for free circulation at customs. The importer is the operator. bmcertification.com
Key data & mechanics
* Place of Activity: Country of entry into the EU. bmcertification.com
* Customs link: Your DDS Reference Number goes into the customs declaration (TARIC document section). You also get a Verification Number you can pass downstream. bmcertification.com
* Quantities: Net mass (kg) is mandatory for Import (and Export). bmcertification.com
* Geolocation: Plot-level geolocation for the production place(s) is required unless you legitimately reference a previous DDS that already contains the geolocation (e.g., from an upstream operator). bmcertification.com
* Regulatory backdrop: EUDR applies to imports; non-compliant products cannot be placed on the EU market. EnvironmentEUR-Lex
  
## 2. Export
When to use: Relevant products leave the EU and are declared for export at customs. The exporter is the operator. bmcertification.com
Key data & mechanics
* Place of Activity: Country of exit from the EU. bmcertification.com
* Customs link: You must include the DDS Reference Number in the export declaration. EU-Außenpolitik
* Quantities: Net mass (kg) is mandatory. bmcertification.com
* Geolocation & due diligence: Same logic as Import—plot geolocation and risk assessment sit with the operator submitting the DDS (or reference an upstream DDS that already covers it). bmcertification.com
* Regulatory backdrop: EUDR explicitly covers exports as well as imports. 
  
## 3. Domestic Production
When to use: Goods are produced/manufactured inside the EU and are being placed on the market for the first time. The first placer is the operator (often the EU producer or manufacturer). bmcertification.comcepi.org
Key data & mechanics
* Place of Activity: The EU Member State of production/manufacture. bmcertification.com
* Quantities: If not import/export, at least one measurement is required (e.g., net mass, volume, or supplementary units by HS/CN code). Net mass is not forced here like it is for import/export. bmcertification.com
* Geolocation: Plot-level coordinates of farms/forest stands in the EU must be provided (unless validly referenced from a prior DDS). Special rules allow a single point for cattle establishments and very small plots; polygons or points are acceptable depending on size/context. EU-Außenpolitik
* Regulatory backdrop: “Placing on the market” means first making available on the EU market; that first placer is the operator and bears full due diligence obligations. cepi.org
  
## 4. Trade (intra-EU “making available”)
When to use: You are making products available on the market within the EU after they’ve already been placed—i.e., downstream transactions (distributors, wholesalers, retailers). This is the trader activity in TRACES. bmcertification.comGreen Forum
Key data & mechanics
* Place of Activity: The EU country where goods are made available. bmcertification.com
* Role mapping: In the system, Operators can create Import/Export/Domestic Production DDS; Traders create Trade DDS. bmcertification.com
* Referencing upstream DDS: Traders commonly reference the operator’s DDS by entering the Reference and Verification numbers (manually or via CSV), instead of re-uploading geolocations. Record-keeping duties apply (esp. for non-SME traders). Green Forumtracextech.com

What changes in the form depending on your choice?
* Box 2 — Activity: You pick Import / Export / Domestic Production / Trade. This selection controls later fields. bmcertification.com
* Box 4 — Place of Activity: Autoadapts to your Activity (entry country, exit country, producing Member State, or Member State where you make the goods available). bmcertification.com
Commodity section: For Import/Export you must provide net mass (kg); for Domestic/Trade you can provide net mass, volume (m³), or relevant supplementary units per HS/CN. bmcertification.com
Geolocation: Required at production-place level unless you’re not the importer/first producer and you reference an upstream DDS that already includes it. bmcertification.com
Reference & Verification numbers: The system issues a Reference Number (used for customs & market surveillance) and a Verification Number (shared confidentially downstream). Status flows from NEW → DRAFT → SUBMITTED → AVAILABLE; you can amend AVAILABLE DDS; “Referenced Statements” tab appears after you Save. bmcertification.com
Operator vs Trader (why it matters here)
Operator = first placer on the market or exporter; carries full due diligence (risk assessment, mitigation, geolocation). Activities: Import / Export / Domestic Production. cepi.org
Trader = later in the chain; “makes available” products already on the market; mainly references upstream DDS and maintains records. Activity: Trade. Green Forum
Worked example (coffee → roast → distribution)
Importer (Operator) brings green coffee from Brazil into Antwerp → Activity = Import (entry country = Belgium). Adds plot geolocations or references producer’s DDS; puts Reference Number in customs. bmcertification.com
Roaster (Operator) in Germany places roasted coffee on the market for the first time → Activity = Domestic Production (place = Germany). References the importer’s DDS; adds any new production places if applicable. bmcertification.com
Austrian distributor (Trader) sells the roasted packs to retailers in Vienna → Activity = Trade (place = Austria). References the roaster’s DDS (Reference + Verification numbers), keeps records. Green Forum
Practical tips & common pitfalls
Choose the right Activity: Misclassifying Trade as Import (or vice-versa) leads to missing fields (e.g., net mass at Import/Export) and customs issues. bmcertification.com
Always connect geolocations to the right commodity lines; if you’re not first producer/importer, Reference the prior DDS rather than re-collecting data. bmcertification.com
Customs readiness: For Import/Export, make sure your DDS status is AVAILABLE before you file—only then is the Reference Number valid. bmcertification.com
Roles & access: Ensure the user account has the correct Operator or Trader role; it governs which Activities you can submit. bmcertification.com
EnvironmentEnvironment