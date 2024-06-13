# Schema Service POC - Node.js + Typescript
## Local Setup

#### Build the docker image
```sh
docker build -t schema-srv-ts .
```

#### Run the container
```sh
docker run -v $(pwd):/usr/src/app -w /usr/src/app schema-srv-ts
```

## Inputs
Inputs are hardcoded. This is just a POC!
The harcoded value are for rendering of CoA/v1.1.0

## Outputs
- ouput.pdf
- output-fo.xml

## Remarks
1. There is no javascript library available with Apache-Fop, so the app executes a child process to execute fop from the cli.
2. The process of attaching the json file to the PDF also has to be achieved with a child process using pdftk
3. SaxonJS expects a .sef.json file which is a wrapper around the xsl stylesheet. The process of converting the xls to .sef.json is done using xslt3 which is a nodejs library, but can only be run through the cli. However, this is a one time conversion, and only has to be performed if the .sef.json does not yet exist.