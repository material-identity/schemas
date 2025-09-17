<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">
  <xsl:template match="/">
    <fo:root xml:lang="en">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin="1cm">
          <fo:region-body margin="0.25cm" margin-bottom="1.8cm" />
          <fo:region-after extent="1.5cm" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">
        <!-- Page number -->
        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-size="8pt" text-align="center" margin-right="1cm" font-family="NotoSans, NotoSansSC">
            <fo:page-number />
 /            <fo:page-number-citation-last ref-id="last-page" />
          </fo:block>
        </fo:static-content>
        <!-- Body -->
        <fo:flow flow-name="xsl-region-body" font-family="NotoSans, NotoSansSC">
          <!-- Global variables -->
          <xsl:variable name="cellPaddingBottom" select="'6pt'" />
          <xsl:variable name="partyPaddingBottom" select="'4pt'" />
          <xsl:variable name="fontSizeSmall" select="'6pt'" />

          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="GeneralInformation" select="Root/DigitalMaterialPassport/GeneralInformation" />
          <xsl:variable name="Supplier" select="Root/DigitalMaterialPassport/Supplier" />
          <xsl:variable name="Producer" select="Root/DigitalMaterialPassport/Producer" />
          <xsl:variable name="Creator" select="Root/DigitalMaterialPassport/Creator" />
          <xsl:variable name="Customer" select="Root/DigitalMaterialPassport/Customer" />
          <xsl:variable name="PurchaseOrder" select="Root/DigitalMaterialPassport/PurchaseOrder" />
          <xsl:variable name="Delivery" select="Root/DigitalMaterialPassport/Delivery" />
          <xsl:variable name="SalesOrder" select="Root/DigitalMaterialPassport/SalesOrder" />
          <xsl:variable name="Products" select="Root/DigitalMaterialPassport/Products" />
          <xsl:variable name="DMPReferences" select="Root/DigitalMaterialPassport/DMPReferences" />
          <xsl:variable name="EUDRReferences" select="Root/DigitalMaterialPassport/EUDRReferences" />
          <xsl:variable name="DueDiligenceStatement" select="Root/DigitalMaterialPassport/DueDiligenceStatement" />
          <xsl:variable name="Documents" select="Root/DigitalMaterialPassport/Documents" />
          <fo:block font-size="8pt">
            <!-- Parties -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Creator" />
                    <xsl:with-param name="party" select="$Creator" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Supplier" />
                    <xsl:with-param name="party" select="$Supplier" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:if test="exists($Producer)">
                    <xsl:call-template name="PartyInfo">
                      <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Producer" />
                      <xsl:with-param name="party" select="$Producer" />
                      <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Customer" />
                    <xsl:with-param name="party" select="$Customer" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- DMP info -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/DigitalMaterialPassport" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/DMPId" />
                    <xsl:with-param name="value" select="Root/DigitalMaterialPassport/Id" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Date" />
                    <xsl:with-param name="value" select="Root/DigitalMaterialPassport/Date" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- General Information -->
            <xsl:if test="exists($GeneralInformation)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/GeneralInformation" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/UserDefinedId" />
                      <xsl:with-param name="value" select="$GeneralInformation/UserDefinedId" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Country" />
                      <xsl:with-param name="value" select="$GeneralInformation/Country" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <xsl:if test="exists($GeneralInformation/State)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/State" />
                        <xsl:with-param name="value" select="$GeneralInformation/State" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Products -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Products" />
            </xsl:call-template>
            <xsl:for-each select="$Products">
              <xsl:if test="exists(ProductType)">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="ProductType" />
                </xsl:call-template>
              </xsl:if>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:if test="exists(DescriptionOfProduct)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/DescriptionOfProduct" />
                        <xsl:with-param name="value" select="DescriptionOfProduct" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists(HTSCode)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/HTSCode" />
                        <xsl:with-param name="value" select="HTSCode" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists(ProductionPeriod)">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/ProductionPeriod" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/StartDate" />
                        <xsl:with-param name="value" select="ProductionPeriod/StartDate" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/EndDate" />
                        <xsl:with-param name="value" select="ProductionPeriod/EndDate" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>

              <!-- Product Measurements -->
              <xsl:if test="exists(Measurements)">
                <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                  <xsl:value-of select="$i18n/DigitalMaterialPassport/Measurements" />
                </fo:block>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <xsl:if test="exists(Measurements/Volume)">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Volume" />
                          <xsl:with-param name="value" select="concat(Measurements/Volume/Value, ' ', Measurements/Volume/Unit)" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:if>
                    <xsl:if test="exists(Measurements/NetWeight)">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/NetWeight" />
                          <xsl:with-param name="value" select="concat(Measurements/NetWeight/Value, ' ', Measurements/NetWeight/Unit)" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:if>
                    <xsl:if test="exists(Measurements/SupplementaryUnit)">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/SupplementaryUnit" />
                          <xsl:with-param name="value" select="concat(Measurements/SupplementaryUnit/Value, ' ', Measurements/SupplementaryUnit/Unit)" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:if>
                  </fo:table-body>
                </fo:table>
              </xsl:if>

              <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                <xsl:value-of select="$i18n/DigitalMaterialPassport/ListOfSpecies" />
              </fo:block>
              <xsl:if test="exists(ListOfSpecies)">
                <xsl:call-template name="GenerateSpeciesTable">
                  <xsl:with-param name="Section" select="ListOfSpecies" />
                  <xsl:with-param name="CommonNameTranslation" select="$i18n/DigitalMaterialPassport/CommonName" />
                  <xsl:with-param name="ScientificNameTranslation" select="$i18n/DigitalMaterialPassport/ScientificName" />
                  <xsl:with-param name="GenusTranslation" select="$i18n/DigitalMaterialPassport/Genus" />
                  <xsl:with-param name="SpeciesTranslation" select="$i18n/DigitalMaterialPassport/Species" />
                  <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                </xsl:call-template>
              </xsl:if>
            </xsl:for-each>

            <!-- Purchase Order -->
            <xsl:if test="exists($PurchaseOrder)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/PurchaseOrder" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:if test="exists($PurchaseOrder/Id)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Id" />
                        <xsl:with-param name="value" select="$PurchaseOrder/Id" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($PurchaseOrder/Position)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Position" />
                        <xsl:with-param name="value" select="$PurchaseOrder/Position" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($PurchaseOrder/Date)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Date" />
                        <xsl:with-param name="value" select="$PurchaseOrder/Date" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($PurchaseOrder/CustomerProductId)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CustomerProductId" />
                        <xsl:with-param name="value" select="$PurchaseOrder/CustomerProductId" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($PurchaseOrder/CustomerProductName)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CustomerProductName" />
                        <xsl:with-param name="value" select="$PurchaseOrder/CustomerProductName" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Sales Order -->
            <xsl:if test="exists($SalesOrder)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/SalesOrder" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:if test="exists($SalesOrder/Id)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Id" />
                        <xsl:with-param name="value" select="$SalesOrder/Id" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/Position)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Position" />
                        <xsl:with-param name="value" select="$SalesOrder/Position" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/Date)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Date" />
                        <xsl:with-param name="value" select="$SalesOrder/Date" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/CertificationNumber)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationNumber" />
                        <xsl:with-param name="value" select="$SalesOrder/CertificationNumber" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/CertificationClaim)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationClaim" />
                        <xsl:with-param name="value" select="$SalesOrder/CertificationClaim" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/CertificationPercentage)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationPercentage" />
                        <xsl:with-param name="value" select="$SalesOrder/CertificationPercentage" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists($SalesOrder/Incoterms)">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                          Incoterms
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Code" />
                        <xsl:with-param name="value" select="$SalesOrder/Incoterms/incoterm/code" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Description" />
                        <xsl:with-param name="value" select="$SalesOrder/Incoterms//incoterm/description" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- DMP References -->
            <xsl:if test="exists($DMPReferences)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/DMPReferences" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <!-- Two columns layout -->
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <!-- Table header row -->
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/DMPId" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/UserDefinedId" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>

                  <!-- Data rows -->
                  <xsl:for-each select="$DMPReferences">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block padding-bottom="{$cellPaddingBottom}">
                          <xsl:choose>
                            <xsl:when test="JsonURL">
                              <fo:basic-link external-destination="{JsonURL}">
                                <fo:inline text-decoration="underline">
                                  <xsl:value-of select="Id" />
                                </fo:inline>
                              </fo:basic-link>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="Id" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block padding-bottom="{$cellPaddingBottom}">
                          <xsl:choose>
                            <xsl:when test="PdfURL">
                              <fo:basic-link external-destination="{PdfURL}">
                                <fo:inline text-decoration="underline">
                                  <xsl:value-of select="UserDefinedId" />
                                </fo:inline>
                              </fo:basic-link>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="UserDefinedId" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>


            <!-- EUDRReferences -->
            <xsl:if test="exists($EUDRReferences)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/EUDRReferences" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <!-- Three columns layout -->
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.34%" />
                <fo:table-body>
                  <!-- Table header row -->
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/DDSReferenceNumber" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/VerificationNumber" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/InternalReferenceNumber" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>

                  <!-- Data rows -->
                  <xsl:for-each select="$EUDRReferences">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block padding-bottom="{$cellPaddingBottom}">
                          <xsl:value-of select="DDSReferenceNumber" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block padding-bottom="{$cellPaddingBottom}">
                          <xsl:value-of select="VerificationNumber" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block padding-bottom="{$cellPaddingBottom}">
                          <xsl:value-of select="InternalReferenceNumber" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Due Diligence Statement -->
            <xsl:if test="exists($DueDiligenceStatement)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/DueDiligenceStatement" />
              </xsl:call-template>
              <xsl:for-each select="tokenize($DueDiligenceStatement, '&#10;')">
                <fo:block>
                  <xsl:value-of select="." />
                </fo:block>
              </xsl:for-each>
            </xsl:if>

            <!-- Footer -->
            <fo:table table-layout="fixed" margin-top="16pt" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block> Data schema maintained by <fo:basic-link external-destination="https://materialidentity.org">
                      <fo:inline text-decoration="underline">Material Identity</fo:inline>
                    </fo:basic-link>
  . 
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block color="gray" text-align="right">
                    <fo:basic-link external-destination="{Root/RefSchemaUrl}">
                      <fo:inline text-decoration="underline">
                        <xsl:value-of select="Root/RefSchemaUrl" />
                      </fo:inline>
                    </fo:basic-link>
                  </fo:block>
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
<xsl:template name="SectionTitle">
  <xsl:param name="title" />
  <fo:block font-size="10pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt" border-bottom="solid 1pt black">
    <xsl:value-of select="$title" />
  </fo:block>
</xsl:template>
<xsl:template name="SectionTitleSmall">
  <xsl:param name="title" />
  <fo:block font-size="8pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt">
    <xsl:value-of select="$title" />
  </fo:block>
</xsl:template>

<xsl:template name="KeyValue">
  <xsl:param name="key" />
  <xsl:param name="value" />
  <xsl:param name="paddingBottom" />
  <fo:table-cell>
    <fo:block padding-bottom="{$paddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
      <xsl:value-of select="$key" />
    </fo:block>
  </fo:table-cell>
  <fo:table-cell>
    <fo:block padding-bottom="{$paddingBottom}">
      <xsl:value-of select="$value" />
    </fo:block>
  </fo:table-cell>
</xsl:template>

<xsl:template name="PartyInfo">
  <xsl:param name="title" />
  <xsl:param name="party" />
  <xsl:param name="paddingBottom" select="'4pt'" />
  <fo:table-cell padding-top="{$paddingBottom}">
    <fo:block font-weight="bold">
      <xsl:value-of select="$title" />
    </fo:block>
    <fo:block font-weight="bold" padding-bottom="{$paddingBottom}">
      <xsl:value-of select="$party/Name" />
    </fo:block>
    <fo:block>
      <xsl:for-each select="$party/Street">
        <fo:block>
          <xsl:value-of select="." />
        </fo:block>
      </xsl:for-each>
    </fo:block>
    <xsl:for-each select="$party/Streets/Street">
      <fo:block>
        <xsl:value-of select="." />
      </fo:block>
    </xsl:for-each>
    <fo:block>
      <xsl:value-of select="concat($party/ZipCode, ' ', $party/City, ', ', $party/Country)" />
    </fo:block>
    <fo:block>
      <fo:basic-link external-destination="{concat('mailto:', $party/Email)}">
        <fo:inline text-decoration="underline">
          <xsl:value-of select="$party/Email" />
        </fo:inline>
      </fo:basic-link>
    </fo:block>
  </fo:table-cell>
</xsl:template>
<xsl:template name="GenerateSpeciesTable">
  <xsl:param name="Section" />
  <xsl:param name="CommonNameTranslation" />
  <xsl:param name="ScientificNameTranslation" />
  <xsl:param name="GenusTranslation" />
  <xsl:param name="SpeciesTranslation" />
  <xsl:param name="paddingBottom" select="'6pt'" />

  <fo:table table-layout="fixed" width="100%">
    <fo:table-column column-width="50%" />
    <fo:table-column column-width="50%" />
    <fo:table-body>
      <!-- Headers -->
      <fo:table-row>
        <fo:table-cell>
          <fo:block font-style="italic" padding-bottom="{$paddingBottom}">
            <xsl:value-of select="$CommonNameTranslation" />
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block font-style="italic" padding-bottom="{$paddingBottom}">
            <xsl:value-of select="$ScientificNameTranslation" />
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      <!-- Rows -->
      <xsl:for-each select="$Section">
        <fo:table-row>
          <fo:table-cell>
            <fo:block>
              <xsl:value-of select="CommonName" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>
              <xsl:value-of select="concat(ScientificName/Genus, ' ', ScientificName/Species)" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
    </fo:table-body>
  </fo:table>
</xsl:template>
</xsl:stylesheet>