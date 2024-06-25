<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin="1cm">
          <fo:region-body margin="0.25cm" margin-bottom="1.8cm" />
          <fo:region-after extent="1.5cm" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">
        <!-- Page number -->
        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-size="8pt" text-align="center" margin-right="1cm" font-family="NotoSans">
            <fo:page-number />/<fo:page-number-citation-last ref-id="last-page" />
          </fo:block>
        </fo:static-content>
        <!-- Body -->
        <fo:flow flow-name="xsl-region-body">
          <!-- Global variables -->
          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="CommercialTransaction" select="Root/Certificate/CommercialTransaction" />
          <xsl:variable name="ProductDescription" select="Root/Certificate/ProductDescription" />
          <xsl:variable name="Inspection" select="Root/Certificate/Inspection" />
          <xsl:variable name="OtherTests" select="Root/Certificate/OtherTests" />
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
                    <fo:block padding-bottom="4pt" font-style="italic"> A04 <xsl:value-of select="$i18n/Certificate/A04" />
                    </fo:block>
                    <fo:block>
                      <fo:external-graphic src="{$CommercialTransaction/A04}" content-height="48px" height="48px" />
                    </fo:block>
                  </fo:table-cell>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="number" select="'A01 '" />
                    <xsl:with-param name="title" select="$i18n/Certificate/A01" />
                    <xsl:with-param name="party" select="$CommercialTransaction/A01" />
                  </xsl:call-template>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="number" select="'A06 '" />
                    <xsl:with-param name="title" select="$i18n/Certificate/A06" />
                    <xsl:with-param name="party" select="$CommercialTransaction/A06" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- Certificate info -->
            <!-- Commercial Transaction -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/CommercialTransaction" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:for-each select="$CommercialTransaction/*">
                  <xsl:if test="starts-with(local-name(), 'A') and not(local-name() = 'A01' or local-name() = 'A04' or local-name() = 'A06')">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="." />
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
                        </xsl:call-template>
                      </fo:table-row>
                      <xsl:for-each select="$ProductDescription/B02/*">
                        <!-- Process only the first occurrence of each key -->
                        <xsl:if test="not(preceding-sibling::*[local-name() = local-name(current())])">
                          <fo:table-row>
                            <xsl:call-template name="KeyValueSmall">
                              <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
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
                        <fo:table-cell padding-bottom="4pt">
                          <fo:block></fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:when>
                    <xsl:when test="local-name() = 'B09'">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        </xsl:call-template>
                      </fo:table-row>

                      <!-- Capture the unit value -->
                      <xsl:variable name="unitValue" select="$ProductDescription/B09/Unit" />

                      <xsl:for-each select="$ProductDescription/B09/*[local-name() != 'Unit']">
                        <fo:table-row>
                          <xsl:call-template name="KeyValueSmall">
                            <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                            <xsl:with-param name="value">
                              <xsl:for-each select=".">
                                <xsl:value-of select="." />
                                <xsl:if test="position() != last()">, </xsl:if>
                              </xsl:for-each>
                              <!-- Concatenate unit value if the key is not 'Form' -->
                              <xsl:if test="local-name() != 'Form' and $unitValue">
                                <xsl:text></xsl:text>
                                <xsl:value-of select="$unitValue" />
                              </xsl:if>
                            </xsl:with-param>
                          </xsl:call-template>
                        </fo:table-row>
                      </xsl:for-each>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="4pt">
                          <fo:block></fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:table-row>
                        <xsl:choose>
                          <xsl:when test="local-name() = 'B10' or local-name() = 'B11' or local-name() = 'B12' or local-name() = 'B13'">
                            <xsl:variable name="concatenatedValue">
                              <xsl:value-of select="./Value" />
                              <xsl:text></xsl:text>
                              <xsl:value-of select="./Unit" />
                            </xsl:variable>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                              <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                              <xsl:with-param name="value" select="$concatenatedValue" />
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                              <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                              <xsl:with-param name="value" select="." />
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
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="./Value" />
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
                  <xsl:for-each select="*[starts-with(local-name(), 'C0')]">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="." />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>

              <!-- Check for one of keys: ChemicalComposition, TensileTest, HardnessTest,
                NotchedBarImpactTest, OtherMechanicalTests  -->
              <xsl:if test="ChemicalComposition">
                <xsl:call-template name="SectionTitleSmall">
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
                        <xsl:with-param name="value" select="ChemicalComposition/C70" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
                <xsl:variable name="keys" select="ChemicalComposition/*[not(name() = 'SupplementaryInformation' or name() = 'C70')]" />
                <xsl:variable name="columnCount" select="count($keys)+1" />
                <!-- Count ChemicalComposition keys (excluding SupplementaryInformation) and divide columns
                  accordingly, equal spread -->
                <fo:table table-layout="fixed" width="100%">
                  <xsl:for-each select="1 to $columnCount">
                    <fo:table-column column-width="{100 div $columnCount}%" />
                  </xsl:for-each>
                  <fo:table-body>
                    <!-- Header row for keys C70 to C92 -->
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block></fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys">
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="name()" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                    <!-- Symbol row -->
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block>Symbol</fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys">
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="Symbol" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                    <!-- Actual row -->
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block>Actual [%]</fo:block>
                      </fo:table-cell>
                      <xsl:for-each select="$keys">
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="Actual" />
                          </fo:block>
                        </fo:table-cell>
                      </xsl:for-each>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
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
                    <xsl:for-each select="TensileTest/*[local-name() = 'C10' or local-name() = 'C11' or local-name() = 'C12' or local-name() = 'C13']">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                          <xsl:with-param name="value" select="concat(./Value, ' ', ./Unit)" />
                        </xsl:call-template>
                      </fo:table-row>
                      <fo:table-row>
                        <fo:table-cell padding-bottom="8pt">
                          <fo:block>
                            <xsl:value-of select="./Property" />
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
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
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
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
                        <xsl:with-param name="value">
                          <xsl:for-each select="HardnessTest/C31">
                            <xsl:value-of select="Value" />
                            <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text>, </xsl:text>
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
                        <xsl:with-param name="value" select="concat(NotchedBarImpactTest/C40/Value, ' ', NotchedBarImpactTest/C40/Unit)" />
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
                        <xsl:with-param name="value">
                          <xsl:for-each select="NotchedBarImpactTest/C42">
                            <xsl:value-of select="Value" />
                            <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                            </xsl:if>
                          </xsl:for-each>
                          <xsl:text>, </xsl:text>
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
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <xsl:for-each select="OtherMechanicalTests/*[substring(local-name(), 2) &gt;= '50' and substring(local-name(), 2) &lt;= '69']">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                          <xsl:with-param name="key" select="./Key" />
                          <xsl:with-param name="value" select="./Value" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>

            </xsl:for-each>

            <!-- Other Tests -->
            <!-- loop through Other tests-->
            <xsl:for-each select="$OtherTests">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/OtherTests" />
              </xsl:call-template>

              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="'D01'">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="number" select="concat(local-name(), ' ')" />
                        <xsl:with-param name="key" select="$i18n/Certificate/*[local-name() = local-name(current())]" />
                        <xsl:with-param name="value" select="." />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
              <!-- <xsl:if test="NonDestructiveTests">
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.33%" />
                <fo:table-body>
                  <xsl:for-each select="NonDestructiveTests/*[substring(local-name(), 2) &gt;= '02' and substring(local-name(), 2) &lt;= '50']">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="concat(local-name(), ' ', $i18n/Certificate/*[local-name() = local-name(current())])" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="concat(./Value, ' ', ./Unit)" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="./Interpretation" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </xsl:if> -->
              <!-- <xsl:if test="OtherProductTests">
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.33%" />
                <fo:table-column column-width="33.33%" />
              </xsl:if> -->
            </xsl:for-each>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="SectionTitle">
    <xsl:param name="title" />
    <fo:block font-size="10pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt" border-bottom="solid 1pt black">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>
  <xsl:template name="SectionTitleSmall">
    <xsl:param name="title" />
    <fo:block font-size="8pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt" border-bottom="solid 0.6pt black">
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
    <xsl:param name="key" />
    <xsl:param name="value" />
    <xsl:param name="type" select="'default'" />
    <fo:table-cell padding-bottom="4pt">
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

  <xsl:template name="KeyValueSmall">
    <xsl:param name="key" />
    <xsl:param name="value" />
    <fo:table-cell padding-bottom="4pt">
      <fo:block font-size="6pt">
        <xsl:value-of select="$key" />
      </fo:block>
    </fo:table-cell>
    <fo:table-cell>
      <fo:block>
        <xsl:value-of select="$value" />
      </fo:block>
    </fo:table-cell>
  </xsl:template>
  <xsl:template name="PartyInfo">
    <xsl:param name="number" />
    <xsl:param name="title" />
    <xsl:param name="party" />
    <fo:table-cell>
      <fo:block padding-bottom="4pt" font-style="italic">
        <xsl:value-of select="$number" />
        <xsl:value-of select="$title" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="$party/CompanyName" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="$party/Street" />
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
</xsl:stylesheet>