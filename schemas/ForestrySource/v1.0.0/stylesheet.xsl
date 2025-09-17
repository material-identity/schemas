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
/
            <fo:page-number-citation-last ref-id="last-page" />
          </fo:block>
        </fo:static-content>
        <!-- Body -->
        <fo:flow flow-name="xsl-region-body" font-family="NotoSans, NotoSansSC">
          <!-- Global variables -->
          <xsl:variable name="cellPaddingBottom" select="'6pt'" />
          <xsl:variable name="partyPaddingBottom" select="'8pt'" />
          <xsl:variable name="fontSizeSmall" select="'6pt'" />

          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="GeneralInformation" select="Root/DigitalMaterialPassport/GeneralInformation" />
          <xsl:variable name="Supplier" select="Root/DigitalMaterialPassport/Supplier" />
          <xsl:variable name="Producer" select="Root/DigitalMaterialPassport/Producer" />
          <xsl:variable name="Creator" select="Root/DigitalMaterialPassport/Creator" />
          <xsl:variable name="HarvestUnits" select="Root/DigitalMaterialPassport/HarvestUnits" />
          <xsl:variable name="Products" select="Root/DigitalMaterialPassport/Products" />
          <xsl:variable name="DueDiligenceStatement" select="Root/DigitalMaterialPassport/DueDiligenceStatement" />
          <xsl:variable name="Contacts" select="Root/DigitalMaterialPassport/Contacts" />
          <xsl:variable name="Documents" select="Root/DigitalMaterialPassport/Documents" />
          <fo:block font-size="8pt">
            <!-- Parties -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <!-- <fo:table-cell number-columns-spanned="1">
                    <fo:block>
                      <fo:external-graphic fox:alt-text="Company Logo" src="{Root/DigitalMaterialPassport/Logo}" content-height="48px" height="48px" />
                    </fo:block>
                  </fo:table-cell> -->
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Creator" />
                    <xsl:with-param name="party" select="$Creator" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Supplier" />
                    <xsl:with-param name="party" select="$Supplier" />
                  </xsl:call-template>
                  <xsl:if test="exists($Producer)">
                    <xsl:call-template name="PartyInfo">
                      <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Producer" />
                      <xsl:with-param name="party" select="$Producer" />
                    </xsl:call-template>
                  </xsl:if>
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
                    <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Id" />
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
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/GeneralInformation" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:if test="exists($GeneralInformation/UserDefinedId)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/UserDefinedId" />
                      <xsl:with-param name="value" select="$GeneralInformation/UserDefinedId" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/Country)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Country" />
                      <xsl:with-param name="value" select="$GeneralInformation/Country" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/State)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/State" />
                      <xsl:with-param name="value" select="$GeneralInformation/State" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/District)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/District" />
                      <xsl:with-param name="value" select="$GeneralInformation/District" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/ForestConcessionNameOrNumber)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/ForestConcessionNameOrNumber" />
                      <xsl:with-param name="value" select="$GeneralInformation/ForestConcessionNameOrNumber" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/CertificationNumber)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationNumber" />
                      <xsl:with-param name="value" select="$GeneralInformation/CertificationNumber" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/CertificationClaim)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationClaim" />
                      <xsl:with-param name="value" select="$GeneralInformation/CertificationClaim" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/CertificationPercentage)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/CertificationPercentage" />
                      <xsl:with-param name="value" select="$GeneralInformation/CertificationPercentage" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/HarvestAuthorizationNameOrNumber)">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/HarvestAuthorizationNameOrNumber" />
                      <xsl:with-param name="value" select="$GeneralInformation/HarvestAuthorizationNameOrNumber" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <!-- Harvesting Period -->
                <xsl:if test="exists($GeneralInformation/HarvestAuthorizationNameOrNumber)">
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/HarvestingPeriod" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/StartDate" />
                      <xsl:with-param name="value" select="$GeneralInformation/HarvestingPeriod/StartDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/EndDate" />
                      <xsl:with-param name="value" select="$GeneralInformation/HarvestingPeriod/EndDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
              </fo:table-body>
            </fo:table>

            <!-- HarvestUnits -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/HarvestUnits" />
            </xsl:call-template>
            <xsl:for-each select="$HarvestUnits">
              <xsl:variable name="index" select="." />
              <xsl:variable name="typeValue" select="$index/type" />
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/*[name() = $typeValue]" />
              </xsl:call-template>
              <xsl:for-each select="features">
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="15%"/>
                  <fo:table-column column-width="50%"/>
                  <fo:table-column column-width="35%"/>
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-weight="bold" padding-bottom="{$cellPaddingBottom}" padding-top="{$cellPaddingBottom}">
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/Type" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block font-weight="bold" padding-bottom="{$cellPaddingBottom}" padding-top="{$cellPaddingBottom}">
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/Properties" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block font-weight="bold" padding-bottom="{$cellPaddingBottom}" padding-top="{$cellPaddingBottom}">
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/Geometry" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                      <fo:table-cell >
                        <fo:block >
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/*[local-name() = current()/type]" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:table table-layout="fixed" width="100%">
                          <fo:table-column column-width="55%"/>
                          <fo:table-column column-width="45%"/>
                          <fo:table-body>
                            <xsl:for-each select="properties/*">
                              <fo:table-row>
                                <xsl:call-template name="KeyValue">
                                  <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/*[local-name() = local-name(current())]" />
                                  <xsl:with-param name="value" select="." />
                                  <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                                </xsl:call-template>
                              </fo:table-row>
                            </xsl:for-each>
                          </fo:table-body>
                        </fo:table>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <fo:table table-layout="fixed" width="100%">
                            <fo:table-column column-width="50%"/>
                            <fo:table-column column-width="50%"/>
                            <fo:table-body>
                              <fo:table-row>
                                <xsl:call-template name="KeyValue">
                                  <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/Type" />
                                  <xsl:with-param name="value" select="geometry/type" />
                                  <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                                </xsl:call-template>
                              </fo:table-row>
                            </fo:table-body>
                          </fo:table>
                        </fo:block>
                        
                        <!-- Handle different geometry types -->
                        <xsl:choose>
                          <!-- Case: Point geometry -->
                          <xsl:when test="geometry/type = 'Point'">
                            <xsl:call-template name="GenerateCoordinatesTable">
                              <xsl:with-param name="headerCount" select="2" />
                              <xsl:with-param name="Section" select="geometry/coordinates" />
                              <xsl:with-param name="latitudeTranslation" select="$i18n/DigitalMaterialPassport/Latitude" />
                              <xsl:with-param name="longitudeTranslation" select="$i18n/DigitalMaterialPassport/Longitude" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </xsl:when>
                          
                          <!-- Case: Polygon geometry -->
                          <xsl:when test="geometry/type = 'Polygon'">
                            <xsl:call-template name="GenerateCoordinatesTable">
                              <xsl:with-param name="headerCount" select="2" />
                              <xsl:with-param name="Section" select="geometry/coordinates" />
                              <xsl:with-param name="latitudeTranslation" select="$i18n/DigitalMaterialPassport/Latitude" />
                              <xsl:with-param name="longitudeTranslation" select="$i18n/DigitalMaterialPassport/Longitude" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </xsl:when>
                          
                          <!-- Case: GeometryCollection -->
                          <xsl:when test="geometry/type = 'GeometryCollection'">
                            <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                              <xsl:value-of select="'Geometry Collection Contents'" />
                            </fo:block>
                            
                            <!-- Loop through each geometry in the collection -->
                            <xsl:for-each select="geometry/geometries">
                              <fo:block font-weight="bold" padding-top="4pt" padding-bottom="2pt">
                                <xsl:value-of select="concat('Type: ', type)" />
                              </fo:block>
                              
                              <!-- Render each geometry based on its type -->
                              <xsl:choose>
                                <!-- Point within GeometryCollection -->
                                <xsl:when test="type = 'Point'">
                                  <xsl:call-template name="GenerateCoordinatesTable">
                                    <xsl:with-param name="headerCount" select="2" />
                                    <xsl:with-param name="Section" select="coordinates" />
                                    <xsl:with-param name="latitudeTranslation" select="$i18n/DigitalMaterialPassport/Latitude" />
                                    <xsl:with-param name="longitudeTranslation" select="$i18n/DigitalMaterialPassport/Longitude" />
                                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                                  </xsl:call-template>
                                </xsl:when>
                                
                                <!-- Polygon within GeometryCollection -->
                                <xsl:when test="type = 'Polygon'">
                                  <xsl:call-template name="GenerateCoordinatesTable">
                                    <xsl:with-param name="headerCount" select="2" />
                                    <xsl:with-param name="Section" select="coordinates" />
                                    <xsl:with-param name="latitudeTranslation" select="$i18n/DigitalMaterialPassport/Latitude" />
                                    <xsl:with-param name="longitudeTranslation" select="$i18n/DigitalMaterialPassport/Longitude" />
                                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                                  </xsl:call-template>
                                </xsl:when>
                              </xsl:choose>
                              
                              <!-- Add a separator between geometries -->
                              <xsl:if test="position() != last()">
                                <fo:block border-bottom="dotted 1pt gray" margin-top="4pt" margin-bottom="4pt"/>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                        </xsl:choose>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
              </xsl:for-each>
            </xsl:for-each>

            <!-- Products -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Products" />
            </xsl:call-template>
            <xsl:for-each select="$Products">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="ProductType" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/DescriptionOfProduct" />
                      <xsl:with-param name="value" select="DescriptionOfProduct" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/HTSCode" />
                      <xsl:with-param name="value" select="HTSCode" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
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
                </fo:table-body>
              </fo:table>
              <fo:block font-style="italic" text-decoration="underline" padding-bottom="{$cellPaddingBottom}">
                <xsl:value-of select="$i18n/DigitalMaterialPassport/ListOfSpecies" />
              </fo:block>
              <xsl:call-template name="GenerateSpeciesTable">
                <xsl:with-param name="Section" select="ListOfSpecies" />
                <xsl:with-param name="CommonNameTranslation" select="$i18n/DigitalMaterialPassport/CommonName" />
                <xsl:with-param name="ScientificNameTranslation" select="$i18n/DigitalMaterialPassport/ScientificName" />
                <xsl:with-param name="GenusTranslation" select="$i18n/DigitalMaterialPassport/Genus" />
                <xsl:with-param name="SpeciesTranslation" select="$i18n/DigitalMaterialPassport/Species" />
                <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
              </xsl:call-template>
            </xsl:for-each>

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

            <!-- Contacts -->
            <xsl:if test="exists($Contacts)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/DigitalMaterialPassport/Contacts" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="10%" />
                <fo:table-column column-width="15%" />
                <fo:table-column column-width="25%" />
                <fo:table-column column-width="30%" />
                <fo:table-column column-width="10%" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Name" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Role" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Department" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Email" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Phone" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:for-each select="$Contacts">
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                        <fo:block font-family="NotoSans, NotoSansSC" font-style="italic">
                          <xsl:value-of select="Name" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Role" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Department" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Email" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Phone" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Footer -->
            <fo:table table-layout="fixed" margin-top="16pt" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block> Data schema maintained by
                      <fo:basic-link external-destination="https://materialidentity.org">
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
    <fo:table-cell padding-bottom="{$paddingBottom}">
      <fo:block font-weight="bold">
        <xsl:value-of select="$title" />
      </fo:block>
      <fo:block font-weight="bold">
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
  <xsl:template name="GenerateCoordinatesTable">
    <xsl:param name="headerCount" />
    <xsl:param name="Section" />
    <xsl:param name="latitudeTranslation" />
    <xsl:param name="longitudeTranslation" />
    <xsl:param name="paddingBottom" select="'6pt'" />

    <fo:table table-layout="fixed" width="100%">
      <!-- Dynamically generate table columns based on the number of headers -->
      <xsl:for-each select="$Section/Header">
        <fo:table-column column-width="{100 div $headerCount}%"/>
      </xsl:for-each>
      <fo:table-body>
        <!-- Headers -->
        <fo:table-row>
          <fo:table-cell font-style="italic">
            <fo:block padding-bottom="{$paddingBottom}">
              <xsl:value-of select="$latitudeTranslation" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell font-style="italic">
            <fo:block padding-bottom="{$paddingBottom}">
              <xsl:value-of select="$longitudeTranslation" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <!-- Rows -->
        <xsl:if test="$headerCount > 0">
          <xsl:for-each select="$Section">
            <xsl:variable name="pos" select="position()" />
            <xsl:if test="($pos - 1) mod $headerCount = 0">
              <fo:table-row>
                <xsl:for-each select=".|following-sibling::*[position() &lt; $headerCount]">
                  <fo:table-cell>
                    <fo:block>
                      <xsl:value-of select="." />
                    </fo:block>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template name="GenerateSpeciesTable">
    <xsl:param name="Section" />
    <xsl:param name="CommonNameTranslation" />
    <xsl:param name="ScientificNameTranslation" />
    <xsl:param name="GenusTranslation" />
    <xsl:param name="SpeciesTranslation" />
    <xsl:param name="paddingBottom" select="'6pt'" />

    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="33.3%" />
      <fo:table-column column-width="33.3%" />
      <fo:table-column column-width="33.3%" />
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
          <fo:table-cell>
            <fo:block font-style="italic" padding-bottom="{$paddingBottom}">
              Measurements
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
            <fo:table-cell>
              <fo:block>
                <xsl:if test="Measurements/Volume">
                  <fo:block>Volume: <xsl:value-of select="concat(Measurements/Volume/Value, ' ', Measurements/Volume/Unit)" /></fo:block>
                </xsl:if>
                <xsl:if test="Measurements/NetWeight">
                  <fo:block>Net Weight: <xsl:value-of select="concat(Measurements/NetWeight/Value, ' ', Measurements/NetWeight/Unit)" /></fo:block>
                </xsl:if>
                <xsl:if test="Measurements/SupplementaryUnit">
                  <fo:block>Supplementary: <xsl:value-of select="concat(Measurements/SupplementaryUnit/Value, ' ', Measurements/SupplementaryUnit/Unit)" /></fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>
</xsl:stylesheet>