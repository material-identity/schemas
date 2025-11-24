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
          <xsl:variable name="HarvestUnitsDownloadURL" select="Root/DigitalMaterialPassport/HarvestUnitsDownloadURL" />
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
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:value-of select="$i18n/DigitalMaterialPassport/Country" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}">
                        <xsl:call-template name="CountryName">
                          <xsl:with-param name="countryCode" select="$GeneralInformation/Country" />
                        </xsl:call-template>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="exists($GeneralInformation/State)">
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}" font-family="NotoSans, NotoSansSC" font-style="italic">
                        <xsl:call-template name="StateProvinceLabel">
                          <xsl:with-param name="countryCode" select="$GeneralInformation/Country" />
                        </xsl:call-template>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block padding-bottom="{$cellPaddingBottom}">
                        <xsl:value-of select="$GeneralInformation/State" />
                      </fo:block>
                    </fo:table-cell>
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
                      <xsl:with-param name="key" select="$i18n/DigitalMaterialPassport/HSCode" />
                      <xsl:with-param name="value" select="HSCode" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <xsl:if test="exists(CustomsClassification/HTS)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'HTS Code'" />
                        <xsl:with-param name="value" select="CustomsClassification/HTS" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="exists(CustomsClassification/CN)">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'CN Code'" />
                        <xsl:with-param name="value" select="CustomsClassification/CN" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
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

            <!-- HarvestUnitsDownloadURL -->
            <xsl:if test="$HarvestUnitsDownloadURL">
              <fo:block margin-top="8pt" margin-bottom="4pt">
                <fo:basic-link external-destination="{$HarvestUnitsDownloadURL}">
                  <fo:inline text-decoration="underline" color="blue">
                    <xsl:value-of select="$i18n/DigitalMaterialPassport/HarvestUnitsDownloadURL" />
                  </fo:inline>
                </fo:basic-link>
              </fo:block>
            </xsl:if>

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
                      <fo:table-cell number-columns-spanned="3">
                        <!-- Type line -->
                        <fo:block padding-bottom="2pt">
                          <fo:inline font-weight="bold"><xsl:value-of select="$i18n/DigitalMaterialPassport/Type" />: </fo:inline>
                          <xsl:value-of select="$i18n/DigitalMaterialPassport/*[local-name() = current()/type]" />
                        </fo:block>

                        <!-- Geometry line -->
                        <fo:block padding-bottom="2pt">
                          <fo:inline font-weight="bold"><xsl:value-of select="$i18n/DigitalMaterialPassport/Geometry" />: </fo:inline>
                          <xsl:value-of select="geometry/type" />
                        </fo:block>

                        <!-- Properties line -->
                        <xsl:if test="properties/*">
                          <fo:block padding-bottom="4pt">
                            <fo:inline font-weight="bold"><xsl:value-of select="$i18n/DigitalMaterialPassport/Properties" />: </fo:inline>
                            <xsl:for-each select="properties/*">
                              <xsl:value-of select="$i18n/DigitalMaterialPassport/*[local-name() = local-name(current())]" />
                              <xsl:text>: </xsl:text>
                              <xsl:value-of select="." />
                              <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                              </xsl:if>
                            </xsl:for-each>
                          </fo:block>
                        </xsl:if>

                        <!-- Coordinates -->
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
                                <fo:block border-bottom="dotted 0.5pt gray" margin-top="2pt" margin-bottom="2pt"/>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                        </xsl:choose>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <!-- Add separator after feature -->
                <fo:block border-bottom="dotted 0.5pt #CCCCCC" margin-top="2pt" margin-bottom="2pt"/>
              </xsl:for-each>
            </xsl:for-each>

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
      <xsl:call-template name="FormatAddress">
        <xsl:with-param name="party" select="$party" />
      </xsl:call-template>
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

    <!-- Flat list format: 5 coordinate pairs per line for performance -->
    <!-- Process every 2nd element (latitude at odd positions) and output 5 pairs per line -->
    <fo:block font-size="7pt">
      <xsl:for-each select="$Section[position() mod 2 = 1]">
        <xsl:variable name="pairIndex" select="position()" />
        <!-- Output coordinate pair: (lat, lon) -->
        <xsl:text>(</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>, </xsl:text>
        <xsl:value-of select="following-sibling::*[1]" />
        <xsl:text>)</xsl:text>

        <!-- Add comma separator or line break after 5 pairs -->
        <xsl:choose>
          <xsl:when test="$pairIndex mod 5 = 0 and following-sibling::*[2]">
            <!-- After 5 pairs (and not the last), add line break -->
            <xsl:text>,</xsl:text>
            <fo:block/>
          </xsl:when>
          <xsl:when test="following-sibling::*[2]">
            <!-- Not the last pair and not 5th pair, add comma and space -->
            <xsl:text>, </xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </fo:block>
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
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="Measurements/SupplementaryUnit/DisplayUnit">
                        Supplementary: <xsl:value-of select="concat(Measurements/SupplementaryUnit/Value, ' ', Measurements/SupplementaryUnit/DisplayUnit)" />
                      </xsl:when>
                      <xsl:otherwise>
                        Supplementary: <xsl:value-of select="concat(Measurements/SupplementaryUnit/Value, ' ', Measurements/SupplementaryUnit/Unit)" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="CountryName">
    <xsl:param name="countryCode" />
    <xsl:choose>
      <xsl:when test="$countryCode = 'AD'">Andorra</xsl:when>
      <xsl:when test="$countryCode = 'AE'">United Arab Emirates</xsl:when>
      <xsl:when test="$countryCode = 'AF'">Afghanistan</xsl:when>
      <xsl:when test="$countryCode = 'AG'">Antigua and Barbuda</xsl:when>
      <xsl:when test="$countryCode = 'AI'">Anguilla</xsl:when>
      <xsl:when test="$countryCode = 'AL'">Albania</xsl:when>
      <xsl:when test="$countryCode = 'AM'">Armenia</xsl:when>
      <xsl:when test="$countryCode = 'AO'">Angola</xsl:when>
      <xsl:when test="$countryCode = 'AQ'">Antarctica</xsl:when>
      <xsl:when test="$countryCode = 'AR'">Argentina</xsl:when>
      <xsl:when test="$countryCode = 'AS'">American Samoa</xsl:when>
      <xsl:when test="$countryCode = 'AT'">Austria</xsl:when>
      <xsl:when test="$countryCode = 'AU'">Australia</xsl:when>
      <xsl:when test="$countryCode = 'AW'">Aruba</xsl:when>
      <xsl:when test="$countryCode = 'AX'">Åland Islands</xsl:when>
      <xsl:when test="$countryCode = 'AZ'">Azerbaijan</xsl:when>
      <xsl:when test="$countryCode = 'BA'">Bosnia and Herzegovina</xsl:when>
      <xsl:when test="$countryCode = 'BB'">Barbados</xsl:when>
      <xsl:when test="$countryCode = 'BD'">Bangladesh</xsl:when>
      <xsl:when test="$countryCode = 'BE'">Belgium</xsl:when>
      <xsl:when test="$countryCode = 'BF'">Burkina Faso</xsl:when>
      <xsl:when test="$countryCode = 'BG'">Bulgaria</xsl:when>
      <xsl:when test="$countryCode = 'BH'">Bahrain</xsl:when>
      <xsl:when test="$countryCode = 'BI'">Burundi</xsl:when>
      <xsl:when test="$countryCode = 'BJ'">Benin</xsl:when>
      <xsl:when test="$countryCode = 'BL'">Saint Barthélemy</xsl:when>
      <xsl:when test="$countryCode = 'BM'">Bermuda</xsl:when>
      <xsl:when test="$countryCode = 'BN'">Brunei</xsl:when>
      <xsl:when test="$countryCode = 'BO'">Bolivia</xsl:when>
      <xsl:when test="$countryCode = 'BQ'">Caribbean Netherlands</xsl:when>
      <xsl:when test="$countryCode = 'BR'">Brazil</xsl:when>
      <xsl:when test="$countryCode = 'BS'">Bahamas</xsl:when>
      <xsl:when test="$countryCode = 'BT'">Bhutan</xsl:when>
      <xsl:when test="$countryCode = 'BV'">Bouvet Island</xsl:when>
      <xsl:when test="$countryCode = 'BW'">Botswana</xsl:when>
      <xsl:when test="$countryCode = 'BY'">Belarus</xsl:when>
      <xsl:when test="$countryCode = 'BZ'">Belize</xsl:when>
      <xsl:when test="$countryCode = 'CA'">Canada</xsl:when>
      <xsl:when test="$countryCode = 'CC'">Cocos (Keeling) Islands</xsl:when>
      <xsl:when test="$countryCode = 'CD'">Congo (DRC)</xsl:when>
      <xsl:when test="$countryCode = 'CF'">Central African Republic</xsl:when>
      <xsl:when test="$countryCode = 'CG'">Congo (Republic)</xsl:when>
      <xsl:when test="$countryCode = 'CH'">Switzerland</xsl:when>
      <xsl:when test="$countryCode = 'CI'">Côte d'Ivoire</xsl:when>
      <xsl:when test="$countryCode = 'CK'">Cook Islands</xsl:when>
      <xsl:when test="$countryCode = 'CL'">Chile</xsl:when>
      <xsl:when test="$countryCode = 'CM'">Cameroon</xsl:when>
      <xsl:when test="$countryCode = 'CN'">China</xsl:when>
      <xsl:when test="$countryCode = 'CO'">Colombia</xsl:when>
      <xsl:when test="$countryCode = 'CR'">Costa Rica</xsl:when>
      <xsl:when test="$countryCode = 'CU'">Cuba</xsl:when>
      <xsl:when test="$countryCode = 'CV'">Cabo Verde</xsl:when>
      <xsl:when test="$countryCode = 'CW'">Curaçao</xsl:when>
      <xsl:when test="$countryCode = 'CX'">Christmas Island</xsl:when>
      <xsl:when test="$countryCode = 'CY'">Cyprus</xsl:when>
      <xsl:when test="$countryCode = 'CZ'">Czechia</xsl:when>
      <xsl:when test="$countryCode = 'DE'">Germany</xsl:when>
      <xsl:when test="$countryCode = 'DJ'">Djibouti</xsl:when>
      <xsl:when test="$countryCode = 'DK'">Denmark</xsl:when>
      <xsl:when test="$countryCode = 'DM'">Dominica</xsl:when>
      <xsl:when test="$countryCode = 'DO'">Dominican Republic</xsl:when>
      <xsl:when test="$countryCode = 'DZ'">Algeria</xsl:when>
      <xsl:when test="$countryCode = 'EC'">Ecuador</xsl:when>
      <xsl:when test="$countryCode = 'EE'">Estonia</xsl:when>
      <xsl:when test="$countryCode = 'EG'">Egypt</xsl:when>
      <xsl:when test="$countryCode = 'EH'">Western Sahara</xsl:when>
      <xsl:when test="$countryCode = 'ER'">Eritrea</xsl:when>
      <xsl:when test="$countryCode = 'ES'">Spain</xsl:when>
      <xsl:when test="$countryCode = 'ET'">Ethiopia</xsl:when>
      <xsl:when test="$countryCode = 'FI'">Finland</xsl:when>
      <xsl:when test="$countryCode = 'FJ'">Fiji</xsl:when>
      <xsl:when test="$countryCode = 'FK'">Falkland Islands</xsl:when>
      <xsl:when test="$countryCode = 'FM'">Micronesia</xsl:when>
      <xsl:when test="$countryCode = 'FO'">Faroe Islands</xsl:when>
      <xsl:when test="$countryCode = 'FR'">France</xsl:when>
      <xsl:when test="$countryCode = 'GA'">Gabon</xsl:when>
      <xsl:when test="$countryCode = 'GB'">United Kingdom</xsl:when>
      <xsl:when test="$countryCode = 'GD'">Grenada</xsl:when>
      <xsl:when test="$countryCode = 'GE'">Georgia</xsl:when>
      <xsl:when test="$countryCode = 'GF'">French Guiana</xsl:when>
      <xsl:when test="$countryCode = 'GG'">Guernsey</xsl:when>
      <xsl:when test="$countryCode = 'GH'">Ghana</xsl:when>
      <xsl:when test="$countryCode = 'GI'">Gibraltar</xsl:when>
      <xsl:when test="$countryCode = 'GL'">Greenland</xsl:when>
      <xsl:when test="$countryCode = 'GM'">Gambia</xsl:when>
      <xsl:when test="$countryCode = 'GN'">Guinea</xsl:when>
      <xsl:when test="$countryCode = 'GP'">Guadeloupe</xsl:when>
      <xsl:when test="$countryCode = 'GQ'">Equatorial Guinea</xsl:when>
      <xsl:when test="$countryCode = 'GR'">Greece</xsl:when>
      <xsl:when test="$countryCode = 'GS'">South Georgia and the South Sandwich Islands</xsl:when>
      <xsl:when test="$countryCode = 'GT'">Guatemala</xsl:when>
      <xsl:when test="$countryCode = 'GU'">Guam</xsl:when>
      <xsl:when test="$countryCode = 'GW'">Guinea-Bissau</xsl:when>
      <xsl:when test="$countryCode = 'GY'">Guyana</xsl:when>
      <xsl:when test="$countryCode = 'HK'">Hong Kong</xsl:when>
      <xsl:when test="$countryCode = 'HM'">Heard Island and McDonald Islands</xsl:when>
      <xsl:when test="$countryCode = 'HN'">Honduras</xsl:when>
      <xsl:when test="$countryCode = 'HR'">Croatia</xsl:when>
      <xsl:when test="$countryCode = 'HT'">Haiti</xsl:when>
      <xsl:when test="$countryCode = 'HU'">Hungary</xsl:when>
      <xsl:when test="$countryCode = 'ID'">Indonesia</xsl:when>
      <xsl:when test="$countryCode = 'IE'">Ireland</xsl:when>
      <xsl:when test="$countryCode = 'IL'">Israel</xsl:when>
      <xsl:when test="$countryCode = 'IM'">Isle of Man</xsl:when>
      <xsl:when test="$countryCode = 'IN'">India</xsl:when>
      <xsl:when test="$countryCode = 'IO'">British Indian Ocean Territory</xsl:when>
      <xsl:when test="$countryCode = 'IQ'">Iraq</xsl:when>
      <xsl:when test="$countryCode = 'IR'">Iran</xsl:when>
      <xsl:when test="$countryCode = 'IS'">Iceland</xsl:when>
      <xsl:when test="$countryCode = 'IT'">Italy</xsl:when>
      <xsl:when test="$countryCode = 'JE'">Jersey</xsl:when>
      <xsl:when test="$countryCode = 'JM'">Jamaica</xsl:when>
      <xsl:when test="$countryCode = 'JO'">Jordan</xsl:when>
      <xsl:when test="$countryCode = 'JP'">Japan</xsl:when>
      <xsl:when test="$countryCode = 'KE'">Kenya</xsl:when>
      <xsl:when test="$countryCode = 'KG'">Kyrgyzstan</xsl:when>
      <xsl:when test="$countryCode = 'KH'">Cambodia</xsl:when>
      <xsl:when test="$countryCode = 'KI'">Kiribati</xsl:when>
      <xsl:when test="$countryCode = 'KM'">Comoros</xsl:when>
      <xsl:when test="$countryCode = 'KN'">Saint Kitts and Nevis</xsl:when>
      <xsl:when test="$countryCode = 'KP'">North Korea</xsl:when>
      <xsl:when test="$countryCode = 'KR'">South Korea</xsl:when>
      <xsl:when test="$countryCode = 'KW'">Kuwait</xsl:when>
      <xsl:when test="$countryCode = 'KY'">Cayman Islands</xsl:when>
      <xsl:when test="$countryCode = 'KZ'">Kazakhstan</xsl:when>
      <xsl:when test="$countryCode = 'LA'">Laos</xsl:when>
      <xsl:when test="$countryCode = 'LB'">Lebanon</xsl:when>
      <xsl:when test="$countryCode = 'LC'">Saint Lucia</xsl:when>
      <xsl:when test="$countryCode = 'LI'">Liechtenstein</xsl:when>
      <xsl:when test="$countryCode = 'LK'">Sri Lanka</xsl:when>
      <xsl:when test="$countryCode = 'LR'">Liberia</xsl:when>
      <xsl:when test="$countryCode = 'LS'">Lesotho</xsl:when>
      <xsl:when test="$countryCode = 'LT'">Lithuania</xsl:when>
      <xsl:when test="$countryCode = 'LU'">Luxembourg</xsl:when>
      <xsl:when test="$countryCode = 'LV'">Latvia</xsl:when>
      <xsl:when test="$countryCode = 'LY'">Libya</xsl:when>
      <xsl:when test="$countryCode = 'MA'">Morocco</xsl:when>
      <xsl:when test="$countryCode = 'MC'">Monaco</xsl:when>
      <xsl:when test="$countryCode = 'MD'">Moldova</xsl:when>
      <xsl:when test="$countryCode = 'ME'">Montenegro</xsl:when>
      <xsl:when test="$countryCode = 'MF'">Saint Martin</xsl:when>
      <xsl:when test="$countryCode = 'MG'">Madagascar</xsl:when>
      <xsl:when test="$countryCode = 'MH'">Marshall Islands</xsl:when>
      <xsl:when test="$countryCode = 'MK'">North Macedonia</xsl:when>
      <xsl:when test="$countryCode = 'ML'">Mali</xsl:when>
      <xsl:when test="$countryCode = 'MM'">Myanmar</xsl:when>
      <xsl:when test="$countryCode = 'MN'">Mongolia</xsl:when>
      <xsl:when test="$countryCode = 'MO'">Macao</xsl:when>
      <xsl:when test="$countryCode = 'MP'">Northern Mariana Islands</xsl:when>
      <xsl:when test="$countryCode = 'MQ'">Martinique</xsl:when>
      <xsl:when test="$countryCode = 'MR'">Mauritania</xsl:when>
      <xsl:when test="$countryCode = 'MS'">Montserrat</xsl:when>
      <xsl:when test="$countryCode = 'MT'">Malta</xsl:when>
      <xsl:when test="$countryCode = 'MU'">Mauritius</xsl:when>
      <xsl:when test="$countryCode = 'MV'">Maldives</xsl:when>
      <xsl:when test="$countryCode = 'MW'">Malawi</xsl:when>
      <xsl:when test="$countryCode = 'MX'">Mexico</xsl:when>
      <xsl:when test="$countryCode = 'MY'">Malaysia</xsl:when>
      <xsl:when test="$countryCode = 'MZ'">Mozambique</xsl:when>
      <xsl:when test="$countryCode = 'NA'">Namibia</xsl:when>
      <xsl:when test="$countryCode = 'NC'">New Caledonia</xsl:when>
      <xsl:when test="$countryCode = 'NE'">Niger</xsl:when>
      <xsl:when test="$countryCode = 'NF'">Norfolk Island</xsl:when>
      <xsl:when test="$countryCode = 'NG'">Nigeria</xsl:when>
      <xsl:when test="$countryCode = 'NI'">Nicaragua</xsl:when>
      <xsl:when test="$countryCode = 'NL'">Netherlands</xsl:when>
      <xsl:when test="$countryCode = 'NO'">Norway</xsl:when>
      <xsl:when test="$countryCode = 'NP'">Nepal</xsl:when>
      <xsl:when test="$countryCode = 'NR'">Nauru</xsl:when>
      <xsl:when test="$countryCode = 'NU'">Niue</xsl:when>
      <xsl:when test="$countryCode = 'NZ'">New Zealand</xsl:when>
      <xsl:when test="$countryCode = 'OM'">Oman</xsl:when>
      <xsl:when test="$countryCode = 'PA'">Panama</xsl:when>
      <xsl:when test="$countryCode = 'PE'">Peru</xsl:when>
      <xsl:when test="$countryCode = 'PF'">French Polynesia</xsl:when>
      <xsl:when test="$countryCode = 'PG'">Papua New Guinea</xsl:when>
      <xsl:when test="$countryCode = 'PH'">Philippines</xsl:when>
      <xsl:when test="$countryCode = 'PK'">Pakistan</xsl:when>
      <xsl:when test="$countryCode = 'PL'">Poland</xsl:when>
      <xsl:when test="$countryCode = 'PM'">Saint Pierre and Miquelon</xsl:when>
      <xsl:when test="$countryCode = 'PN'">Pitcairn Islands</xsl:when>
      <xsl:when test="$countryCode = 'PR'">Puerto Rico</xsl:when>
      <xsl:when test="$countryCode = 'PS'">Palestine</xsl:when>
      <xsl:when test="$countryCode = 'PT'">Portugal</xsl:when>
      <xsl:when test="$countryCode = 'PW'">Palau</xsl:when>
      <xsl:when test="$countryCode = 'PY'">Paraguay</xsl:when>
      <xsl:when test="$countryCode = 'QA'">Qatar</xsl:when>
      <xsl:when test="$countryCode = 'RE'">Réunion</xsl:when>
      <xsl:when test="$countryCode = 'RO'">Romania</xsl:when>
      <xsl:when test="$countryCode = 'RS'">Serbia</xsl:when>
      <xsl:when test="$countryCode = 'RU'">Russia</xsl:when>
      <xsl:when test="$countryCode = 'RW'">Rwanda</xsl:when>
      <xsl:when test="$countryCode = 'SA'">Saudi Arabia</xsl:when>
      <xsl:when test="$countryCode = 'SB'">Solomon Islands</xsl:when>
      <xsl:when test="$countryCode = 'SC'">Seychelles</xsl:when>
      <xsl:when test="$countryCode = 'SD'">Sudan</xsl:when>
      <xsl:when test="$countryCode = 'SE'">Sweden</xsl:when>
      <xsl:when test="$countryCode = 'SG'">Singapore</xsl:when>
      <xsl:when test="$countryCode = 'SH'">Saint Helena, Ascension and Tristan da Cunha</xsl:when>
      <xsl:when test="$countryCode = 'SI'">Slovenia</xsl:when>
      <xsl:when test="$countryCode = 'SJ'">Svalbard and Jan Mayen</xsl:when>
      <xsl:when test="$countryCode = 'SK'">Slovakia</xsl:when>
      <xsl:when test="$countryCode = 'SL'">Sierra Leone</xsl:when>
      <xsl:when test="$countryCode = 'SM'">San Marino</xsl:when>
      <xsl:when test="$countryCode = 'SN'">Senegal</xsl:when>
      <xsl:when test="$countryCode = 'SO'">Somalia</xsl:when>
      <xsl:when test="$countryCode = 'SR'">Suriname</xsl:when>
      <xsl:when test="$countryCode = 'SS'">South Sudan</xsl:when>
      <xsl:when test="$countryCode = 'ST'">São Tomé and Príncipe</xsl:when>
      <xsl:when test="$countryCode = 'SV'">El Salvador</xsl:when>
      <xsl:when test="$countryCode = 'SX'">Sint Maarten</xsl:when>
      <xsl:when test="$countryCode = 'SY'">Syria</xsl:when>
      <xsl:when test="$countryCode = 'SZ'">Eswatini</xsl:when>
      <xsl:when test="$countryCode = 'TC'">Turks and Caicos Islands</xsl:when>
      <xsl:when test="$countryCode = 'TD'">Chad</xsl:when>
      <xsl:when test="$countryCode = 'TF'">French Southern Territories</xsl:when>
      <xsl:when test="$countryCode = 'TG'">Togo</xsl:when>
      <xsl:when test="$countryCode = 'TH'">Thailand</xsl:when>
      <xsl:when test="$countryCode = 'TJ'">Tajikistan</xsl:when>
      <xsl:when test="$countryCode = 'TK'">Tokelau</xsl:when>
      <xsl:when test="$countryCode = 'TL'">Timor-Leste</xsl:when>
      <xsl:when test="$countryCode = 'TM'">Turkmenistan</xsl:when>
      <xsl:when test="$countryCode = 'TN'">Tunisia</xsl:when>
      <xsl:when test="$countryCode = 'TO'">Tonga</xsl:when>
      <xsl:when test="$countryCode = 'TR'">Turkey</xsl:when>
      <xsl:when test="$countryCode = 'TT'">Trinidad and Tobago</xsl:when>
      <xsl:when test="$countryCode = 'TV'">Tuvalu</xsl:when>
      <xsl:when test="$countryCode = 'TW'">Taiwan</xsl:when>
      <xsl:when test="$countryCode = 'TZ'">Tanzania</xsl:when>
      <xsl:when test="$countryCode = 'UA'">Ukraine</xsl:when>
      <xsl:when test="$countryCode = 'UG'">Uganda</xsl:when>
      <xsl:when test="$countryCode = 'UM'">U.S. Minor Outlying Islands</xsl:when>
      <xsl:when test="$countryCode = 'US'">United States</xsl:when>
      <xsl:when test="$countryCode = 'UY'">Uruguay</xsl:when>
      <xsl:when test="$countryCode = 'UZ'">Uzbekistan</xsl:when>
      <xsl:when test="$countryCode = 'VA'">Vatican City</xsl:when>
      <xsl:when test="$countryCode = 'VC'">Saint Vincent and the Grenadines</xsl:when>
      <xsl:when test="$countryCode = 'VE'">Venezuela</xsl:when>
      <xsl:when test="$countryCode = 'VG'">British Virgin Islands</xsl:when>
      <xsl:when test="$countryCode = 'VI'">U.S. Virgin Islands</xsl:when>
      <xsl:when test="$countryCode = 'VN'">Vietnam</xsl:when>
      <xsl:when test="$countryCode = 'VU'">Vanuatu</xsl:when>
      <xsl:when test="$countryCode = 'WF'">Wallis and Futuna</xsl:when>
      <xsl:when test="$countryCode = 'WS'">Samoa</xsl:when>
      <xsl:when test="$countryCode = 'YE'">Yemen</xsl:when>
      <xsl:when test="$countryCode = 'YT'">Mayotte</xsl:when>
      <xsl:when test="$countryCode = 'ZA'">South Africa</xsl:when>
      <xsl:when test="$countryCode = 'ZM'">Zambia</xsl:when>
      <xsl:when test="$countryCode = 'ZW'">Zimbabwe</xsl:when>
      <xsl:otherwise><xsl:value-of select="$countryCode" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="StateProvinceLabel">
    <xsl:param name="countryCode" />
    <xsl:choose>
      <xsl:when test="$countryCode = 'CA'">Province</xsl:when>
      <xsl:when test="$countryCode = 'US'">State</xsl:when>
      <xsl:when test="$countryCode = 'AU'">State</xsl:when>
      <xsl:when test="$countryCode = 'DE'">Land</xsl:when>
      <xsl:when test="$countryCode = 'FR'">Région</xsl:when>
      <xsl:when test="$countryCode = 'GB'">County</xsl:when>
      <xsl:when test="$countryCode = 'CH'">Canton</xsl:when>
      <xsl:when test="$countryCode = 'CN'">Province</xsl:when>
      <xsl:when test="$countryCode = 'IN'">State</xsl:when>
      <xsl:when test="$countryCode = 'BR'">State</xsl:when>
      <xsl:when test="$countryCode = 'MX'">State</xsl:when>
      <xsl:when test="$countryCode = 'JP'">Prefecture</xsl:when>
      <xsl:otherwise>State/Province</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="FormatAddress">
    <xsl:param name="party" />
    <xsl:variable name="countryCode" select="$party/Country" />

    <xsl:choose>
      <!-- United States & Canada: Street / City, State ZIP / Country -->
      <xsl:when test="$countryCode = 'US' or $countryCode = 'CA'">
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <fo:block>
          <xsl:value-of select="$party/City" />
          <xsl:if test="$party/State">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$party/State" />
          </xsl:if>
          <xsl:if test="$party/ZipCode">
            <xsl:text>  </xsl:text>
            <xsl:value-of select="$party/ZipCode" />
          </xsl:if>
        </fo:block>
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
      </xsl:when>

      <!-- Japan: 〒ZIP / Prefecture City / Street / Country -->
      <xsl:when test="$countryCode = 'JP'">
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:text>〒</xsl:text><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <fo:block>
          <xsl:if test="$party/State"><xsl:value-of select="$party/State" /><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="$party/City"><xsl:value-of select="$party/City" /></xsl:if>
        </fo:block>
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
      </xsl:when>

      <!-- China: Country / ZIP / Province City / Street -->
      <xsl:when test="$countryCode = 'CN'">
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <fo:block>
          <xsl:if test="$party/State"><xsl:value-of select="$party/State" /><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="$party/City"><xsl:value-of select="$party/City" /></xsl:if>
        </fo:block>
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
      </xsl:when>

      <!-- UK: Street / City / POSTCODE / Country -->
      <xsl:when test="$countryCode = 'GB'">
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <xsl:if test="$party/City">
          <fo:block><xsl:value-of select="$party/City" /></fo:block>
        </xsl:if>
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
      </xsl:when>

      <!-- EU Countries (DE, FR, IT, ES, AT, BE, NL, CH, SE, NO, etc.): Street / ZIP City / Country -->
      <xsl:when test="$countryCode = 'DE' or $countryCode = 'FR' or $countryCode = 'IT' or
                      $countryCode = 'ES' or $countryCode = 'AT' or $countryCode = 'BE' or
                      $countryCode = 'NL' or $countryCode = 'CH' or $countryCode = 'SE' or
                      $countryCode = 'NO' or $countryCode = 'FI' or $countryCode = 'PL'">
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <fo:block>
          <xsl:if test="$party/ZipCode">
            <xsl:value-of select="$party/ZipCode" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
        </fo:block>
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
      </xsl:when>

      <!-- Default/Fallback Format -->
      <xsl:otherwise>
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <fo:block>
          <xsl:if test="$party/ZipCode">
            <xsl:value-of select="$party/ZipCode" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:value-of select="$party/City" />
          </xsl:if>
        </fo:block>
        <xsl:if test="$party/State">
          <fo:block><xsl:value-of select="$party/State" /></fo:block>
        </xsl:if>
        <fo:block>
          <xsl:call-template name="CountryName">
            <xsl:with-param name="countryCode" select="$countryCode" />
          </xsl:call-template>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>