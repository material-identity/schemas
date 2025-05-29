<?xml version="1.0" encoding="UTF-8"?>
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
          <xsl:variable name="partyPaddingBottom" select="'4pt'" />
          <xsl:variable name="logoPaddingBottom" select="'10pt'" />
          <xsl:variable name="fontSizeSmall" select="'6pt'" />
          
          <xsl:variable name="dmp" select="Root/DigitalMaterialPassport" />
          
          <fo:block font-size="8pt">
            <!-- Parties Section with Logo -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell number-columns-spanned="1" padding-bottom="{$logoPaddingBottom}">
                    <fo:block>
                      <xsl:if test="$dmp/TransactionData/Parties/Manufacturer/Logo">
                        <fo:external-graphic fox:alt-text="Company Logo" 
                                           src="{$dmp/TransactionData/Parties/Manufacturer/Logo}" 
                                           content-height="48px" height="48px" />
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="'Manufacturer'" />
                    <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Manufacturer" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="'Customer'" />
                    <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Customer" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            
            <!-- Document Title -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Digital Material Passport'" />
            </xsl:call-template>
            
            <!-- General Information -->
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'ID'" />
                    <xsl:with-param name="value" select="$dmp/Id" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Version'" />
                    <xsl:with-param name="value" select="$dmp/Version" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Issue Date'" />
                    <xsl:with-param name="value" select="$dmp/IssueDate" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Certificate Type'" />
                    <xsl:with-param name="value" select="concat($dmp/Validation/CertificateType/Standard, ' ', $dmp/Validation/CertificateType/Type)" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            
            <!-- Business Transaction -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Business Transaction'" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell padding-right="12pt">
                    <xsl:call-template name="SectionTitleSmall">
                      <xsl:with-param name="title" select="'Order'" />
                    </xsl:call-template>
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="70%" />
                      <fo:table-column column-width="30%" />
                      <fo:table-body>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="'Order ID'" />
                            <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Id" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Position">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Position'" />
                              <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Position" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Date">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Date'" />
                              <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Date" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Quantity">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Quantity'" />
                              <xsl:with-param name="value" select="concat($dmp/TransactionData/BusinessTransaction/Order/Quantity, ' ', $dmp/TransactionData/BusinessTransaction/Order/QuantityUnit)" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                  <fo:table-cell>
                    <xsl:call-template name="SectionTitleSmall">
                      <xsl:with-param name="title" select="'Delivery'" />
                    </xsl:call-template>
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="70%" />
                      <fo:table-column column-width="30%" />
                      <fo:table-body>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="'Delivery ID'" />
                            <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Id" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Delivery/Position">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Position'" />
                              <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Position" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Delivery/Date">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Date'" />
                              <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Date" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                        <xsl:if test="$dmp/TransactionData/BusinessTransaction/Delivery/Quantity">
                          <fo:table-row>
                            <xsl:call-template name="KeyValue">
                              <xsl:with-param name="key" select="'Quantity'" />
                              <xsl:with-param name="value" select="concat($dmp/TransactionData/BusinessTransaction/Delivery/Quantity, ' ', $dmp/TransactionData/BusinessTransaction/Delivery/QuantityUnit)" />
                              <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                            </xsl:call-template>
                          </fo:table-row>
                        </xsl:if>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            
            <!-- Product Information -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Product Information'" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Product Name'" />
                    <xsl:with-param name="value" select="$dmp/Product/Name" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Batch ID'" />
                    <xsl:with-param name="value" select="$dmp/Product/BatchId" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <xsl:if test="$dmp/Product/HeatTreatment">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Heat Treatment'" />
                      <xsl:with-param name="value" select="$dmp/Product/HeatTreatment" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$dmp/Product/SurfaceCondition">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Surface Condition'" />
                      <xsl:with-param name="value" select="$dmp/Product/SurfaceCondition" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$dmp/Product/ProductionDate">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Production Date'" />
                      <xsl:with-param name="value" select="$dmp/Product/ProductionDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$dmp/Product/CountryOfOrigin">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Country of Origin'" />
                      <xsl:with-param name="value" select="$dmp/Product/CountryOfOrigin" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
              </fo:table-body>
            </fo:table>
            
            <!-- Material Designations -->
            <xsl:if test="$dmp/Product/MaterialDesignations">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="'Material Designations'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'System'" />
                      <xsl:with-param name="value" select="$dmp/Product/MaterialDesignations/System" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Designation'" />
                      <xsl:with-param name="value" select="$dmp/Product/MaterialDesignations/Designation" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </xsl:if>
            
            <!-- Product Shape -->
            <xsl:if test="$dmp/Product/Shape">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="'Product Shape'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Form'" />
                      <xsl:with-param name="value" select="$dmp/Product/Shape/Form" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <xsl:if test="$dmp/Product/Shape/Length">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Length'" />
                        <xsl:with-param name="value" select="concat($dmp/Product/Shape/Length, ' ', $dmp/Product/Shape/Unit)" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="$dmp/Product/Shape/Width">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Width'" />
                        <xsl:with-param name="value" select="concat($dmp/Product/Shape/Width, ' ', $dmp/Product/Shape/Unit)" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="$dmp/Product/Shape/Thickness">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Thickness'" />
                        <xsl:with-param name="value" select="concat($dmp/Product/Shape/Thickness, ' ', $dmp/Product/Shape/Unit)" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="$dmp/Product/Shape/Diameter">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Diameter'" />
                        <xsl:with-param name="value" select="concat($dmp/Product/Shape/Diameter, ' ', $dmp/Product/Shape/Unit)" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>
            </xsl:if>
            
            <!-- Chemical Analysis -->
            <xsl:if test="$dmp/ChemicalAnalysis">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="'Chemical Analysis'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Heat Number'" />
                      <xsl:with-param name="value" select="$dmp/ChemicalAnalysis/HeatNumber" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <xsl:if test="$dmp/ChemicalAnalysis/MeltingProcess">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Melting Process'" />
                        <xsl:with-param name="value" select="$dmp/ChemicalAnalysis/MeltingProcess" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="$dmp/ChemicalAnalysis/CastingDate">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Casting Date'" />
                        <xsl:with-param name="value" select="$dmp/ChemicalAnalysis/CastingDate" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                  <xsl:if test="$dmp/ChemicalAnalysis/SampleLocation">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Sample Location'" />
                        <xsl:with-param name="value" select="$dmp/ChemicalAnalysis/SampleLocation" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </xsl:if>
                </fo:table-body>
              </fo:table>
              
              <!-- Chemical Elements Table -->
              <xsl:if test="$dmp/ChemicalAnalysis/Elements">
                <fo:block keep-together="always">
                  <xsl:call-template name="SectionTitleSmall">
                    <xsl:with-param name="title" select="'Elements'" />
                  </xsl:call-template>
                  
                  <fo:table id="chemical-composition-table" table-layout="fixed" width="100%">
                    <fo:table-column column-width="proportional-column-width(2)"/>
                    <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                      <fo:table-column column-width="proportional-column-width(1)"/>
                    </xsl:for-each>
                    
                    <fo:table-body>
                      <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell padding="3pt">
                          <fo:block font-style="italic">Symbol</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                          <fo:table-cell padding="3pt">
                            <fo:block font-weight="bold" text-align="center">
                              <xsl:value-of select="."/>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      
                      <fo:table-row>
                        <fo:table-cell padding="3pt">
                          <fo:block font-style="italic">Unit</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                          <fo:table-cell padding="3pt">
                            <fo:block text-align="center">%</fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      
                      <fo:table-row>
                        <fo:table-cell padding="3pt">
                          <fo:block font-style="italic">Min</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                          <xsl:variable name="currentSymbol" select="." />
                          <fo:table-cell padding="3pt">
                            <fo:block text-align="center">
                              <xsl:choose>
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Minimum[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Minimum[1]" />
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>-</xsl:otherwise>
                              </xsl:choose>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      
                      <fo:table-row>
                        <fo:table-cell padding="3pt">
                          <fo:block font-style="italic">Max</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                          <xsl:variable name="currentSymbol" select="." />
                          <fo:table-cell padding="3pt">
                            <fo:block text-align="center">
                              <xsl:choose>
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Maximum[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Maximum[1]" />
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>-</xsl:otherwise>
                              </xsl:choose>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                      
                      <fo:table-row>
                        <fo:table-cell padding="3pt">
                          <fo:block font-style="italic">Actual</fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[not(. = preceding-sibling::PropertySymbol)]">
                          <xsl:variable name="currentSymbol" select="." />
                          <fo:table-cell padding="3pt">
                            <fo:block text-align="center">
                              <xsl:choose>
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Actual[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements/PropertySymbol[. = $currentSymbol]/following-sibling::Actual[1]" />
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>-</xsl:otherwise>
                              </xsl:choose>
                            </fo:block>
                          </fo:table-cell>
                        </xsl:for-each>
                      </fo:table-row>
                    </fo:table-body>
                  </fo:table>
                </fo:block>
              </xsl:if>
            </xsl:if>
            
            <!-- Mechanical Properties -->
            <xsl:if test="$dmp/MechanicalProperties">
              <fo:block keep-together="always">
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Mechanical Properties'" />
                </xsl:call-template>
                <fo:table id="mechanical-properties-table" table-layout="fixed" width="100%">
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="10%" />
                  <fo:table-column column-width="10%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="10%" />
                  <fo:table-column column-width="10%" />
                  
                  <fo:table-body>
                    <fo:table-row background-color="#f0f0f0">
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Property</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Symbol</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Unit</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Actual</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Minimum</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Maximum</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Method</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Status</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    
                    <xsl:for-each select="$dmp/MechanicalProperties[not(PropertyName = preceding-sibling::MechanicalProperties/PropertyName)]">
                      <xsl:variable name="propertyName" select="PropertyName" />
                      <fo:table-row>
                        <fo:table-cell padding="2pt">
                          <fo:block><xsl:value-of select="$propertyName" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block><xsl:value-of select="PropertySymbol" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block><xsl:value-of select="Unit" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block>
                            <xsl:call-template name="FormatResult">
                              <xsl:with-param name="result" select="Actual" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block>
                            <xsl:if test="Minimum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Minimum" />
                              </xsl:call-template>
                            </xsl:if>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block>
                            <xsl:if test="Maximum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Maximum" />
                              </xsl:call-template>
                            </xsl:if>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block><xsl:value-of select="Method" /></fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt">
                          <fo:block>
                            <xsl:choose>
                              <xsl:when test="Interpretation = 'In Specification'">
                                <fo:inline color="green">✓</fo:inline>
                              </xsl:when>
                              <xsl:when test="Interpretation = 'Out of Specification'">
                                <fo:inline color="red">✗</fo:inline>
                              </xsl:when>
                              <xsl:when test="Interpretation = 'Conditionally Acceptable'">
                                <fo:inline color="orange">!</fo:inline>
                              </xsl:when>
                              <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </fo:block>
            </xsl:if>
            
            <!-- Validation Information -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="'Validation'" />
            </xsl:call-template>
            
            <!-- Validation Statement -->
            <fo:block space-before="4pt" space-after="8pt">
              <xsl:value-of select="$dmp/Validation/ValidationStatement/Statement" />
            </fo:block>
            
            <!-- Validators -->
            <xsl:if test="$dmp/Validation/Validators">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="'Validated By'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="25%" />
                <fo:table-column column-width="25%" />
                <fo:table-column column-width="25%" />
                <fo:table-column column-width="25%" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-style="italic">Name</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-style="italic">Title</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-style="italic">Department</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-style="italic">Date</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:for-each select="$dmp/Validation/Validators">
                    <fo:table-row>
                      <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                        <fo:block-container position="relative" height="50px">
                          <fo:block absolute-position="absolute" top="0px" left="0px">
                            <xsl:value-of select="Name" />
                          </fo:block>
                          <xsl:if test="StampImage">
                            <fo:block absolute-position="absolute" top="-5px" left="0px">
                              <fo:external-graphic src="{StampImage}" 
                                                   content-height="50px" 
                                                   scaling="uniform" />
                            </fo:block>
                          </xsl:if>
                        </fo:block-container>
                      </fo:table-cell>
                      <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                        <fo:block><xsl:value-of select="Title" /></fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                        <fo:block><xsl:value-of select="Department" /></fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                        <fo:block><xsl:value-of select="../ValidationDate" /></fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>
            
            <!-- Footer -->
            <fo:table table-layout="fixed" margin-top="16pt" width="100%">
              <fo:table-column column-width="40%" />
              <fo:table-column column-width="60%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block>Data schema maintained by
                      <fo:basic-link external-destination="https://materialidentity.org">
                        <fo:inline text-decoration="underline">Material Identity</fo:inline>
                      </fo:basic-link>.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block color="gray" text-align="right">
                      <fo:basic-link external-destination="{/Root/RefSchemaUrl}">
                        <fo:inline text-decoration="underline">
                          <xsl:value-of select="/Root/RefSchemaUrl" />
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
    <xsl:param name="paddingBottom" />
    <fo:table-cell>
      <fo:block padding-bottom="{$paddingBottom}" font-weight="bold">
        <xsl:value-of select="$title" />
      </fo:block>
      <fo:block font-weight="bold" padding-bottom="{$paddingBottom}">
        <xsl:value-of select="$party/Name" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="$party/Street" />
      </fo:block>
      <fo:block>
        <xsl:value-of select="concat($party/ZipCode, ' ', $party/City, ', ', $party/Country)" />
      </fo:block>
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
          <xsl:text> ± </xsl:text>
          <xsl:value-of select="$result/Uncertainty" />
        </xsl:if>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'boolean'">
        <xsl:choose>
          <xsl:when test="$result/Value = 'true'">Yes</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'string'">
        <xsl:value-of select="$result/Value" />
      </xsl:when>
      <xsl:when test="$result/ResultType = 'range'">
        <xsl:value-of select="$result/Minimum" />
        <xsl:text> - </xsl:text>
        <xsl:value-of select="$result/Maximum" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result/Value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>