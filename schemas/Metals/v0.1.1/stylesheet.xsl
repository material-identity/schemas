<?xml version="1.0" encoding="UTF-8"?>
<!--
  Compact single/two-page rendering of the Digital Material Passport.
  Derived from the standard stylesheet; same input document (Root/DigitalMaterialPassport),
  same helper templates, restructured layout:
    - Status columns render only when at least one row carries an Interpretation
    - MultiValue results (impact) render inline: "v1 / v2 / v3 Unit - Average a - Min x"
    - TestConditions shared by 2+ mechanical items become one footnote under the table
    - Chemical elements render as rows (Symbol|Unit|Min|Max|Actual) in two side-by-side halves
    - Product Information / Material Designations / Shape / Packaging merge into one Product section
    - Limit-less booleans (no Method, no Min/Max, no Unit) render as a checkmark line, not table rows
    - ISO 4967 micro-purity items render as a fine/thick matrix (with fallback to normal rows)
    - Empty cells render empty (no "-" placeholders); measured values incl. 0 always render
  All rules are deterministic on the instance data - no content-specific branches.
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">

  <!-- Main template to process the XML input directly -->
  <xsl:template match="/">
    <fo:root xml:lang="en">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin="1cm">
          <fo:region-body margin="0.25cm" margin-bottom="1.2cm" />
          <fo:region-after extent="1cm" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">
        <!-- Footer: schema link + page number -->
        <fo:static-content flow-name="xsl-region-after">
          <fo:table table-layout="fixed" width="100%" font-size="6.5pt" color="#666666" font-family="NotoSans, NotoSansSC">
            <fo:table-column column-width="85%" />
            <fo:table-column column-width="15%" />
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell>
                  <fo:block>Data schema maintained by
                    <fo:basic-link external-destination="https://materialidentity.org">
                      <fo:inline text-decoration="underline">Material Identity</fo:inline>
                    </fo:basic-link>
                    <xsl:text> - </xsl:text>
                    <fo:basic-link external-destination="{/Root/RefSchemaUrl}">
                      <fo:inline text-decoration="underline">
                        <xsl:value-of select="/Root/RefSchemaUrl" />
                      </fo:inline>
                    </fo:basic-link>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block text-align="right">
                    <fo:page-number />
                    <xsl:text> / </xsl:text>
                    <fo:page-number-citation-last ref-id="last-page" />
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:static-content>

        <!-- Body -->
        <fo:flow flow-name="xsl-region-body" font-family="NotoSans, NotoSansSC">
          <!-- Global variables -->
          <xsl:variable name="kvPaddingBottom" select="'1.5pt'" />
          <xsl:variable name="dmp" select="Root/DigitalMaterialPassport" />

          <fo:block font-size="7.5pt">

            <!-- Header: title left, identity right -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="45%" />
              <fo:table-column column-width="55%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <xsl:if test="$dmp/TransactionData/Parties/Manufacturer/Logo">
                      <fo:block padding-bottom="4pt">
                        <fo:external-graphic fox:alt-text="Company Logo" src="{$dmp/TransactionData/Parties/Manufacturer/Logo}" content-height="36px" height="36px" />
                      </fo:block>
                    </xsl:if>
                    <fo:block font-size="13pt" font-weight="bold">Digital Material Passport</fo:block>
                  </fo:table-cell>
                  <fo:table-cell display-align="after">
                    <fo:block text-align="right">
                      <fo:inline font-style="italic">ID </fo:inline>
                      <fo:inline font-weight="bold"><xsl:value-of select="$dmp/Id" /></fo:inline>
                      <xsl:text> - </xsl:text>
                      <fo:inline font-style="italic">Version </fo:inline>
                      <fo:inline font-weight="bold"><xsl:value-of select="$dmp/Version" /></fo:inline>
                    </fo:block>
                    <fo:block text-align="right">
                      <fo:inline font-style="italic">Issue Date </fo:inline>
                      <fo:inline font-weight="bold"><xsl:value-of select="$dmp/IssueDate" /></fo:inline>
                      <xsl:text> - </xsl:text>
                      <fo:inline font-style="italic">Certificate Type </fo:inline>
                      <fo:inline font-weight="bold">
                        <xsl:value-of select="concat($dmp/Validation/CertificateType/Standard, ' ', $dmp/Validation/CertificateType/Type)" />
                      </fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- Parties + Business Transaction band -->
            <fo:table table-layout="fixed" width="100%" space-before="6pt" border-top="0.8pt solid #2b4a6f">
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="40%" />
              <fo:table-body>
                <fo:table-row border-bottom="0.4pt solid #bfbfbf">
                  <fo:table-cell padding="2pt">
                    <fo:block font-weight="bold" font-size="7pt" color="#555555">Manufacturer</fo:block>
                  </fo:table-cell>
                  <fo:table-cell padding="2pt">
                    <fo:block font-weight="bold" font-size="7pt" color="#555555">Customer</fo:block>
                  </fo:table-cell>
                  <fo:table-cell padding="2pt">
                    <fo:block font-weight="bold" font-size="7pt" color="#555555">Business Transaction</fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="PartyInfoCompact">
                    <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Manufacturer" />
                  </xsl:call-template>
                  <xsl:call-template name="PartyInfoCompact">
                    <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Customer" />
                  </xsl:call-template>
                  <fo:table-cell padding="2pt">
                    <xsl:call-template name="BusinessTransactionGrid">
                      <xsl:with-param name="dmp" select="$dmp" />
                    </xsl:call-template>
                  </fo:table-cell>
                </fo:table-row>
                <!-- Additional parties (Subcustomer / Goods Receiver / Certificate Receiver) -->
                <xsl:if test="$dmp/TransactionData/Parties/Subcustomer or $dmp/TransactionData/Parties/GoodsReceiver or $dmp/TransactionData/Parties/CertificateReceiver">
                  <fo:table-row>
                    <xsl:for-each select="$dmp/TransactionData/Parties/Subcustomer | $dmp/TransactionData/Parties/GoodsReceiver | $dmp/TransactionData/Parties/CertificateReceiver">
                      <fo:table-cell padding="2pt" padding-top="4pt">
                        <fo:block font-weight="bold" font-size="7pt" color="#555555">
                          <xsl:choose>
                            <xsl:when test="name() = 'Subcustomer'">Subcustomer</xsl:when>
                            <xsl:when test="name() = 'GoodsReceiver'">Goods Receiver</xsl:when>
                            <xsl:otherwise>Certificate Receiver</xsl:otherwise>
                          </xsl:choose>
                        </fo:block>
                        <fo:block font-weight="bold"><xsl:value-of select="Name" /></fo:block>
                        <xsl:call-template name="FormatAddress">
                          <xsl:with-param name="party" select="." />
                        </xsl:call-template>
                        <xsl:if test="Email">
                          <fo:block>
                            <fo:basic-link external-destination="{concat('mailto:', Email)}">
                              <fo:inline text-decoration="underline"><xsl:value-of select="Email" /></fo:inline>
                            </fo:basic-link>
                          </fo:block>
                        </xsl:if>
                      </fo:table-cell>
                    </xsl:for-each>
                    <xsl:if test="count($dmp/TransactionData/Parties/Subcustomer | $dmp/TransactionData/Parties/GoodsReceiver | $dmp/TransactionData/Parties/CertificateReceiver) lt 3">
                      <fo:table-cell number-columns-spanned="{3 - count($dmp/TransactionData/Parties/Subcustomer | $dmp/TransactionData/Parties/GoodsReceiver | $dmp/TransactionData/Parties/CertificateReceiver)}">
                        <fo:block />
                      </fo:table-cell>
                    </xsl:if>
                  </fo:table-row>
                </xsl:if>
              </fo:table-body>
            </fo:table>

            <!-- Product (merged: Product Information + Material Designations + Shape + Packaging and Marking) -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Product'" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="52%" />
              <fo:table-column column-width="48%" />
              <fo:table-body>
                <fo:table-row>
                  <!-- Left column -->
                  <fo:table-cell padding-right="8pt">
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="34%" />
                      <fo:table-column column-width="66%" />
                      <fo:table-body>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="'Product Name'" />
                            <xsl:with-param name="value" select="$dmp/Product/Name" />
                            <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="'Batch ID'" />
                            <xsl:with-param name="value" select="$dmp/Product/BatchId" />
                            <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <xsl:if test="$dmp/Product/ToolingId">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Tooling ID'" />
                              <xsl:with-param name="value" select="$dmp/Product/ToolingId" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/SurfaceCondition">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Surface Condition'" />
                              <xsl:with-param name="value" select="$dmp/Product/SurfaceCondition" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/DeliveryCondition/Code">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Delivery Condition'" />
                              <xsl:with-param name="value" select="concat($dmp/Product/DeliveryCondition/Code, if($dmp/Product/DeliveryCondition/Description) then concat(' - ', $dmp/Product/DeliveryCondition/Description) else '')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/Weight">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Weight'" />
                              <xsl:with-param name="value" select="concat($dmp/Product/Weight, ' ', if ($dmp/Product/WeightUnit) then $dmp/Product/WeightUnit else 'kg')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/ProductionDate">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Production Date'" />
                              <xsl:with-param name="value" select="$dmp/Product/ProductionDate" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/CountryOfOrigin">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Country of Origin'" />
                              <xsl:with-param name="value" select="$dmp/Product/CountryOfOrigin" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/DimensionalTolerances/Standard">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Tolerance Standard'" />
                              <xsl:with-param name="value" select="$dmp/Product/DimensionalTolerances/Standard" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:for-each select="$dmp/Product/DimensionalTolerances/Tolerances/*">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="concat(replace(name(), '([a-z])([A-Z])', '$1 $2'), ' Tolerance')" />
                              <xsl:with-param name="value" select="string-join((
                                if (UpperDeviation) then concat(
                                  if (number(UpperDeviation) &gt;= 0) then concat('+', UpperDeviation) else string(UpperDeviation),
                                  '/',
                                  if (number(LowerDeviation) &gt; 0) then concat('+', LowerDeviation) else if (number(LowerDeviation) = 0) then '-0' else string(LowerDeviation),
                                  ' ',
                                  if (Unit) then Unit else 'mm'
                                ) else (),
                                if (ToleranceClass) then string(ToleranceClass) else (),
                                if (OutOfRoundnessMax) then concat('out-of-roundness max ', OutOfRoundnessMax, ' ', if (Unit) then Unit else 'mm') else (),
                                if (Standard) then concat('per ', Standard) else ()
                              ), ', ')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:for-each>
                        <xsl:if test="$dmp/Product/SpecificationReference">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Specification'" />
                              <xsl:with-param name="value" select="string-join((
                                $dmp/Product/SpecificationReference/Name,
                                if ($dmp/Product/SpecificationReference/Revision) then concat('Rev ', $dmp/Product/SpecificationReference/Revision) else (),
                                $dmp/Product/SpecificationReference/RevisionDate
                              ), ' - ')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                  <!-- Right column -->
                  <fo:table-cell>
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="36%" />
                      <fo:table-column column-width="64%" />
                      <fo:table-body>
                        <xsl:for-each select="$dmp/Product/MaterialDesignations">
                          <xsl:if test="Name">
                            <fo:table-row>
                              <xsl:call-template name="KeyValue">
                                <xsl:with-param name="key" select="concat('Name', if(Name/System) then concat(' (', Name/System, ')') else '')" />
                                <xsl:with-param name="value" select="Name/Value" />
                                <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                              </xsl:call-template>
                            </fo:table-row>
                          </xsl:if>
                          <xsl:if test="Number">
                            <fo:table-row>
                              <xsl:call-template name="KeyValue">
                                <xsl:with-param name="key" select="concat('Number', if(Number/System) then concat(' (', Number/System, ')') else '')" />
                                <xsl:with-param name="value" select="Number/Value" />
                                <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                              </xsl:call-template>
                            </fo:table-row>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$dmp/Product/Shape">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Shape'" />
                              <xsl:with-param name="value" select="string-join((
                                $dmp/Product/Shape/Form,
                                if ($dmp/Product/Shape/Diameter) then concat('D ', $dmp/Product/Shape/Diameter, ' ', $dmp/Product/Shape/Unit) else (),
                                if ($dmp/Product/Shape/Width) then concat('Width ', $dmp/Product/Shape/Width, ' ', $dmp/Product/Shape/Unit) else (),
                                if ($dmp/Product/Shape/Thickness) then concat('Thickness ', $dmp/Product/Shape/Thickness, ' ', $dmp/Product/Shape/Unit) else (),
                                if ($dmp/Product/Shape/Height) then concat('Height ', $dmp/Product/Shape/Height, ' ', $dmp/Product/Shape/Unit) else (),
                                if ($dmp/Product/Shape/Length) then concat('Length ', $dmp/Product/Shape/Length, ' ', $dmp/Product/Shape/Unit) else (),
                                if ($dmp/Product/Shape/MassPerLength) then concat($dmp/Product/Shape/MassPerLength, ' ', if($dmp/Product/Shape/MassPerLengthUnit) then $dmp/Product/Shape/MassPerLengthUnit else 'kg/m') else ()
                              ), ' - ')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/PackagingAndMarking/Marking">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Marking'" />
                              <xsl:with-param name="value" select="$dmp/Product/PackagingAndMarking/Marking" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/PackagingAndMarking/Packaging">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Packaging'" />
                              <xsl:with-param name="value" select="$dmp/Product/PackagingAndMarking/Packaging" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/PackagingAndMarking/Coloring">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Coloring'" />
                              <xsl:with-param name="value" select="$dmp/Product/PackagingAndMarking/Coloring" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/Product/PackagingAndMarking/SpecialInstructions">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Special Instructions'" />
                              <xsl:with-param name="value" select="$dmp/Product/PackagingAndMarking/SpecialInstructions" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:for-each select="$dmp/Product/ProductNorms">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Product Norm'" />
                              <xsl:with-param name="value" select="concat(Standard, if(Year) then concat(' (', Year, ')') else '', if(ToleranceClass) then concat(', class ', ToleranceClass) else '')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:for-each>
                        <xsl:if test="$dmp/Product/CustomsClassification">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'HS Code'" />
                              <xsl:with-param name="value" select="concat($dmp/Product/CustomsClassification/HSCode, if($dmp/Product/CustomsClassification/StandardDescription) then concat(' - ', $dmp/Product/CustomsClassification/StandardDescription) else '')" />
                              <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                          <xsl:for-each select="$dmp/Product/CustomsClassification/RegionalCodes">
                            <fo:table-row>
                              <xsl:call-template name="KeyValue">
                                <xsl:with-param name="key" select="concat(System, ' (', Region, ')')" />
                                <xsl:with-param name="value" select="concat(Code, if(Description) then concat(' - ', Description) else '')" />
                                <xsl:with-param name="paddingBottom" select="$kvPaddingBottom" />
                              </xsl:call-template>
                            </fo:table-row>
                          </xsl:for-each>
                        </xsl:if>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- Heat Treatment (unchanged from standard layout) -->
            <xsl:if test="$dmp/HeatTreatment">
              <fo:block keep-together="always">
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Heat Treatment'" />
                </xsl:call-template>
                <fo:block>
                  <fo:inline font-style="italic">Process: </fo:inline>
                  <fo:inline font-weight="bold"><xsl:value-of select="$dmp/HeatTreatment/Process" /></fo:inline>
                  <xsl:if test="$dmp/HeatTreatment/HeatTreatmentLot">
                    <xsl:text> - </xsl:text>
                    <fo:inline font-style="italic">Lot: </fo:inline>
                    <xsl:value-of select="$dmp/HeatTreatment/HeatTreatmentLot" />
                  </xsl:if>
                  <xsl:if test="$dmp/HeatTreatment/FurnaceId">
                    <xsl:text> - </xsl:text>
                    <fo:inline font-style="italic">Furnace: </fo:inline>
                    <xsl:value-of select="$dmp/HeatTreatment/FurnaceId" />
                  </xsl:if>
                  <xsl:if test="$dmp/HeatTreatment/ProcessDate">
                    <xsl:text> - </xsl:text>
                    <fo:inline font-style="italic">Date: </fo:inline>
                    <xsl:value-of select="$dmp/HeatTreatment/ProcessDate" />
                  </xsl:if>
                </fo:block>
                <xsl:if test="$dmp/HeatTreatment/Stages">
                  <fo:table table-layout="fixed" width="100%" space-before="3pt">
                    <fo:table-column column-width="20%" />
                    <fo:table-column column-width="20%" />
                    <fo:table-column column-width="15%" />
                    <fo:table-column column-width="20%" />
                    <fo:table-column column-width="25%" />
                    <fo:table-body>
                      <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell padding="2pt"><fo:block font-style="italic" font-weight="bold">Stage</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Temperature</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Duration</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Cooling</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Atmosphere</fo:block></fo:table-cell>
                      </fo:table-row>
                      <xsl:for-each select="$dmp/HeatTreatment/Stages">
                        <fo:table-row>
                          <fo:table-cell padding="2pt"><fo:block><xsl:value-of select="StageType" /></fo:block></fo:table-cell>
                          <fo:table-cell padding="2pt">
                            <fo:block>
                              <xsl:value-of select="Temperature" />
                              <xsl:text> </xsl:text>
                              <xsl:value-of select="TemperatureUnit" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt">
                            <fo:block>
                              <xsl:if test="Duration">
                                <xsl:value-of select="Duration" />
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="DurationUnit" />
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt">
                            <fo:block><xsl:if test="CoolingMedium"><xsl:value-of select="CoolingMedium" /></xsl:if></fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt">
                            <fo:block><xsl:if test="AtmosphereType"><xsl:value-of select="AtmosphereType" /></xsl:if></fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
              </fo:block>
            </xsl:if>

            <!-- Chemical Analysis: heat info inline, elements as rows in two side-by-side halves -->
            <xsl:if test="$dmp/ChemicalAnalysis">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="'Chemical Analysis'" />
              </xsl:call-template>
              <fo:block space-after="3pt">
                <fo:inline font-style="italic">Heat Number </fo:inline>
                <fo:inline font-weight="bold"><xsl:value-of select="$dmp/ChemicalAnalysis/HeatNumber" /></fo:inline>
                <xsl:if test="$dmp/ChemicalAnalysis/MeltingProcess">
                  <xsl:text> - </xsl:text>
                  <fo:inline font-style="italic">Melting Process </fo:inline>
                  <fo:inline font-weight="bold"><xsl:value-of select="$dmp/ChemicalAnalysis/MeltingProcess" /></fo:inline>
                </xsl:if>
                <xsl:if test="$dmp/ChemicalAnalysis/CastingMethod">
                  <xsl:text> - </xsl:text>
                  <fo:inline font-style="italic">Casting Method </fo:inline>
                  <fo:inline font-weight="bold"><xsl:value-of select="$dmp/ChemicalAnalysis/CastingMethod" /></fo:inline>
                </xsl:if>
                <xsl:if test="$dmp/ChemicalAnalysis/CastingDate">
                  <xsl:text> - </xsl:text>
                  <fo:inline font-style="italic">Casting Date </fo:inline>
                  <fo:inline font-weight="bold"><xsl:value-of select="$dmp/ChemicalAnalysis/CastingDate" /></fo:inline>
                </xsl:if>
                <xsl:if test="$dmp/ChemicalAnalysis/SampleLocation">
                  <xsl:text> - </xsl:text>
                  <fo:inline font-style="italic">Sample Location </fo:inline>
                  <fo:inline font-weight="bold"><xsl:value-of select="$dmp/ChemicalAnalysis/SampleLocation" /></fo:inline>
                </xsl:if>
              </fo:block>

              <xsl:if test="$dmp/ChemicalAnalysis/Elements">
                <xsl:variable name="allElements" select="$dmp/ChemicalAnalysis/Elements" />
                <xsl:variable name="halfCount" select="xs:integer(ceiling(count($allElements) div 2))" as="xs:integer" />
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="49%" />
                  <fo:table-column column-width="2%" />
                  <fo:table-column column-width="49%" />
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <xsl:call-template name="RenderChemicalElementsColumn">
                          <xsl:with-param name="elements" select="subsequence($allElements, 1, $halfCount)" />
                        </xsl:call-template>
                      </fo:table-cell>
                      <fo:table-cell><fo:block /></fo:table-cell>
                      <fo:table-cell>
                        <xsl:if test="count($allElements) gt $halfCount">
                          <xsl:call-template name="RenderChemicalElementsColumn">
                            <xsl:with-param name="elements" select="subsequence($allElements, $halfCount + 1)" />
                          </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="count($allElements) le $halfCount"><fo:block /></xsl:if>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <!-- Formula Definitions as a footnote line -->
                <xsl:if test="$dmp/ChemicalAnalysis/Elements/Formula">
                  <fo:block space-before="2pt" font-size="6.5pt" color="#555555">
                    <xsl:for-each select="$dmp/ChemicalAnalysis/Elements[Formula][not(PropertySymbol = preceding-sibling::*/PropertySymbol)]">
                      <xsl:if test="position() gt 1"><xsl:text>   </xsl:text></xsl:if>
                      <fo:inline font-weight="bold"><xsl:value-of select="PropertySymbol" /></fo:inline>
                      <xsl:text> = </xsl:text>
                      <xsl:value-of select="Formula" />
                      <xsl:if test="Actual">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="Actual/Value" />
                        <xsl:if test="Unit"><xsl:value-of select="Unit" /></xsl:if>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:block>
                </xsl:if>
              </xsl:if>
            </xsl:if>

            <!-- Mechanical Properties -->
            <xsl:if test="$dmp/MechanicalProperties">
              <xsl:variable name="mechItems" select="$dmp/MechanicalProperties" />
              <xsl:variable name="mechHasStatus" select="exists($mechItems[Interpretation])" as="xs:boolean" />
              <xsl:variable name="mechHasSymbol" select="exists($mechItems[PropertySymbol])" as="xs:boolean" />
              <xsl:variable name="allTC" select="$mechItems/TestConditions" />
              <xsl:variable name="sharedTC" as="xs:string*"
                select="distinct-values(for $t in distinct-values($allTC) return if (count($allTC[. eq $t]) ge 2) then $t else ())" />
              <fo:block>
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Mechanical Properties'" />
                </xsl:call-template>
                <fo:table id="mechanical-properties-table" table-layout="fixed" width="100%">
                  <fo:table-column column-width="{if ($mechHasSymbol) then '28%' else '36%'}" />
                  <xsl:if test="$mechHasSymbol">
                    <fo:table-column column-width="8%" />
                  </xsl:if>
                  <fo:table-column column-width="17%" />
                  <fo:table-column column-width="12%" />
                  <fo:table-column column-width="12%" />
                  <fo:table-column column-width="{if ($mechHasStatus) then '18%' else '23%'}" />
                  <xsl:if test="$mechHasStatus">
                    <fo:table-column column-width="5%" />
                  </xsl:if>
                  <fo:table-body>
                    <fo:table-row background-color="#f0f0f0">
                      <fo:table-cell padding="2pt"><fo:block font-style="italic" font-weight="bold">Property</fo:block></fo:table-cell>
                      <xsl:if test="$mechHasSymbol">
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Symbol</fo:block></fo:table-cell>
                      </xsl:if>
                      <fo:table-cell padding="2pt"><fo:block font-style="italic">Actual</fo:block></fo:table-cell>
                      <fo:table-cell padding="2pt"><fo:block font-style="italic">Minimum</fo:block></fo:table-cell>
                      <fo:table-cell padding="2pt"><fo:block font-style="italic">Maximum</fo:block></fo:table-cell>
                      <fo:table-cell padding="2pt"><fo:block font-style="italic">Method</fo:block></fo:table-cell>
                      <xsl:if test="$mechHasStatus">
                        <fo:table-cell padding="2pt"><fo:block font-style="italic" text-align="center">Status</fo:block></fo:table-cell>
                      </xsl:if>
                    </fo:table-row>

                    <xsl:for-each select="$mechItems">
                      <xsl:variable name="isSpanning" select="Actual/ResultType = 'array'" as="xs:boolean" />
                      <fo:table-row keep-together.within-page="always">
                        <xsl:if test="$isSpanning">
                          <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
                        </xsl:if>
                        <!-- Property cell (spans value columns for array results) -->
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <xsl:if test="$isSpanning">
                            <xsl:attribute name="number-columns-spanned">
                              <xsl:value-of select="4 + (if ($mechHasSymbol) then 1 else 0)" />
                            </xsl:attribute>
                          </xsl:if>
                          <fo:block font-weight="bold">
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="PropertyName" />
                            </xsl:call-template>
                            <xsl:if test="TestConditions and (TestConditions = $sharedTC)">
                              <fo:inline font-size="5pt" baseline-shift="super">
                                <xsl:value-of select="index-of($sharedTC, TestConditions)" />
                              </fo:inline>
                            </xsl:if>
                          </fo:block>
                          <xsl:if test="TestConditions and not(TestConditions = $sharedTC)">
                            <fo:block font-size="6.5pt" color="#4A4A4A">
                              <xsl:value-of select="TestConditions" />
                            </fo:block>
                          </xsl:if>
                          <xsl:if test="SpecimenSpecification">
                            <xsl:call-template name="FormatSpecimenSpecification">
                              <xsl:with-param name="specimen" select="SpecimenSpecification" />
                            </xsl:call-template>
                          </xsl:if>
                        </fo:table-cell>
                        <xsl:if test="not($isSpanning)">
                          <xsl:if test="$mechHasSymbol">
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block>
                                <xsl:call-template name="AddWordWrapBreaks">
                                  <xsl:with-param name="text" select="PropertySymbol" />
                                </xsl:call-template>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Actual" />
                              </xsl:call-template>
                              <xsl:if test="Unit and not(Actual/ResultType = 'multiValue')">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="Unit" />
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:if test="Minimum">
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Minimum" />
                                </xsl:call-template>
                                <xsl:if test="Unit">
                                  <xsl:text> </xsl:text>
                                  <xsl:value-of select="Unit" />
                                </xsl:if>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:if test="Maximum">
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Maximum" />
                                </xsl:call-template>
                                <xsl:if test="Unit">
                                  <xsl:text> </xsl:text>
                                  <xsl:value-of select="Unit" />
                                </xsl:if>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:if>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="Method" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <xsl:if test="$mechHasStatus">
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block text-align="center">
                              <xsl:call-template name="StatusIcon">
                                <xsl:with-param name="interpretation" select="Interpretation" />
                              </xsl:call-template>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:if>
                      </fo:table-row>
                      <!-- Spanning row for array results -->
                      <xsl:if test="$isSpanning">
                        <fo:table-row keep-together.within-page="always">
                          <fo:table-cell padding="4pt">
                            <xsl:attribute name="number-columns-spanned">
                              <xsl:value-of select="5 + (if ($mechHasSymbol) then 1 else 0) + (if ($mechHasStatus) then 1 else 0)" />
                            </xsl:attribute>
                            <xsl:call-template name="FormatResult">
                              <xsl:with-param name="result" select="Actual" />
                            </xsl:call-template>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
                <!-- Footnotes: TestConditions shared by 2+ items -->
                <xsl:if test="exists($sharedTC)">
                  <fo:block space-before="2pt" font-size="6.5pt" color="#555555">
                    <xsl:for-each select="$sharedTC">
                      <xsl:if test="position() gt 1"><xsl:text>   </xsl:text></xsl:if>
                      <fo:inline font-size="5pt" baseline-shift="super"><xsl:value-of select="position()" /></fo:inline>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="." />
                    </xsl:for-each>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </xsl:if>

            <!-- Physical Properties -->
            <xsl:if test="$dmp/PhysicalProperties">
              <!-- ISO 4967 micro-purity items render as a fine/thick matrix when they follow the
                   standard naming pattern; any nonconforming set falls back to normal table rows. -->
              <xsl:variable name="purityItems" select="$dmp/PhysicalProperties[Method = 'ISO 4967']" />
              <xsl:variable name="purityMatrixOk" as="xs:boolean"
                select="exists($purityItems) and (every $p in $purityItems satisfies matches($p/PropertyName, '^[ABCD] \((fine|thick)\)$|^DS$'))" />
              <xsl:variable name="checklistItems" select="$dmp/PhysicalProperties[Actual/ResultType = 'boolean' and not(Method) and not(Minimum) and not(Maximum) and not(Unit) and not(TestConditions)]" />
              <xsl:variable name="tableItems" select="$dmp/PhysicalProperties except ((if ($purityMatrixOk) then $purityItems else ()) | $checklistItems)" />
              <xsl:variable name="physHasStatus" select="exists($dmp/PhysicalProperties[Interpretation])" as="xs:boolean" />
              <xsl:variable name="physHasSymbol" select="exists($tableItems[PropertySymbol])" as="xs:boolean" />

              <fo:block keep-together="always">
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Physical Properties'" />
                </xsl:call-template>

                <xsl:if test="exists($tableItems)">
                  <fo:table id="physical-properties-table" table-layout="fixed" width="100%">
                    <fo:table-column column-width="{if ($physHasSymbol) then '28%' else '36%'}" />
                    <xsl:if test="$physHasSymbol">
                      <fo:table-column column-width="8%" />
                    </xsl:if>
                    <fo:table-column column-width="17%" />
                    <fo:table-column column-width="12%" />
                    <fo:table-column column-width="12%" />
                    <fo:table-column column-width="{if ($physHasStatus) then '18%' else '23%'}" />
                    <xsl:if test="$physHasStatus">
                      <fo:table-column column-width="5%" />
                    </xsl:if>
                    <fo:table-body>
                      <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell padding="2pt"><fo:block font-style="italic" font-weight="bold">Property</fo:block></fo:table-cell>
                        <xsl:if test="$physHasSymbol">
                          <fo:table-cell padding="2pt"><fo:block font-style="italic">Symbol</fo:block></fo:table-cell>
                        </xsl:if>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Actual</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Target/Min</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Maximum</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Method</fo:block></fo:table-cell>
                        <xsl:if test="$physHasStatus">
                          <fo:table-cell padding="2pt"><fo:block font-style="italic" text-align="center">Status</fo:block></fo:table-cell>
                        </xsl:if>
                      </fo:table-row>
                      <xsl:for-each select="$tableItems">
                        <xsl:variable name="isSpanning" select="Actual/ResultType = 'array'" as="xs:boolean" />
                        <fo:table-row keep-together.within-page="always">
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <xsl:if test="$isSpanning">
                              <xsl:attribute name="number-columns-spanned">
                                <xsl:value-of select="4 + (if ($physHasSymbol) then 1 else 0)" />
                              </xsl:attribute>
                            </xsl:if>
                            <fo:block font-weight="bold">
                              <xsl:call-template name="AddWordWrapBreaks">
                                <xsl:with-param name="text" select="PropertyName" />
                              </xsl:call-template>
                            </fo:block>
                            <xsl:if test="TestConditions">
                              <fo:block font-size="6.5pt" color="#4A4A4A">
                                <xsl:value-of select="TestConditions" />
                              </fo:block>
                            </xsl:if>
                          </fo:table-cell>
                          <xsl:if test="not($isSpanning)">
                            <xsl:if test="$physHasSymbol">
                              <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                                <fo:block>
                                  <xsl:call-template name="AddWordWrapBreaks">
                                    <xsl:with-param name="text" select="PropertySymbol" />
                                  </xsl:call-template>
                                </fo:block>
                              </fo:table-cell>
                            </xsl:if>
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block>
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Actual" />
                                </xsl:call-template>
                                <xsl:if test="Unit and not(Actual/ResultType = 'multiValue')">
                                  <xsl:text> </xsl:text>
                                  <xsl:value-of select="Unit" />
                                </xsl:if>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block>
                                <xsl:choose>
                                  <xsl:when test="Target">
                                    <xsl:call-template name="FormatResult">
                                      <xsl:with-param name="result" select="Target" />
                                    </xsl:call-template>
                                    <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                                  </xsl:when>
                                  <xsl:when test="Minimum">
                                    <xsl:call-template name="FormatResult">
                                      <xsl:with-param name="result" select="Minimum" />
                                    </xsl:call-template>
                                    <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                                  </xsl:when>
                                </xsl:choose>
                              </fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block>
                                <xsl:if test="Maximum">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="Maximum" />
                                  </xsl:call-template>
                                  <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                                </xsl:if>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:call-template name="AddWordWrapBreaks">
                                <xsl:with-param name="text" select="Method" />
                              </xsl:call-template>
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$physHasStatus">
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block text-align="center">
                                <xsl:call-template name="StatusIcon">
                                  <xsl:with-param name="interpretation" select="Interpretation" />
                                </xsl:call-template>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                        </fo:table-row>
                        <xsl:if test="$isSpanning">
                          <fo:table-row keep-together.within-page="always">
                            <fo:table-cell padding="4pt">
                              <xsl:attribute name="number-columns-spanned">
                                <xsl:value-of select="5 + (if ($physHasSymbol) then 1 else 0) + (if ($physHasStatus) then 1 else 0)" />
                              </xsl:attribute>
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Actual" />
                              </xsl:call-template>
                            </fo:table-cell>
                          </fo:table-row>
                        </xsl:if>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>

                <!-- ISO 4967 micro-purity matrix -->
                <xsl:if test="$purityMatrixOk">
                  <xsl:variable name="purityTypes" as="xs:string*"
                    select="for $t in ('A','B','C','D','DS') return
                            if (exists($purityItems[PropertyName = concat($t, ' (fine)') or PropertyName = concat($t, ' (thick)') or PropertyName = $t])) then $t else ()" />
                  <fo:block space-before="4pt" space-after="2pt">
                    <xsl:text>Micro-purity acc. ISO 4967 - actual (max) per type:</xsl:text>
                  </fo:block>
                  <fo:table table-layout="fixed" width="60%">
                    <fo:table-column column-width="16%" />
                    <xsl:for-each select="$purityTypes">
                      <fo:table-column column-width="{floor(84 div count($purityTypes))}%" />
                    </xsl:for-each>
                    <fo:table-body>
                      <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block /></fo:table-cell>
                        <xsl:for-each select="$purityTypes">
                          <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                            <fo:block font-weight="bold" text-align="center"><xsl:value-of select="." /></fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <xsl:for-each select="('fine', 'thick')">
                        <xsl:variable name="series" select="." />
                        <fo:table-row>
                          <fo:table-cell padding="2pt" border="0.5pt solid #ddd" background-color="#f0f0f0">
                            <fo:block font-weight="bold"><xsl:value-of select="$series" /></fo:block>
                          </fo:table-cell>
                          <xsl:for-each select="$purityTypes">
                            <xsl:variable name="type" select="." />
                            <xsl:variable name="item" select="$purityItems[PropertyName = concat($type, ' (', $series, ')') or (PropertyName = $type and $series = 'fine')]" />
                            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                              <fo:block text-align="center">
                                <xsl:choose>
                                  <xsl:when test="$item">
                                    <xsl:value-of select="$item/Actual/Value" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:choose>
                                      <xsl:when test="$item/Maximum"><xsl:value-of select="$item/Maximum/Value" /></xsl:when>
                                      <xsl:otherwise>-</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:text>&#183;</xsl:text>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>

                <!-- Boolean checklist (no method, no limits, no unit) -->
                <xsl:if test="exists($checklistItems)">
                  <fo:block space-before="3pt">
                    <xsl:for-each select="$checklistItems">
                      <xsl:if test="position() gt 1"><xsl:text>    </xsl:text></xsl:if>
                      <xsl:call-template name="ChecklistEntry">
                        <xsl:with-param name="item" select="." />
                      </xsl:call-template>
                    </xsl:for-each>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </xsl:if>

            <!-- Supplementary Tests -->
            <xsl:if test="$dmp/SupplementaryTests">
              <xsl:variable name="suppChecklistItems" select="$dmp/SupplementaryTests[Actual/ResultType = 'boolean' and not(Method) and not(Minimum) and not(Maximum) and not(Unit) and not(TestConditions)]" />
              <xsl:variable name="suppArrayItems" select="$dmp/SupplementaryTests[Actual/ResultType = 'array']" />
              <xsl:variable name="suppTableItems" select="$dmp/SupplementaryTests except ($suppChecklistItems | $suppArrayItems)" />
              <xsl:variable name="suppHasStatus" select="exists($dmp/SupplementaryTests[Interpretation])" as="xs:boolean" />

              <fo:block>
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Supplementary Tests'" />
                </xsl:call-template>

                <xsl:if test="exists($suppTableItems)">
                  <fo:table id="supplementary-tests-table" table-layout="fixed" width="100%">
                    <fo:table-column column-width="24%" />
                    <fo:table-column column-width="{if ($suppHasStatus) then '43%' else '48%'}" />
                    <fo:table-column column-width="28%" />
                    <xsl:if test="$suppHasStatus">
                      <fo:table-column column-width="5%" />
                    </xsl:if>
                    <fo:table-body>
                      <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell padding="2pt"><fo:block font-style="italic" font-weight="bold">Test</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Result / limits</fo:block></fo:table-cell>
                        <fo:table-cell padding="2pt"><fo:block font-style="italic">Method</fo:block></fo:table-cell>
                        <xsl:if test="$suppHasStatus">
                          <fo:table-cell padding="2pt"><fo:block font-style="italic" text-align="center">Status</fo:block></fo:table-cell>
                        </xsl:if>
                      </fo:table-row>
                      <xsl:for-each select="$suppTableItems">
                        <fo:table-row keep-together.within-page="always">
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:call-template name="AddWordWrapBreaks">
                                <xsl:with-param name="text" select="PropertyName" />
                              </xsl:call-template>
                            </fo:block>
                            <xsl:if test="TestConditions">
                              <fo:block font-size="6.5pt" color="#4A4A4A">
                                <xsl:value-of select="TestConditions" />
                              </fo:block>
                            </xsl:if>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:choose>
                                <xsl:when test="Actual/ResultType = 'boolean'">
                                  <xsl:choose>
                                    <xsl:when test="Actual/Value = 'true'">Yes</xsl:when>
                                    <xsl:otherwise>No</xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="Actual/Description">
                                    <xsl:text> - </xsl:text>
                                    <xsl:value-of select="Actual/Description" />
                                  </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="Actual" />
                                  </xsl:call-template>
                                  <xsl:if test="Unit and not(Actual/ResultType = 'multiValue')">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="Unit" />
                                  </xsl:if>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:if test="Target">
                                <xsl:text> - target </xsl:text>
                                <xsl:call-template name="FormatResult"><xsl:with-param name="result" select="Target" /></xsl:call-template>
                                <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                              </xsl:if>
                              <xsl:if test="Minimum">
                                <xsl:text> - min </xsl:text>
                                <xsl:call-template name="FormatResult"><xsl:with-param name="result" select="Minimum" /></xsl:call-template>
                                <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                              </xsl:if>
                              <xsl:if test="Maximum">
                                <xsl:text> - max </xsl:text>
                                <xsl:call-template name="FormatResult"><xsl:with-param name="result" select="Maximum" /></xsl:call-template>
                                <xsl:if test="Unit"><xsl:text> </xsl:text><xsl:value-of select="Unit" /></xsl:if>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                            <fo:block>
                              <xsl:call-template name="AddWordWrapBreaks">
                                <xsl:with-param name="text" select="Method" />
                              </xsl:call-template>
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$suppHasStatus">
                            <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                              <fo:block text-align="center">
                                <xsl:call-template name="StatusIcon">
                                  <xsl:with-param name="interpretation" select="Interpretation" />
                                </xsl:call-template>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>

                <!-- Boolean checklist -->
                <xsl:if test="exists($suppChecklistItems)">
                  <fo:block space-before="3pt">
                    <xsl:for-each select="$suppChecklistItems">
                      <xsl:if test="position() gt 1"><xsl:text>    </xsl:text></xsl:if>
                      <xsl:call-template name="ChecklistEntry">
                        <xsl:with-param name="item" select="." />
                      </xsl:call-template>
                    </xsl:for-each>
                  </fo:block>
                </xsl:if>

                <!-- Array results (e.g. Jominy hardenability) as labelled matrices -->
                <xsl:for-each select="$suppArrayItems">
                  <fo:block space-before="4pt" keep-together.within-page="always">
                    <fo:block space-after="2pt">
                      <fo:inline font-weight="bold"><xsl:value-of select="PropertyName" /></fo:inline>
                      <xsl:if test="Method">
                        <xsl:text> (</xsl:text><xsl:value-of select="Method" /><xsl:text>)</xsl:text>
                      </xsl:if>
                      <xsl:if test="Unit">
                        <xsl:text>, values in </xsl:text><xsl:value-of select="Unit" />
                      </xsl:if>
                      <xsl:if test="TestConditions">
                        <xsl:text> - </xsl:text>
                        <fo:inline font-size="6.5pt" color="#4A4A4A"><xsl:value-of select="TestConditions" /></fo:inline>
                      </xsl:if>
                    </fo:block>
                    <xsl:call-template name="FormatResult">
                      <xsl:with-param name="result" select="Actual" />
                    </xsl:call-template>
                  </fo:block>
                </xsl:for-each>
              </fo:block>
            </xsl:if>

            <!-- Validation -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Validation'" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="62%" />
              <fo:table-column column-width="38%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell padding-right="8pt">
                    <xsl:if test="$dmp/Validation/ValidationStatement/Statement">
                      <fo:block space-after="3pt">
                        <xsl:value-of select="$dmp/Validation/ValidationStatement/Statement" />
                      </fo:block>
                    </xsl:if>
                    <xsl:for-each select="$dmp/Validation/ValidationStatement/IndividualStatements">
                      <fo:block space-after="1.5pt">
                        <xsl:choose>
                          <xsl:when test="Confirmed/Value = 'true' or Confirmed/Value = true()">
                            <fo:inline color="green">&#x2713;</fo:inline>
                          </xsl:when>
                          <xsl:otherwise>
                            <fo:inline color="red">&#x2717;</fo:inline>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="StatementText" />
                        <xsl:if test="RegulatoryReference">
                          <fo:inline font-style="italic" color="#666666">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="RegulatoryReference" />
                            <xsl:text>)</xsl:text>
                          </fo:inline>
                        </xsl:if>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                  <fo:table-cell>
                    <xsl:for-each select="$dmp/Validation/Validators">
                      <fo:block text-align="right" space-after="1.5pt">
                        <fo:block-container position="relative">
                          <xsl:if test="StampImage">
                            <fo:block absolute-position="absolute" top="-5px" right="0px">
                              <fo:external-graphic src="{StampImage}" content-height="40px" scaling="uniform" />
                            </fo:block>
                          </xsl:if>
                          <fo:block>
                            <xsl:text>Validated by </xsl:text>
                            <fo:inline font-weight="bold"><xsl:value-of select="Name" /></fo:inline>
                            <xsl:if test="Title">
                              <xsl:text>, </xsl:text><xsl:value-of select="Title" />
                            </xsl:if>
                            <xsl:if test="Department">
                              <xsl:text>, </xsl:text><xsl:value-of select="Department" />
                            </xsl:if>
                            <xsl:if test="../ValidationDate">
                              <xsl:text> - </xsl:text><xsl:value-of select="../ValidationDate" />
                            </xsl:if>
                          </fo:block>
                        </fo:block-container>
                      </fo:block>
                    </xsl:for-each>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- Used to get the last page number -->
            <fo:block id="last-page" />
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- TEMPLATES -->

  <!-- Renders chemical elements as rows: Symbol | Unit | Min | Max | Actual. Called once per half-column. -->
  <xsl:template name="RenderChemicalElementsColumn">
    <xsl:param name="elements" />
    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="20%" />
      <fo:table-column column-width="18%" />
      <fo:table-column column-width="20%" />
      <fo:table-column column-width="21%" />
      <fo:table-column column-width="21%" />
      <fo:table-body>
        <fo:table-row background-color="#f0f0f0">
          <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block font-style="italic">Symbol</fo:block></fo:table-cell>
          <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block font-style="italic">Unit</fo:block></fo:table-cell>
          <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block font-style="italic">Min</fo:block></fo:table-cell>
          <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block font-style="italic">Max</fo:block></fo:table-cell>
          <fo:table-cell padding="2pt" border="0.5pt solid #ddd"><fo:block font-style="italic">Actual</fo:block></fo:table-cell>
        </fo:table-row>
        <xsl:for-each select="$elements">
          <fo:table-row>
            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
              <fo:block font-weight="bold"><xsl:value-of select="PropertySymbol" /></fo:block>
            </fo:table-cell>
            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
              <fo:block><xsl:value-of select="Unit" /></fo:block>
            </fo:table-cell>
            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
              <fo:block>
                <xsl:if test="Minimum">
                  <xsl:call-template name="FormatResult">
                    <xsl:with-param name="result" select="Minimum" />
                  </xsl:call-template>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
              <fo:block>
                <xsl:if test="Maximum">
                  <xsl:call-template name="FormatResult">
                    <xsl:with-param name="result" select="Maximum" />
                  </xsl:call-template>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
              <fo:block>
                <xsl:if test="Actual">
                  <xsl:call-template name="FormatResult">
                    <xsl:with-param name="result" select="Actual" />
                  </xsl:call-template>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="SectionTitle">
    <xsl:param name="title" />
    <fo:block font-size="9pt" font-weight="bold" color="#2b4a6f" text-align="left" space-before="8pt" space-after="3pt" border-bottom="solid 0.5pt #bfbfbf">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>

  <xsl:template name="SectionTitleSmall">
    <xsl:param name="title" />
    <fo:block font-size="7.5pt" font-weight="bold" text-align="left" space-before="6pt" space-after="3pt">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>

  <xsl:template name="KeyValue">
    <xsl:param name="key" />
    <xsl:param name="value" />
    <xsl:param name="paddingBottom" />
    <fo:table-cell>
      <fo:block padding-bottom="{$paddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic" color="#555555">
        <xsl:value-of select="$key" />
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block padding-bottom="{$paddingBottom}">
        <xsl:value-of select="$value" />
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- Compact party cell: name, address, email (no title - the band header row carries it) -->
  <xsl:template name="PartyInfoCompact">
    <xsl:param name="party" />
    <fo:table-cell padding="2pt">
      <fo:block font-weight="bold">
        <xsl:value-of select="$party/Name" />
      </fo:block>
      <xsl:call-template name="FormatAddress">
        <xsl:with-param name="party" select="$party" />
      </xsl:call-template>
      <xsl:if test="$party/Email">
        <fo:block>
          <fo:basic-link external-destination="{concat('mailto:', $party/Email)}">
            <fo:inline text-decoration="underline">
              <xsl:value-of select="$party/Email" />
            </fo:inline>
          </fo:basic-link>
        </fo:block>
      </xsl:if>
    </fo:table-cell>
  </xsl:template>

  <!-- Business transaction grid: Order / Delivery / Contract as rows, Type
       column sized to its content ("Delivery" is the longest label) rather
       than a percentage, Details column taking the remainder. No header
       row, no borders - reads as plain aligned text like the Party cells
       either side of it. -->
  <xsl:template name="BusinessTransactionGrid">
    <xsl:param name="dmp" />
    <xsl:variable name="bt" select="$dmp/TransactionData/BusinessTransaction" />
    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="18mm" />
      <fo:table-column column-width="proportional-column-width(1)" />
      <fo:table-body>
        <xsl:for-each select="$bt/Order | $bt/Delivery | $bt/Contract">
          <xsl:variable name="label" select="name()" />
          <fo:table-row>
            <fo:table-cell padding="2pt">
              <fo:block font-weight="bold"><xsl:value-of select="$label" /></fo:block>
            </fo:table-cell>
            <fo:table-cell padding="2pt">
              <fo:block>
                <xsl:value-of select="Id" />
                <xsl:if test="Quantity">
                  <xsl:text> &#183; </xsl:text>
                  <fo:inline font-weight="bold"><xsl:value-of select="concat(Quantity, ' ', QuantityUnit)" /></fo:inline>
                </xsl:if>
                <xsl:if test="Description">
                  <xsl:text> &#183; </xsl:text><xsl:value-of select="Description" />
                </xsl:if>
              </fo:block>
              <xsl:if test="Position or Date">
                <fo:block font-size="6.5pt" color="#4A4A4A">
                  <xsl:if test="Position">
                    <xsl:text>Pos. </xsl:text><xsl:value-of select="Position" />
                  </xsl:if>
                  <xsl:if test="Position and Date"><xsl:text> &#183; </xsl:text></xsl:if>
                  <xsl:if test="Date"><xsl:value-of select="Date" /></xsl:if>
                </fo:block>
              </xsl:if>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Status icon for Interpretation values -->
  <xsl:template name="StatusIcon">
    <xsl:param name="interpretation" />
    <xsl:choose>
      <xsl:when test="$interpretation = 'In Specification'">
        <fo:inline color="green">&#x2713;</fo:inline>
      </xsl:when>
      <xsl:when test="$interpretation = 'Out of Specification'">
        <fo:inline color="red">&#x2717;</fo:inline>
      </xsl:when>
      <xsl:when test="$interpretation = 'Conditionally Acceptable'">
        <fo:inline color="orange">!</fo:inline>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

  <!-- Checklist entry for limit-less boolean items: check/cross + description (or property name) -->
  <xsl:template name="ChecklistEntry">
    <xsl:param name="item" />
    <xsl:choose>
      <xsl:when test="$item/Actual/Value = 'true'">
        <fo:inline color="green">&#x2713;</fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline color="red">&#x2717;</fo:inline>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="$item/Actual/Description">
        <xsl:value-of select="$item/Actual/Description" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$item/PropertyName" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$item/TestConditions">
      <fo:inline font-size="6.5pt" color="#4A4A4A">
        <xsl:text> (</xsl:text><xsl:value-of select="$item/TestConditions" /><xsl:text>)</xsl:text>
      </fo:inline>
    </xsl:if>
  </xsl:template>

  <!-- Format the result based on its type -->
  <xsl:template name="FormatResult">
    <xsl:param name="result" />
    <xsl:choose>
      <xsl:when test="$result/ResultType = 'numeric'">
        <xsl:if test="$result/Operator and $result/Operator != '='">
          <xsl:value-of select="$result/Operator" />
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$result/Value" />
        <xsl:if test="$result/Uncertainty">
          <xsl:text> &#177; </xsl:text>
          <xsl:value-of select="$result/Uncertainty" />
        </xsl:if>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'boolean'">
        <xsl:choose>
          <xsl:when test="$result/Value = 'true'">Yes</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$result/Description">
          <fo:block font-size="6.5pt" color="#4A4A4A">
            <xsl:value-of select="$result/Description" />
          </fo:block>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'string'">
        <xsl:value-of select="$result/Value" />
      </xsl:when>
      <xsl:when test="$result/ResultType = 'range'">
        <xsl:value-of select="$result/Minimum" />
        <xsl:text> - </xsl:text>
        <xsl:value-of select="$result/Maximum" />
      </xsl:when>
      <xsl:when test="$result/ResultType = 'multiValue'">
        <!-- Inline: "v1 / v2 / v3 Unit - Average a - Min x" (no sub-tables, no empty statistics) -->
        <xsl:for-each select="$result/Values">
          <xsl:if test="position() gt 1"><xsl:text> / </xsl:text></xsl:if>
          <xsl:call-template name="FormatResult">
            <xsl:with-param name="result" select="." />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="$result/../Unit">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$result/../Unit" />
        </xsl:if>
        <xsl:if test="$result/Statistics/Mean">
          <xsl:text> - Average </xsl:text>
          <xsl:call-template name="FormatResult">
            <xsl:with-param name="result" select="$result/Statistics/Mean" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$result/Statistics/Minimum">
          <xsl:text> - Min </xsl:text>
          <xsl:call-template name="FormatResult">
            <xsl:with-param name="result" select="$result/Statistics/Minimum" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$result/Statistics/Maximum">
          <xsl:text> - Max </xsl:text>
          <xsl:call-template name="FormatResult">
            <xsl:with-param name="result" select="$result/Statistics/Maximum" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$result/Statistics/StandardDeviation">
          <xsl:text> - Std Dev </xsl:text>
          <xsl:call-template name="FormatResult">
            <xsl:with-param name="result" select="$result/Statistics/StandardDeviation" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'array'">
        <fo:table table-layout="fixed" width="100%" margin-top="2pt">
          <fo:table-column column-width="proportional-column-width(3)"/>
          <xsl:for-each select="$result/Data">
            <fo:table-column column-width="proportional-column-width(2)"/>
          </xsl:for-each>
          <fo:table-body>
            <!-- Parameter row -->
            <fo:table-row background-color="#f8f8f8">
              <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                <fo:block text-align="left" font-size="7pt">
                  <xsl:choose>
                    <xsl:when test="$result/ParameterName">
                      <xsl:call-template name="AddWordWrapBreaks">
                        <xsl:with-param name="text" select="$result/ParameterName" />
                      </xsl:call-template>
                      <xsl:if test="$result/ParameterUnit">
                        <xsl:text> (</xsl:text>
                        <xsl:call-template name="AddWordWrapBreaks">
                          <xsl:with-param name="text" select="$result/ParameterUnit" />
                        </xsl:call-template>
                        <xsl:text>)</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>Parameter</xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <xsl:for-each select="$result/Data">
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                  <fo:block text-align="center" font-size="7pt" font-weight="bold">
                    <xsl:value-of select="Parameter" />
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
            <!-- Values row -->
            <fo:table-row>
              <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                <fo:block text-align="left" font-size="7pt">
                  <xsl:choose>
                    <xsl:when test="$result/../Unit">
                      <xsl:value-of select="concat('Value [', $result/../Unit, ']')" />
                    </xsl:when>
                    <xsl:otherwise>Value</xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <xsl:for-each select="$result/Data">
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                  <fo:block text-align="center" font-size="7pt">
                    <xsl:call-template name="FormatResult">
                      <xsl:with-param name="result" select="Value" />
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
            <!-- Min row (only if any data point has Minimum; blank cells stay blank) -->
            <xsl:if test="$result/Data/Minimum">
              <fo:table-row>
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                  <fo:block text-align="left" font-size="7pt">Min</fo:block>
                </fo:table-cell>
                <xsl:for-each select="$result/Data">
                  <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                    <fo:block text-align="center" font-size="7pt">
                      <xsl:if test="Minimum">
                        <xsl:call-template name="FormatResult">
                          <xsl:with-param name="result" select="Minimum" />
                        </xsl:call-template>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </xsl:if>
            <!-- Max row (only if any data point has Maximum; blank cells stay blank) -->
            <xsl:if test="$result/Data/Maximum">
              <fo:table-row>
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                  <fo:block text-align="left" font-size="7pt">Max</fo:block>
                </fo:table-cell>
                <xsl:for-each select="$result/Data">
                  <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                    <fo:block text-align="center" font-size="7pt">
                      <xsl:if test="Maximum">
                        <xsl:call-template name="FormatResult">
                          <xsl:with-param name="result" select="Maximum" />
                        </xsl:call-template>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </xsl:if>
            <!-- Status row (only if any data point has Status) -->
            <xsl:if test="$result/Data/Status">
              <fo:table-row>
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                  <fo:block text-align="left" font-size="7pt">Status</fo:block>
                </fo:table-cell>
                <xsl:for-each select="$result/Data">
                  <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                    <fo:block text-align="center" font-size="7pt">
                      <xsl:if test="Status">
                        <xsl:value-of select="Status" />
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </xsl:if>
          </fo:table-body>
        </fo:table>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result/Value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template to add zero-width space after every blank for better word wrapping -->
  <xsl:template name="AddWordWrapBreaks">
    <xsl:param name="text" />
    <xsl:value-of select="replace($text, '(\s)', '$1&#x00AD;')"/>
  </xsl:template>

  <xsl:template name="FormatAddress">
    <xsl:param name="party" />

    <!-- Determine country code -->
    <xsl:variable name="countryCode" select="$party/Country" />

    <xsl:choose>
      <!-- United States Format -->
      <xsl:when test="$countryCode = 'US'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City, State ZIP -->
        <fo:block>
          <xsl:value-of select="$party/City" />
          <xsl:if test="$party/StateProvince">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Canada Format (similar to US) -->
      <xsl:when test="$countryCode = 'CA'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City, Province ZIP -->
        <fo:block>
          <xsl:value-of select="$party/City" />
          <xsl:if test="$party/StateProvince">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Japan Format -->
      <xsl:when test="$countryCode = 'JP'">
        <!-- Postal code with ã symbol -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:text>ã</xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </fo:block>
        </xsl:if>
        <!-- Prefecture City District -->
        <fo:block>
          <xsl:if test="$party/StateProvince">
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:if test="$party/StateProvince">
              <xsl:text></xsl:text>
            </xsl:if>
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/District">
            <xsl:text></xsl:text>
            <xsl:value-of select="$party/District" />
          </xsl:if>
        </fo:block>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- China Format -->
      <xsl:when test="$countryCode = 'CN'">
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
        <!-- Postal code -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:value-of select="$party/ZipCode" />
          </fo:block>
        </xsl:if>
        <!-- Province City District -->
        <fo:block>
          <xsl:if test="$party/StateProvince">
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:if test="$party/StateProvince">
              <xsl:text></xsl:text>
            </xsl:if>
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/District">
            <xsl:text></xsl:text>
            <xsl:value-of select="$party/District" />
          </xsl:if>
        </fo:block>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
      </xsl:when>

      <!-- United Kingdom Format -->
      <xsl:when test="$countryCode = 'GB'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block>
            <xsl:value-of select="$party/City" />
          </fo:block>
        </xsl:if>
        <!-- Postal code -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:value-of select="$party/ZipCode" />
          </fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Australia Format -->
      <xsl:when test="$countryCode = 'AU'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City State ZIP -->
        <fo:block>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/StateProvince">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Brazil Format -->
      <xsl:when test="$countryCode = 'BR'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block>
            <xsl:value-of select="$party/District" />
          </fo:block>
        </xsl:if>
        <!-- ZIP City - State -->
        <fo:block>
          <xsl:if test="$party/ZipCode">
            <xsl:value-of select="$party/ZipCode" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/StateProvince">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- India Format -->
      <xsl:when test="$countryCode = 'IN'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block>
            <xsl:value-of select="$party/District" />
          </fo:block>
        </xsl:if>
        <!-- City - ZIP -->
        <fo:block>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- State -->
        <xsl:if test="$party/StateProvince">
          <fo:block>
            <xsl:value-of select="$party/StateProvince" />
          </fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- South Korea Format -->
      <xsl:when test="$countryCode = 'KR'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- District City -->
        <fo:block>
          <xsl:if test="$party/District">
            <xsl:value-of select="$party/District" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
        </fo:block>
        <!-- State ZIP -->
        <fo:block>
          <xsl:if test="$party/StateProvince">
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Mexico Format -->
      <xsl:when test="$countryCode = 'MX'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City, State -->
        <fo:block>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/StateProvince">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
        </fo:block>
        <!-- ZIP -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:value-of select="$party/ZipCode" />
          </fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Russia Format -->
      <xsl:when test="$countryCode = 'RU'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block>
            <xsl:value-of select="$party/City" />
          </fo:block>
        </xsl:if>
        <!-- State ZIP -->
        <fo:block>
          <xsl:if test="$party/StateProvince">
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Netherlands and EU Format -->
      <xsl:when test="$countryCode = 'NL' or $countryCode = 'DE' or $countryCode = 'FR' or $countryCode = 'IT' or $countryCode = 'ES' or $countryCode = 'AT' or $countryCode = 'BE' or $countryCode = 'CH'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- ZIP City -->
        <fo:block>
          <xsl:if test="$party/ZipCode">
            <xsl:value-of select="$party/ZipCode" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
        </fo:block>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:when>

      <!-- Default/Fallback Format -->
      <xsl:otherwise>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block>
            <xsl:value-of select="$party/District" />
          </fo:block>
        </xsl:if>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block>
            <xsl:value-of select="$party/City" />
          </fo:block>
        </xsl:if>
        <!-- State/Province -->
        <xsl:if test="$party/StateProvince">
          <fo:block>
            <xsl:value-of select="$party/StateProvince" />
          </fo:block>
        </xsl:if>
        <!-- ZIP -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:value-of select="$party/ZipCode" />
          </fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block>
          <xsl:value-of select="$party/Country" />
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="FormatSpecimenSpecification">
    <xsl:param name="specimen" />
    <xsl:if test="$specimen/Location or $specimen/Orientation or $specimen/Identifier">
      <fo:block font-size="6pt" color="#4A4A4A">
        <xsl:text>Specimen: </xsl:text>
        <xsl:if test="$specimen/Location">
          <xsl:value-of select="$specimen/Location" />
          <xsl:if test="$specimen/Location = 'Custom' and $specimen/CustomLocation">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$specimen/CustomLocation" />
            <xsl:text>)</xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:if test="$specimen/Orientation">
          <xsl:if test="$specimen/Location">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="$specimen/Orientation" />
        </xsl:if>
        <xsl:if test="$specimen/Identifier">
          <xsl:if test="$specimen/Location or $specimen/Orientation">
            <xsl:text> - </xsl:text>
          </xsl:if>
          <xsl:text>ID: </xsl:text>
          <xsl:value-of select="$specimen/Identifier" />
        </xsl:if>
      </fo:block>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
