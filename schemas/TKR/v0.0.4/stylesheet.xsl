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
      <fo:page-sequence master-reference="simple" id="last-page">
        <!-- Page number -->
        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-size="8pt" text-align="center" margin-right="1cm" font-family="NotoSans">
            <fo:page-number />
/            <fo:page-number-citation-last ref-id="last-page" />
          </fo:block>
        </fo:static-content>
        <!-- Body -->
        <fo:flow flow-name="xsl-region-body" font-family="NotoSans">
          <!-- Global variables -->
          <xsl:variable name="cellPaddingBottom" select="'6pt'" />
          <xsl:variable name="partyPaddingBottom" select="'4pt'" />

          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="CommercialTransaction" select="Root/Certificate/CommercialTransaction" />
          <xsl:variable name="ProductDescription" select="Root/Certificate/ProductDescription" />
          <xsl:variable name="MaterialIdentifiers" select="Root/Certificate/MaterialIdentifiers" />
          <xsl:variable name="Inspection" select="Root/Certificate/Inspection" />
          <xsl:variable name="ChemicalComposition" select="Root/Certificate/ChemicalComposition" />
          <xsl:variable name="Validation" select="Root/Certificate/Validation" />
          <fo:block font-size="8pt">
            <!-- Parties -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="33%" />
              <fo:table-column column-width="33%" />
              <fo:table-column column-width="33%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block padding-bottom="{$partyPaddingBottom}" font-style="italic"> A04 <xsl:value-of select="$i18n/Certificate/A04" />
                    </fo:block>
                    <fo:block>
                      <fo:external-graphic fox:alt-text="Company Logo" src="{$CommercialTransaction/A04}" content-height="48px" height="48px" />
                    </fo:block>
                  </fo:table-cell>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="number" select="'A01 '" />
                    <xsl:with-param name="title" select="$i18n/Certificate/A01" />
                    <xsl:with-param name="party" select="$CommercialTransaction/A01" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                  <xsl:choose>
                    <xsl:when test="exists($CommercialTransaction/A06)">
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="number" select="'A06 '" />
                        <xsl:with-param name="title" select="$i18n/Certificate/A06" />
                        <xsl:with-param name="party" select="$CommercialTransaction/A06" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="number" select="'A06.1 '" />
                        <xsl:with-param name="title" select="$i18n/Certificate/A06.1" />
                        <xsl:with-param name="party" select="$CommercialTransaction/A06.1" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <xsl:if test="count($CommercialTransaction/A06.2) + count($CommercialTransaction/A06.3) > 0">
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="33%" />
                <fo:table-column column-width="33%" />
                <fo:table-column column-width="33%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:for-each select="2 to 3">
                      <xsl:variable name="index" select="." />
                      <xsl:variable name="elementName" select="concat('A06.', $index)" />
                      <xsl:if test="exists($CommercialTransaction/*[name() = $elementName])">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="number" select="concat('A06.', $index, ' ')" />
                          <xsl:with-param name="title" select="$i18n/Certificate/*[name() = $elementName]" />
                          <xsl:with-param name="party" select="$CommercialTransaction/*[name() = $elementName]" />
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Commercial Transaction -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/CommercialTransaction" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:for-each select="$CommercialTransaction/*">
                  <xsl:if test="starts-with(local-name(), 'A') and not(local-name() = 'A01' or local-name() = 'A04' or starts-with(local-name(), 'A06') or local-name() = 'A10')">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="." />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </xsl:for-each>
              </fo:table-body>
            </fo:table>
            <xsl:if test="$CommercialTransaction/A10/*">
              <xsl:call-template name="SectionSubTitle">
                <xsl:with-param name="subtitle" select="concat('A10 ', $i18n/Certificate/A10)" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="$CommercialTransaction/A10/*">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="''" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="." />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <!-- Pass the type as a parameter -->
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Product Description -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/ProductDescription" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:for-each select="$ProductDescription/*[starts-with(local-name(), 'B')]">
                  <fo:table-row>
                    <xsl:choose>
                      <xsl:when test="local-name() = 'B13.1' or local-name() = 'B13.2'">
                        <xsl:variable name="concatenatedValue">
                          <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                        </xsl:variable>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                          <xsl:with-param name="value" select="$concatenatedValue" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                          <xsl:with-param name="value" select="." />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-row>
                </xsl:for-each>
              </fo:table-body>
            </fo:table>
            <xsl:if test="$ProductDescription/SupplementaryInformation/*">
              <xsl:call-template name="SectionSubTitle">
                <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="$ProductDescription/SupplementaryInformation/*">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="./Value" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Material Identifiers -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/MaterialIdentifiers" />
            </xsl:call-template>
            <xsl:call-template name="generateTable">
              <xsl:with-param name="headerCount" select="count($MaterialIdentifiers/Header)" />
              <xsl:with-param name="Section" select="$MaterialIdentifiers" />
              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
            </xsl:call-template>

            <!-- Chemical Composition -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/ChemicalComposition" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="number" select="concat('C70', ' ')" />
                    <xsl:with-param name="key" select="$i18n/Certificate/C70" />
                    <xsl:with-param name="value" select="$ChemicalComposition/C70" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <xsl:call-template name="generateTable">
              <xsl:with-param name="headerCount" select="count($ChemicalComposition/Analysis/Header)" />
              <xsl:with-param name="Section" select="$ChemicalComposition/Analysis" />
              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
            </xsl:call-template>

            <!-- Inspection -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/Inspection" />
            </xsl:call-template>
            <xsl:for-each select="$Inspection">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="Title"/>
              </xsl:call-template>
              <xsl:call-template name="generateTable">
                <xsl:with-param name="headerCount" select="count(Header)" />
                <xsl:with-param name="Section" select="." />
                <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
              </xsl:call-template>
            </xsl:for-each>

            <!--  Validation -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/Validation" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:for-each select="$Validation/*">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                      <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                      <xsl:with-param name="value" select="." />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:for-each>
              </fo:table-body>
            </fo:table>

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
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="SectionTitle">
    <xsl:param name="title" />
    <fo:block font-size="14pt" font-weight="bold" text-align="left" space-before="8pt" space-after="6pt" border-bottom="solid 1pt black">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>

  <xsl:template name="SectionSubTitle">
    <xsl:param name="subtitle" />
    <fo:block font-weight="bold" text-align="left" space-before="12pt" space-after="6pt">
      <xsl:value-of select="$subtitle" />
    </fo:block>
  </xsl:template>

  <xsl:template name="SectionTitleSmall">
    <xsl:param name="title" />
    <fo:block font-size="10pt" font-weight="bold" text-align="left" space-before="8pt" space-after="6pt" border-bottom="solid 0.8pt black">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>

  <xsl:template name="KeyValue">
    <xsl:param name="number" />
    <xsl:param name="key" />
    <xsl:param name="value" />
    <xsl:param name="type" select="'default'" />
    <xsl:param name="paddingBottom" select="'default'" />
    <fo:table-cell padding-bottom="{$paddingBottom}">
      <fo:block font-style="italic">
        <xsl:value-of select="$number" />
        <xsl:value-of select="$key" />
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block>
        <xsl:choose>
          <xsl:when test="$type = 'date-time'">
            <xsl:value-of select="concat(substring($value, 6, 2), '/', substring($value, 9, 2), '/', substring($value, 1, 4))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$value" />
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="PartyInfo">
    <xsl:param name="number" />
    <xsl:param name="title" />
    <xsl:param name="party" />
    <xsl:param name="paddingBottom" />
    <fo:table-cell>
      <fo:block padding-bottom="{$paddingBottom}" font-style="italic">
        <xsl:value-of select="$number" />
        <xsl:value-of select="$title" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="$party/CompanyName" />
      </fo:block>
      <fo:block>
        <xsl:for-each select="$party/Street">
          <fo:block>
            <xsl:value-of select="." />
          </fo:block>
        </xsl:for-each>
      </fo:block>
      <fo:block>
        <xsl:value-of select="concat($party/City, ' ', $party/ZipCode, ', ', $party/Country)" />
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

  <xsl:template name="generateTable">
    <xsl:param name="headerCount" />
    <xsl:param name="Section" />
    <xsl:param name="paddingBottom" />

    <fo:table table-layout="fixed" width="100%">
      <!-- Dynamically generate table columns based on the number of headers -->
      <xsl:for-each select="$Section/Header">
        <fo:table-column column-width="{100 div $headerCount}%"/>
      </xsl:for-each>
      <fo:table-body>
        <!-- Header -->
        <fo:table-row>
          <xsl:for-each select="$Section/Header">
            <fo:table-cell>
              <fo:block padding-bottom="{$paddingBottom}">
                <xsl:value-of select="." />
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>
        </fo:table-row>
        <!-- SubHeader -->
        <fo:table-row>
          <xsl:for-each select="$Section/SubHeader">
            <fo:table-cell>
              <fo:block padding-bottom="{$paddingBottom}">
                <xsl:value-of select="." />
              </fo:block>
            </fo:table-cell>
          </xsl:for-each>
        </fo:table-row>
        <!-- Rows -->
        <xsl:if test="$headerCount > 0">
          <xsl:for-each select="$Section/Rows">
            <xsl:variable name="pos" select="position()" />
            <xsl:if test="($pos - 1) mod $headerCount = 0">
              <fo:table-row>
                <xsl:for-each select=".|following-sibling::*[position() &lt; $headerCount]">
                  <fo:table-cell padding-bottom="{$paddingBottom}">
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

</xsl:stylesheet>