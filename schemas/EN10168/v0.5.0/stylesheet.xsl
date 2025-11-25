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
          <xsl:variable name="cellPaddingBottom" select="'3pt'" />
          <xsl:variable name="partyPaddingBottom" select="'4pt'" />
          <xsl:variable name="cellPaddingBottomChemical" select="'1pt'" />

          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="CommercialTransaction" select="Root/Certificate/CommercialTransaction" />
          <xsl:variable name="ProductDescription" select="Root/Certificate/ProductDescription" />
          <xsl:variable name="Inspection" select="Root/Certificate/Inspection" />
          <xsl:variable name="OtherTests" select="Root/Certificate/OtherTests" />
          <xsl:variable name="Validation" select="Root/Certificate/Validation" />
          <xsl:variable name="Attachments" select="Root/Certificate/Attachments" />
          <xsl:variable name="documentLanguage" select="Root/Certificate/CertificateLanguages[1]" />
          <fo:block font-size="8pt">
            <!-- Parties -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="33%" />
              <fo:table-column column-width="33%" />
              <fo:table-column column-width="33%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell padding-bottom="{$partyPaddingBottom}">
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

            <xsl:if test="count($CommercialTransaction/A06.2) + count($CommercialTransaction/A06.3) + count($CommercialTransaction/A06.4)> 0">
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="33%" />
                <fo:table-column column-width="33%" />
                <fo:table-column column-width="33%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:for-each select="2 to 4">
                      <xsl:variable name="index" select="." />
                      <xsl:variable name="elementName" select="concat('A06.', $index)" />
                      <xsl:if test="exists($CommercialTransaction/*[name() = $elementName])">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="number" select="concat('A06.', $index, ' ')" />
                          <xsl:with-param name="title" select="$i18n/Certificate/*[name() = $elementName]" />
                          <xsl:with-param name="party" select="$CommercialTransaction/*[name() = $elementName]" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
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
                  <xsl:if test="starts-with(local-name(), 'A') and not(local-name() = 'A01' or local-name() = 'A04' or starts-with(local-name(), 'A06'))">
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
            <xsl:if test="$CommercialTransaction/SupplementaryInformation/*">
              <xsl:call-template name="SectionSubTitle">
                <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="$CommercialTransaction/SupplementaryInformation/*">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="./Value" />
                        <xsl:with-param name="type" select="./Type" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <xsl:with-param name="language" select="$documentLanguage" />
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
                  <xsl:choose>
                    <xsl:when test="local-name() = 'B02'">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                      <xsl:for-each select="$ProductDescription/B02/*">
                        <!-- Process only the first occurrence of each key -->
                        <xsl:if test="not(preceding-sibling::*[local-name() = local-name(current())])">
                          <fo:table-row>
                            <xsl:call-template name="KeyValueSmall">
                              <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                              <xsl:with-param name="value">
                                <!-- Concatenate values for the current key -->
                                <xsl:for-each select="../*[local-name() = local-name(current())]">
                                  <xsl:value-of select="." />
                                  <xsl:if test="position() != last()">, </xsl:if>
                                </xsl:for-each>
                              </xsl:with-param>
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                      </xsl:for-each>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                          <fo:block></fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:when>
                    <!-- Solution for correctly handling B07 array -->
                    <xsl:when test="local-name() = 'B07'">
                      <!-- Skip all but the first occurrence of B07 -->
                      <xsl:if test="count(preceding-sibling::B07) = 0">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottom}" padding-right="4pt">
                            <fo:block font-style="italic">
                              <xsl:text>B07 </xsl:text>
                              <xsl:value-of select="$i18n/Certificate/B07" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                            <fo:block>
                              <!-- Collect all B07 values -->
                              <xsl:for-each select="$ProductDescription/B07">
                                <xsl:value-of select="." />
                                <xsl:if test="position() != last()">, </xsl:if>
                              </xsl:for-each>
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="local-name() = 'B09'">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>

                      <!-- Capture the unit value -->
                      <xsl:variable name="unitValue" select="$ProductDescription/B09/Unit" />
                      <xsl:for-each select="$ProductDescription/B09/*[local-name() != 'Unit']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValueSmall">
                            <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            <xsl:with-param name="value">
                              <xsl:choose>
                                <xsl:when test="local-name() = 'Form'">
                                  <xsl:value-of select="$i18n/Certificate/*[local-name() = current()]" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:for-each select=".">
                                    <xsl:value-of select="." />
                                    <xsl:if test="position() != last()">, </xsl:if>
                                  </xsl:for-each>
                                  <xsl:if test="local-name() != 'Form' and $unitValue">
                                    <xsl:value-of select="concat(' ', $unitValue)" />
                                  </xsl:if>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:with-param>
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                          <fo:block></fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:table-row>
                        <xsl:choose>
                          <xsl:when test="local-name() = 'B10' or local-name() = 'B11' or local-name() = 'B12' or local-name() = 'B13'">
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
                    </xsl:otherwise>
                  </xsl:choose>
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
                      <xsl:variable name="concatenatedValue">
                        <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                      </xsl:variable>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="Key" />
                        <xsl:with-param name="value" select="$concatenatedValue" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <xsl:with-param name="language" select="$documentLanguage" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Inspections -->
            <!-- loop through Inspections Array-->
            <xsl:for-each select="$Inspection">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/Inspection" />
              </xsl:call-template>

              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="*[starts-with(local-name(), 'C0') or local-name() = 'C10']">
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
              <xsl:if test="$Inspection/SupplementaryInformation">
                <xsl:call-template name="SectionSubTitle">
                  <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <xsl:for-each select="SupplementaryInformation/*[substring(local-name(), 2) &gt;= '04' and substring(local-name(), 2) &lt;= '09']">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="./Key" />
                          <xsl:with-param name="value" select="./Value" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          <xsl:with-param name="language" select="$documentLanguage" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
              <xsl:if test="TensileTest">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/TensileTest" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <xsl:for-each select="TensileTest/*[local-name() = 'C11' or local-name() = 'C12' or local-name() = 'C13']">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="concat($i18n/Certificate/*[local-name() = local-name(current())], ' ', ./Property)" />
                          <xsl:with-param name="value" select="concat(./Value, ' ', ./Unit)" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
                <xsl:if test="TensileTest/SupplementaryInformation">
                  <xsl:call-template name="SectionSubTitle">
                    <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
                  </xsl:call-template>
                  <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-body>
                      <xsl:for-each select="TensileTest/SupplementaryInformation/*[substring(local-name(), 2) &gt;= '14' and substring(local-name(), 2) &lt;= '29']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                            <xsl:with-param name="key" select="./Key" />
                            <xsl:with-param name="value" select="./Value" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            <xsl:with-param name="language" select="$documentLanguage" />
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
              </xsl:if>

              <xsl:if test="HardnessTest">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/HardnessTest" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat('C30', ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/C30" />
                        <xsl:with-param name="value" select="HardnessTest/C30" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat('C31', ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/C31" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <xsl:with-param name="value">
                          <xsl:for-each select="HardnessTest/C31">
                            <xsl:value-of select="Value" />
                            <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:text></xsl:text>
                          </xsl:for-each>
                          <xsl:value-of select="HardnessTest/C31[1]/Unit" />
                        </xsl:with-param>
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-style="italic">
                          <xsl:value-of select="concat('C32', ' ', $i18n/Certificate/C32)" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <fo:table table-layout="fixed" width="100%">
                            <fo:table-column column-width="33.33%" />
                            <fo:table-column column-width="33.33%" />
                            <fo:table-column column-width="33.33%" />
                            <fo:table-body>
                              <fo:table-row>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat(HardnessTest/C32/Value, ' ', HardnessTest/C32/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat('min ', HardnessTest/C32/Minimum, ' ', HardnessTest/C32/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat('max ', HardnessTest/C32/Maximum, ' ', HardnessTest/C32/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </fo:table-body>
                          </fo:table>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <xsl:if test="HardnessTest/SupplementaryInformation">
                  <xsl:call-template name="SectionSubTitle">
                    <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
                  </xsl:call-template>
                  <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-body>
                      <xsl:for-each select="HardnessTest/SupplementaryInformation/*[substring(local-name(), 2) &gt;= '33' and substring(local-name(), 2) &lt;= '39']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                            <xsl:with-param name="key" select="./Key" />
                            <xsl:with-param name="value" select="./Value" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            <xsl:with-param name="language" select="$documentLanguage" />
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>

              </xsl:if>

              <xsl:if test="NotchedBarImpactTest">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/NotchedBarImpactTest" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat('C40', ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/C40" />
                        <xsl:with-param name="value" select="NotchedBarImpactTest/C40" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat('C41', ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/C41" />
                        <xsl:with-param name="value" select="concat(NotchedBarImpactTest/C41/Value, ' ', NotchedBarImpactTest/C41/Unit)" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat('C42', ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/C42" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <xsl:with-param name="value">
                          <xsl:for-each select="NotchedBarImpactTest/C42">
                            <xsl:value-of select="Value" />
                            <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:text></xsl:text>
                          </xsl:for-each>
                          <xsl:value-of select="NotchedBarImpactTest/C42[1]/Unit" />
                        </xsl:with-param>
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-style="italic">
                          <xsl:value-of select="concat('C43', ' ', $i18n/Certificate/C43)" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <fo:table table-layout="fixed" width="100%">
                            <fo:table-column column-width="33.33%" />
                            <fo:table-column column-width="33.33%" />
                            <fo:table-column column-width="33.33%" />
                            <fo:table-body>
                              <fo:table-row>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat(NotchedBarImpactTest/C43/Value, ' ', NotchedBarImpactTest/C43/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat('min ', NotchedBarImpactTest/C43/Minimum, ' ', NotchedBarImpactTest/C43/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                  <fo:block>
                                    <xsl:value-of select="concat('max ', NotchedBarImpactTest/C43/Maximum, ' ', NotchedBarImpactTest/C43/Unit)" />
                                  </fo:block>
                                </fo:table-cell>
                              </fo:table-row>
                            </fo:table-body>
                          </fo:table>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <xsl:if test="NotchedBarImpactTest/SupplementaryInformation">
                  <xsl:call-template name="SectionSubTitle">
                    <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
                  </xsl:call-template>
                  <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-body>
                      <xsl:for-each select="NotchedBarImpactTest/SupplementaryInformation/*[substring(local-name(), 2) &gt;= '44' and substring(local-name(), 2) &lt;= '49']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                            <xsl:with-param name="key" select="./Key" />
                            <xsl:with-param name="value" select="./Value" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            <xsl:with-param name="language" select="$documentLanguage" />
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
              </xsl:if>

              <xsl:if test="OtherMechanicalTests">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/OtherMechanicalTests" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-body>
                    <xsl:for-each select="OtherMechanicalTests/*[substring(local-name(), 2) &gt;= '50' and substring(local-name(), 2) &lt;= '69']">
                      <fo:table-row>
                        <fo:table-cell>
                          <fo:block font-style="italic" padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(local-name(), ' ', ./Key)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Interpretation" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Method" />
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>

              <!-- Check for one of keys: ChemicalComposition, TensileTest, HardnessTest,
                NotchedBarImpactTest, OtherMechanicalTests  -->

              <xsl:if test="ChemicalComposition">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/ChemicalComposition" />
                </xsl:call-template>
                <xsl:if test="ChemicalComposition/C70">
                  <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-body>
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat('C70', ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/C70" />
                          <xsl:with-param name="value" select="ChemicalComposition/C70" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
                <xsl:variable name="keys" select="ChemicalComposition/*[not(name() = 'SupplementaryInformation' or name() = 'C70')]" />
                <xsl:variable name="columnCount" select="count($keys)" />
                <xsl:variable name="maxColumns" select="13" />

                <!-- First table -->
                <xsl:variable name="keys1" select="subsequence($keys, 1, $maxColumns)" />
                <fo:table table-layout="fixed" width="100%" keep-together="always">
                  <xsl:for-each select="1 to ($maxColumns + 1)">
                    <fo:table-column column-width="{100 div ($maxColumns + 1)}%" />
                  </xsl:for-each>
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                        <fo:block></fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys1">
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>
                            <xsl:value-of select="name()" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                        <fo:block>Symbol</fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys1">
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>
                            <xsl:value-of select="Symbol" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                        <fo:block>Unit</fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys1">
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>
                            <xsl:value-of select="Unit" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                    <xsl:if test="count($keys1[Minimum != '']) &gt; 0">
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Min</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys1">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Minimum/Operator" />
                              <xsl:text></xsl:text>
                              <xsl:value-of select="Minimum/Value" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                    </xsl:if>
                    <xsl:if test="count($keys1[Maximum != '']) &gt; 0">
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Max</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys1">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Maximum/Operator" />
                              <xsl:text></xsl:text>
                              <xsl:value-of select="Maximum/Value" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                    </xsl:if>
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                        <fo:block>Actual</fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys1">
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>
                            <xsl:value-of select="Actual/Operator" />
                            <xsl:text></xsl:text>
                            <xsl:value-of select="Actual/Value" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>

                <!-- Second table (if applicable)-->
                <xsl:variable name="keys2" select="subsequence($keys, $maxColumns + 1, $maxColumns)" />
                <xsl:if test="$columnCount &gt; $maxColumns">
                  <fo:table table-layout="fixed" width="100%" margin-top="10pt" keep-together="always">
                    <xsl:for-each select="1 to ($maxColumns + 1)">
                      <fo:table-column column-width="{100 div ($maxColumns + 1)}%" />
                    </xsl:for-each>
                    <fo:table-body>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block></fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys2">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="name()" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Symbol</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys2">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Symbol" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Unit</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys2">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Unit" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <xsl:if test="count($keys2[Minimum != '']) &gt; 0">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>Min</fo:block>
                          </fo:table-cell>
                          <xsl:for-each select="$keys2">
                            <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                              <fo:block>
                                <xsl:value-of select="Minimum/Operator" />
                                <xsl:text></xsl:text>
                                <xsl:value-of select="Minimum/Value" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                      </xsl:if>
                      <xsl:if test="count($keys2[Maximum != '']) &gt; 0">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>Max</fo:block>
                          </fo:table-cell>
                          <xsl:for-each select="$keys2">
                            <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                              <fo:block>
                                <xsl:value-of select="Maximum/Operator" />
                                <xsl:text></xsl:text>
                                <xsl:value-of select="Maximum/Value" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                      </xsl:if>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Actual</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys2">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Actual/Operator" />
                              <xsl:text></xsl:text>
                              <xsl:value-of select="Actual/Value" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
                <!-- Third table (if applicable)-->
                <xsl:if test="$columnCount &gt; $maxColumns*2">
                  <xsl:variable name="keys3" select="subsequence($keys, 2*$maxColumns + 1, $maxColumns)" />
                  <fo:table table-layout="fixed" width="100%" margin-top="10pt" keep-together="always">
                    <xsl:for-each select="1 to ($maxColumns + 1)">
                      <fo:table-column column-width="{100 div ($maxColumns + 1)}%" />
                    </xsl:for-each>
                    <fo:table-body>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block></fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys3">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="name()" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Symbol</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys3">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Symbol" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Unit</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys3">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Unit" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      <xsl:if test="count($keys3[Minimum != '']) &gt; 0">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>Min</fo:block>
                          </fo:table-cell>
                          <xsl:for-each select="$keys3">
                            <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                              <fo:block>
                                <xsl:value-of select="Minimum/Operator" />
                                <xsl:text></xsl:text>
                                <xsl:value-of select="Minimum/Value" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                      </xsl:if>
                      <xsl:if test="count($keys3[Maximum != '']) &gt; 0">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>Max</fo:block>
                          </fo:table-cell>
                          <xsl:for-each select="$keys3">
                            <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                              <fo:block>
                                <xsl:value-of select="Maximum/Operator" />
                                <xsl:text></xsl:text>
                                <xsl:value-of select="Maximum/Value" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:for-each>
                        </fo:table-row>
                      </xsl:if>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                          <fo:block>Actual</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$keys3">
                          <fo:table-cell padding-bottom="{$cellPaddingBottomChemical}">
                            <fo:block>
                              <xsl:value-of select="Actual/Operator" />
                              <xsl:text></xsl:text>
                              <xsl:value-of select="Actual/Value" />
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
                <!-- Chemical formulas -->
                <xsl:if test="count(ChemicalComposition/*[Formula != '']) > 0">
                  <fo:table table-layout="fixed" width="100%" keep-together="always">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-header>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="{$cellPaddingBottom}" padding-top="{$cellPaddingBottom}">
                          <fo:block font-weight="bold">Symbol</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding-bottom="{$cellPaddingBottom}" padding-top="{$cellPaddingBottom}">
                          <fo:block font-weight="bold">Formula</fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                      <xsl:for-each select="ChemicalComposition/*[Formula != '']">
                        <fo:table-row>
                          <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                            <fo:block>
                              <xsl:value-of select="Symbol" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                            <fo:block>
                              <xsl:value-of select="Formula" />
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>

                <!-- Supplementary Information -->
                <xsl:if test="ChemicalComposition/SupplementaryInformation">
                  <xsl:call-template name="SectionSubTitle">
                    <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
                  </xsl:call-template>
                  <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50%" />
                    <fo:table-column column-width="50%" />
                    <fo:table-body>
                      <xsl:for-each select="ChemicalComposition/SupplementaryInformation/*[substring(local-name(), 2) &gt;= '110' and substring(local-name(), 2) &lt;= '120']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                            <xsl:with-param name="key" select="./Key" />
                            <xsl:with-param name="value" select="./Value" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            <xsl:with-param name="language" select="$documentLanguage" />
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                    </fo:table-body>
                  </fo:table>
                </xsl:if>
              </xsl:if>

            </xsl:for-each>

            <!-- Other Tests -->
            <!-- loop through Other tests-->
            <xsl:for-each select="$OtherTests">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/OtherTests" />
              </xsl:call-template>
              <xsl:if test="$OtherTests/D01">
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <xsl:for-each select="'D01'">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat('D01', ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/D01" />
                          <xsl:with-param name="value" select="$OtherTests/D01" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
              <xsl:if test="NonDestructiveTests">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/NonDestructiveTests" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-body>
                    <xsl:for-each select="NonDestructiveTests/*[substring(local-name(), 2) &gt;= '02' and substring(local-name(), 2) &lt;= '50']">
                      <fo:table-row>
                        <fo:table-cell>
                          <fo:block font-style="italic" padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(local-name(), ' ', ./Key)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Interpretation" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Method" />
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
              <xsl:if test="OtherProductTests">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/OtherProductTests" />
                </xsl:call-template>
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-body>
                    <xsl:for-each select="OtherProductTests/*[substring(local-name(), 2) &gt;= '51' and substring(local-name(), 2) &lt;= '99 ']">
                      <fo:table-row>
                        <fo:table-cell>
                          <fo:block font-style="italic" padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(local-name(), ' ', ./Key)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Interpretation" />
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                          <fo:block padding-bottom="{$cellPaddingBottom}">
                            <xsl:value-of select="./Method" />
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
            </xsl:for-each>

            <!-- Replace the existing Validation section in the stylesheet with this code -->

            <!--  Validation -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/Validation" />
            </xsl:call-template>

            <!-- Z01 Statement of compliance -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell font-style="italic">
                    <fo:block keep-together="always">
                      <xsl:value-of select="concat('Z01', ' ', $i18n/Certificate/Z01)" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <fo:table table-layout="fixed" width="100%">
                        <xsl:if test="$Validation/Z04">
                          <fo:table-column column-width="50%" />
                          <fo:table-column column-width="50%" />
                        </xsl:if>
                        <xsl:if test="not($Validation/Z04)">
                          <fo:table-column column-width="100%" />
                        </xsl:if>
                        <fo:table-body>
                          <fo:table-row>
                            <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                              <fo:block>
                                <xsl:value-of select="$Validation/Z01" />
                              </fo:block>
                            </fo:table-cell>
                            <!-- Display CE mark if Z04 exists -->
                            <xsl:if test="$Validation/Z04">
                              <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                                <fo:block>
                                  <!-- Z04 text placed at the top -->
                                  <fo:block font-style="italic" text-align="start" margin-bottom="5pt">
                                    <xsl:text>Z04</xsl:text>
                                  </fo:block>
                                  <!-- Table for CE mark and related information -->
                                  <fo:table table-layout="fixed" width="100%">
                                    <fo:table-column column-width="100%" />
                                    <fo:table-body>
                                      <fo:table-row>
                                        <fo:table-cell text-align="center">
                                          <fo:block font-weight="bold">
                                            <fo:external-graphic fox:alt-text="CE Marking" src="{$Validation/Z04/CE_Image}" content-width="scale-to-fit" width="64px" scaling="uniform" />
                                          </fo:block>
                                        </fo:table-cell>
                                      </fo:table-row>
                                      <fo:table-row>
                                        <fo:table-cell text-align="center">
                                          <fo:block font-weight="bold">
                                            <xsl:value-of select="$Validation/Z04/NotifiedBodyNumber" />
                                          </fo:block>
                                        </fo:table-cell>
                                      </fo:table-row>
                                      <fo:table-row>
                                        <fo:table-cell text-align="center">
                                          <fo:block font-weight="bold">
                                            <xsl:value-of select="$Validation/Z04/DoCYear" />
                                          </fo:block>
                                        </fo:table-cell>
                                      </fo:table-row>
                                      <fo:table-row>
                                        <fo:table-cell text-align="center">
                                          <fo:block font-weight="bold">
                                            <xsl:value-of select="$Validation/Z04/DoCNumber" />
                                          </fo:block>
                                        </fo:table-cell>
                                      </fo:table-row>
                                    </fo:table-body>
                                  </fo:table>
                                </fo:block>
                              </fo:table-cell>
                            </xsl:if>
                          </fo:table-row>
                        </fo:table-body>
                      </fo:table>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- Z02 Date of issue and validation -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell font-style="italic" padding-bottom="{$cellPaddingBottom}">
                    <fo:block>
                      <xsl:value-of select="concat('Z02', ' ', $i18n/Certificate/Z02)" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                    <fo:block>
                      <xsl:call-template name="format-date-by-language">
                        <xsl:with-param name="date" select="xs:date($Validation/Z02)" />
                        <xsl:with-param name="language" select="$documentLanguage" />
                      </xsl:call-template>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>

            <!-- Z03 Stamp of the inspection representative -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell font-style="italic">
                    <fo:block>
                      <xsl:value-of select="concat('Z03', ' ', $i18n/Certificate/Z03)" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <fo:table table-layout="fixed" width="100%">
                        <xsl:if test="$Validation/Z03/StampImage">
                          <fo:table-column column-width="50%" />
                          <fo:table-column column-width="50%" />
                        </xsl:if>
                        <xsl:if test="not($Validation/Z03/StampImage)">
                          <fo:table-column column-width="100%" />
                        </xsl:if>
                        <fo:table-body>
                          <fo:table-row>
                            <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                              <fo:block>
                                <xsl:value-of select="$Validation/Z03/Name" />
                              </fo:block>
                              <fo:block>
                                <xsl:value-of select="$Validation/Z03/Title" />
                              </fo:block>
                            </fo:table-cell>
                            <xsl:if test="$Validation/Z03/StampImage">
                              <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                                <fo:block>
                                  <fo:external-graphic fox:alt-text="Inspector Stamp" src="{$Validation/Z03/StampImage}" content-width="scale-to-fit" width="96px" scaling="uniform" />
                                </fo:block>
                              </fo:table-cell>
                            </xsl:if>
                          </fo:table-row>
                        </fo:table-body>
                      </fo:table>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>


            <!-- Supplementary Information -->
            <xsl:if test="$Validation/SupplementaryInformation">
              <xsl:call-template name="SectionSubTitle">
                <xsl:with-param name="subtitle" select="$i18n/Certificate/SupplementaryInformation" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="$Validation/SupplementaryInformation/*[substring(local-name(), 2) &gt;= '05' and substring(local-name(), 2) &lt;= '19']">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="./Key" />
                        <xsl:with-param name="method" select="./Method" />
                        <xsl:with-param name="value" select="./Value" />
                        <xsl:with-param name="type" select="./Type" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        <xsl:with-param name="language" select="$documentLanguage" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Attachments -->
            <xsl:if test="exists($Attachments)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/Attachments" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="100%" />
                <fo:table-body>
                  <xsl:for-each select="$Attachments">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-family="NotoSans, NotoSansSC" font-style="italic">
                          <xsl:value-of select="FileName" />
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
                  <fo:table-cell color="gray" font-size="8pt">
                    <fo:block> Data schema maintained by <fo:basic-link external-destination="https://materialidentity.org">
                      <fo:inline text-decoration="underline">Material Identity</fo:inline>
                    </fo:basic-link>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block color="gray" font-size="8pt">
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
<xsl:template name="SectionTitleSmall">
  <xsl:param name="title" />
  <fo:block font-size="10pt" font-weight="bold" text-align="left" space-before="8pt" space-after="6pt" border-bottom="solid 0.8pt black">
    <xsl:value-of select="$title" />
  </fo:block>
</xsl:template>
<xsl:template name="SectionSubTitle">
  <xsl:param name="subtitle" />
  <fo:block font-weight="bold" text-align="left" space-before="12pt" space-after="6pt">
    <xsl:value-of select="$subtitle" />
  </fo:block>
</xsl:template>

<xsl:template name="KeyValue">
  <xsl:param name="number" />
  <xsl:param name="method" />
  <xsl:param name="key" />
  <xsl:param name="value" />
  <xsl:param name="paddingBottom" />
  <xsl:param name="type" select="'default'" />
  <xsl:param name="language" select="'EN'" />
  <!-- Added language parameter with default -->

  <fo:table-cell padding-bottom="{if(string-length($paddingBottom) > 0) then $paddingBottom else '0pt'}" padding-right="4pt">
    <fo:block font-style="italic">
      <xsl:value-of select="$number" />
      <xsl:value-of select="$key" />
      <xsl:value-of select="$method" />
    </fo:block>
  </fo:table-cell>

  <fo:table-cell>
    <fo:block>
      <xsl:choose>
        <xsl:when test="$type = 'date'">
          <xsl:call-template name="format-date-by-language">
            <xsl:with-param name="date" select="xs:date($value)" />
            <xsl:with-param name="language" select="$language" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$type = 'date-time'">
          <xsl:value-of select="concat(substring($value, 6, 2), '/', substring($value, 9, 2), '/', substring($value, 1, 4))" />
        </xsl:when>
        <xsl:when test="$type = 'url'">
          <fo:basic-link external-destination="{$value}">
            <fo:inline text-decoration="underline">
              <xsl:value-of select="$value" />
            </fo:inline>
          </fo:basic-link>
        </xsl:when>
        <xsl:when test="$type = 'email'">
          <fo:basic-link external-destination="mailto:{$value}">
            <fo:inline text-decoration="underline">
              <xsl:value-of select="$value" />
            </fo:inline>
          </fo:basic-link>
        </xsl:when>
        <xsl:when test="$type = 'phone'">
          <fo:basic-link external-destination="tel:{$value}">
            <fo:inline>
              <xsl:value-of select="$value" />
            </fo:inline>
          </fo:basic-link>
        </xsl:when>
        <xsl:when test="$type = 'qr-code'">
          <!-- QR code generation typically requires an external library or pre-generated image -->
          <fo:external-graphic fox:alt-text="QR Code" src="{$value}" content-width="80px" width="80px" scaling="uniform" />
        </xsl:when>
        <xsl:when test="$type = 'image'">
          <fo:external-graphic fox:alt-text="Image" src="{$value}" content-width="scale-to-fit" width="100px" scaling="uniform" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$value" />
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<xsl:template name="KeyValueSmall">
  <xsl:param name="key" />
  <xsl:param name="value" />
  <xsl:param name="paddingBottom" />
  <fo:table-cell padding-bottom="{$paddingBottom}">
    <fo:block font-size="7pt">
      <xsl:value-of select="$key" />
    </fo:block>
  </fo:table-cell>
  <fo:table-cell>
    <fo:block>
      <xsl:value-of select="$value" />
    </fo:block>
  </fo:table-cell>
</xsl:template>

<!-- Update the PartyInfo template to handle Emails array -->
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
      <xsl:value-of select="$party/Name" />
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
    <!-- Render the email(s) -->
    <xsl:choose>
      <!-- Handle new Emails array -->
      <xsl:when test="$party/Emails">
        <xsl:for-each select="$party/Emails">
          <fo:block>
            <fo:basic-link external-destination="{concat('mailto:', .)}">
              <fo:inline text-decoration="underline">
                <xsl:value-of select="." />
              </fo:inline>
            </fo:basic-link>
          </fo:block>
        </xsl:for-each>
      </xsl:when>
      <!-- Fall back to Email field for backward compatibility (though it shouldn't be needed as per the updated schema) -->
      <xsl:when test="$party/Email">
        <fo:block>
          <fo:basic-link external-destination="{concat('mailto:', $party/Email)}">
            <fo:inline text-decoration="underline">
              <xsl:value-of select="$party/Email" />
            </fo:inline>
          </fo:basic-link>
        </fo:block>
      </xsl:when>
    </xsl:choose>
  </fo:table-cell>
</xsl:template>
<xsl:template name="format-date-by-language">
  <xsl:param name="date" as="xs:date"/>
  <xsl:param name="language" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="$language = 'DE'">
      <xsl:value-of select="format-date($date, '[D01].[M01].[Y0001]')"/>
    </xsl:when>
    <xsl:when test="$language = 'FR'">
      <xsl:value-of select="format-date($date, '[D01]/[M01]/[Y0001]')"/>
    </xsl:when>
    <xsl:when test="$language = 'PL'">
      <xsl:value-of select="format-date($date, '[D01].[M01].[Y0001]')"/>
    </xsl:when>
    <xsl:when test="$language = 'EN'">
      <xsl:value-of select="format-date($date, '[D01]/[M01]/[Y0001]')"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- Default to ISO format -->
      <xsl:value-of select="format-date($date, '[Y0001]-[M01]-[D01]')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>