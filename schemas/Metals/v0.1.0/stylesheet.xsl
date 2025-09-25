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
                <!-- Row 1: Logo and Manufacturer -->
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
                
                <!-- Row 2: Customer and next party (Subcustomer, GoodsReceiver, or CertificateReceiver) -->
                <fo:table-row>
                  <xsl:call-template name="PartyInfo">
                    <xsl:with-param name="title" select="'Customer'" />
                    <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Customer" />
                    <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                  </xsl:call-template>
                  <xsl:choose>
                    <xsl:when test="$dmp/TransactionData/Parties/Subcustomer">
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="'Subcustomer'" />
                        <xsl:with-param name="party" select="$dmp/TransactionData/Parties/Subcustomer" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$dmp/TransactionData/Parties/GoodsReceiver">
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="'Goods Receiver'" />
                        <xsl:with-param name="party" select="$dmp/TransactionData/Parties/GoodsReceiver" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$dmp/TransactionData/Parties/CertificateReceiver">
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="'Certificate Receiver'" />
                        <xsl:with-param name="party" select="$dmp/TransactionData/Parties/CertificateReceiver" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:table-cell>
                        <fo:block/>
                      </fo:table-cell>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:table-row>
                
                <!-- Row 3: Additional parties if 4+ parties exist -->
                <xsl:variable name="hasSubcustomer" select="boolean($dmp/TransactionData/Parties/Subcustomer)" />
                <xsl:variable name="hasGoodsReceiver" select="boolean($dmp/TransactionData/Parties/GoodsReceiver)" />
                <xsl:variable name="hasCertificateReceiver" select="boolean($dmp/TransactionData/Parties/CertificateReceiver)" />
                <xsl:variable name="partyCount" select="2 + number($hasSubcustomer) + number($hasGoodsReceiver) + number($hasCertificateReceiver)" />
                
                <xsl:if test="$partyCount >= 4">
                  <fo:table-row>
                    <!-- Row 3 Col 1: Third party -->
                    <xsl:choose>
                      <xsl:when test="$hasSubcustomer and $hasGoodsReceiver">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="'Goods Receiver'" />
                          <xsl:with-param name="party" select="$dmp/TransactionData/Parties/GoodsReceiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:when test="$hasSubcustomer and $hasCertificateReceiver">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="'Certificate Receiver'" />
                          <xsl:with-param name="party" select="$dmp/TransactionData/Parties/CertificateReceiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:when test="$hasGoodsReceiver and $hasCertificateReceiver">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="'Certificate Receiver'" />
                          <xsl:with-param name="party" select="$dmp/TransactionData/Parties/CertificateReceiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:table-cell>
                          <fo:block/>
                        </fo:table-cell>
                      </xsl:otherwise>
                    </xsl:choose>
                    
                    <!-- Row 3 Col 2: Fourth party -->
                    <xsl:choose>
                      <xsl:when test="$hasSubcustomer and $hasGoodsReceiver and $hasCertificateReceiver">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="'Certificate Receiver'" />
                          <xsl:with-param name="party" select="$dmp/TransactionData/Parties/CertificateReceiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:table-cell>
                          <fo:block/>
                        </fo:table-cell>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-row>
                </xsl:if>
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
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block font-size="8pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt">Order</fo:block>
                  </fo:table-cell>
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block font-size="8pt" font-weight="bold" text-align="left" space-before="12pt" space-after="6pt">Delivery</fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Order ID'" />
                    <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Id" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="'Delivery ID'" />
                    <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Id" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
                <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Position or $dmp/TransactionData/BusinessTransaction/Delivery/Position">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Position'" />
                      <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Position" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Position'" />
                      <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Position" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Date or $dmp/TransactionData/BusinessTransaction/Delivery/Date">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Date'" />
                      <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Order/Date" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Date'" />
                      <xsl:with-param name="value" select="$dmp/TransactionData/BusinessTransaction/Delivery/Date" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$dmp/TransactionData/BusinessTransaction/Order/Quantity or $dmp/TransactionData/BusinessTransaction/Delivery/Quantity">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Quantity'" />
                      <xsl:with-param name="value" select="concat($dmp/TransactionData/BusinessTransaction/Order/Quantity, ' ', $dmp/TransactionData/BusinessTransaction/Order/QuantityUnit)" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Quantity'" />
                      <xsl:with-param name="value" select="concat($dmp/TransactionData/BusinessTransaction/Delivery/Quantity, ' ', $dmp/TransactionData/BusinessTransaction/Delivery/QuantityUnit)" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
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

            <!-- Customs Classification -->
            <xsl:if test="$dmp/Product/CustomsClassification">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="'Customs Classification'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'HS Code'" />
                      <xsl:with-param name="value" select="$dmp/Product/CustomsClassification/HSCode" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="'Standard Description'" />
                      <xsl:with-param name="value" select="$dmp/Product/CustomsClassification/StandardDescription" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                  <xsl:for-each select="$dmp/Product/CustomsClassification/RegionalCodes">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="concat(System, ' (', Region, ')')" />
                        <xsl:with-param name="value" select="Code" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <xsl:if test="Description">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="key" select="concat('Description (', Region, ')')" />
                          <xsl:with-param name="value" select="Description" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:if>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- Product Norms -->
            <xsl:if test="$dmp/Product/ProductNorms">
              <xsl:call-template name="SectionTitleSmall">
                <xsl:with-param name="title" select="'Product Norms'" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <xsl:for-each select="$dmp/Product/ProductNorms">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Designation'" />
                        <xsl:with-param name="value" select="concat(Designation, if(Year) then concat(' (', Year, ')') else '')" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <xsl:if test="Grade">
                      <fo:table-row>
                        <xsl:call-template name="KeyValue">
                          <xsl:with-param name="key" select="'Grade'" />
                          <xsl:with-param name="value" select="Grade" />
                          <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                        </xsl:call-template>
                      </fo:table-row>
                    </xsl:if>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
            </xsl:if>
            
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
                  <xsl:if test="$dmp/ChemicalAnalysis/CastingMethod">
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="'Casting Method'" />
                        <xsl:with-param name="value" select="$dmp/ChemicalAnalysis/CastingMethod" />
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
                          <xsl:variable name="currentSymbol" select="." />
                          <fo:table-cell padding="3pt">
                            <fo:block text-align="center">
                              <xsl:value-of select="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol][1]/Unit" />
                            </fo:block>
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
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Minimum[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Minimum[1]" />
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
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Maximum[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Maximum[1]" />
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
                                <xsl:when test="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Actual[1]">
                                  <xsl:call-template name="FormatResult">
                                    <xsl:with-param name="result" select="$dmp/ChemicalAnalysis/Elements[PropertySymbol = $currentSymbol]/Actual[1]" />
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
                  
                  <!-- Formula Definitions -->
                  <xsl:if test="$dmp/ChemicalAnalysis/Elements/Formula">
                    <fo:block space-before="8pt">
                      <xsl:call-template name="SectionTitleSmall">
                        <xsl:with-param name="title" select="'Formula Definitions'" />
                      </xsl:call-template>
                      <xsl:for-each select="$dmp/ChemicalAnalysis/Elements[Formula][not(PropertySymbol = preceding-sibling::*/PropertySymbol)]">
                        <fo:block space-after="2pt">
                          <fo:inline font-weight="bold"><xsl:value-of select="PropertySymbol" /></fo:inline>
                          <xsl:text> = </xsl:text>
                          <xsl:value-of select="Formula" />
                        </fo:block>
                      </xsl:for-each>
                    </fo:block>
                  </xsl:if>
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
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="10%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="5%" />
                  
                  <fo:table-body>
                    <fo:table-row background-color="#f0f0f0">
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Property</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Symbol</fo:block>
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
                        <fo:block font-style="italic" text-align="center">Status</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    
                    <xsl:for-each select="$dmp/MechanicalProperties[not(PropertyName = preceding-sibling::MechanicalProperties/PropertyName)]">
                      <xsl:variable name="propertyName" select="PropertyName" />
                      <fo:table-row>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="$propertyName" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="PropertySymbol" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:choose>
                              <xsl:when test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                                <fo:block>
                                  <xsl:call-template name="AddWordWrapBreaks">
                                    <xsl:with-param name="text" select="'Array data (see below)'" />
                                  </xsl:call-template>
                                </fo:block>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Actual" />
                                </xsl:call-template>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="Unit and not(Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray')">
                              <xsl:text> </xsl:text><xsl:value-of select="Unit" />
                            </xsl:if>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:if test="Minimum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Minimum" />
                              </xsl:call-template>
                            </xsl:if>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:if test="Maximum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Maximum" />
                              </xsl:call-template>
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
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block text-align="center">
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
                      <!-- Add spanning row for Array result types -->
                      <xsl:if test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                        <fo:table-row>
                          <fo:table-cell number-columns-spanned="7" padding="4pt">
                            <xsl:call-template name="FormatResult">
                              <xsl:with-param name="result" select="Actual" />
                            </xsl:call-template>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </fo:block>
            </xsl:if>
            
            <!-- Physical Properties -->
            <xsl:if test="$dmp/PhysicalProperties">
              <fo:block keep-together="always">
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Physical Properties'" />
                </xsl:call-template>
                <fo:table id="physical-properties-table" table-layout="fixed" width="100%">
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="10%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="15%" />
                  <fo:table-column column-width="20%" />
                  <fo:table-column column-width="5%" />
                  
                  <fo:table-body>
                    <fo:table-row background-color="#f0f0f0">
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Property</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Symbol</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Actual</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Target/Min</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Maximum</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Method</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic" text-align="center">Status</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    
                    <xsl:for-each select="$dmp/PhysicalProperties">
                      <fo:table-row>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="PropertyName" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="PropertySymbol" />
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:choose>
                              <xsl:when test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                                <fo:block>
                                  <xsl:call-template name="AddWordWrapBreaks">
                                    <xsl:with-param name="text" select="'Array data (see below)'" />
                                  </xsl:call-template>
                                </fo:block>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Actual" />
                                </xsl:call-template>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="Unit and not(Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray')">
                              <xsl:text> </xsl:text><xsl:value-of select="Unit" />
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
                              </xsl:when>
                              <xsl:when test="Minimum">
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Minimum" />
                                </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:if test="Maximum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Maximum" />
                              </xsl:call-template>
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
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block text-align="center">
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
                      <!-- Add spanning row for Array result types -->
                      <xsl:if test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                        <fo:table-row>
                          <fo:table-cell number-columns-spanned="7" padding="4pt">
                            <xsl:call-template name="FormatResult">
                              <xsl:with-param name="result" select="Actual" />
                            </xsl:call-template>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:if>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </fo:block>
            </xsl:if>
            
            <!-- Supplementary Tests -->
            <xsl:if test="$dmp/SupplementaryTests">
              <fo:block keep-together="always">
                <xsl:call-template name="SectionTitle">
                  <xsl:with-param name="title" select="'Supplementary Tests'" />
                </xsl:call-template>
                <fo:table id="supplementary-tests-table" table-layout="fixed" width="100%">
                  <fo:table-column column-width="25%" />
                  <fo:table-column column-width="25%" />
                  <fo:table-column column-width="12%" />
                  <fo:table-column column-width="12%" />
                  <fo:table-column column-width="21%" />
                  <fo:table-column column-width="5%" />
                  
                  <fo:table-body>
                    <fo:table-row background-color="#f0f0f0">
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Property</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Actual</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Target/Min</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Maximum</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic">Method</fo:block>
                      </fo:table-cell>
                      <fo:table-cell padding="2pt">
                        <fo:block font-style="italic" text-align="center">Status</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                    
                    <xsl:for-each select="$dmp/SupplementaryTests">
                      <fo:table-row>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:call-template name="AddWordWrapBreaks">
                              <xsl:with-param name="text" select="PropertyName" />
                            </xsl:call-template>
                          </fo:block>
                          <xsl:if test="TestConditions">
                            <fo:block font-size="6pt" color="gray">
                              <xsl:value-of select="TestConditions" />
                            </fo:block>
                          </xsl:if>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:choose>
                              <xsl:when test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                                <fo:block>
                                  <xsl:call-template name="AddWordWrapBreaks">
                                    <xsl:with-param name="text" select="'Array data (see below)'" />
                                  </xsl:call-template>
                                </fo:block>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Actual" />
                                </xsl:call-template>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="Unit and not(Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray')">
                              <xsl:text> </xsl:text><xsl:value-of select="Unit" />
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
                              </xsl:when>
                              <xsl:when test="Minimum">
                                <xsl:call-template name="FormatResult">
                                  <xsl:with-param name="result" select="Minimum" />
                                </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block>
                            <xsl:if test="Maximum">
                              <xsl:call-template name="FormatResult">
                                <xsl:with-param name="result" select="Maximum" />
                              </xsl:call-template>
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
                        <fo:table-cell padding="2pt" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                          <fo:block text-align="center">
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
                      <!-- Add spanning row for Array result types -->
                      <xsl:if test="Actual/ResultType = 'array' or Actual/ResultType = 'structuredArray'">
                        <fo:table-row>
                          <fo:table-cell number-columns-spanned="6" padding="4pt">
                            <xsl:call-template name="FormatResult">
                              <xsl:with-param name="result" select="Actual" />
                            </xsl:call-template>
                          </fo:table-cell>
                        </fo:table-row>
                      </xsl:if>
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
      
      <!-- Use FormatAddress template for country-specific address formatting -->
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
        <xsl:if test="$result/Description">
          <fo:block font-size="6pt" color="gray">
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
      <xsl:when test="$result/ResultType = 'array'">
        <fo:table table-layout="fixed" width="100%" margin-top="3pt">
          <fo:table-column column-width="proportional-column-width(2)"/>
          <xsl:for-each select="$result/Values">
            <fo:table-column column-width="proportional-column-width(1)"/>
          </xsl:for-each>
          <fo:table-body>
            <!-- First row: Parameter name and values -->
            <fo:table-row background-color="#f8f8f8">
              <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                <fo:block text-align="center" font-size="8pt" font-weight="bold">
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
                    <xsl:otherwise>
                      <xsl:call-template name="AddWordWrapBreaks">
                        <xsl:with-param name="text" select="'Parameter'" />
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <xsl:choose>
                <xsl:when test="$result/Parameters">
                  <xsl:for-each select="$result/Parameters">
                    <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                      <fo:block text-align="center" font-size="8pt">
                        <xsl:value-of select="." />
                      </fo:block>
                    </fo:table-cell>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$result/Values">
                    <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                      <fo:block text-align="center" font-size="8pt">
                        <xsl:value-of select="position()" />
                      </fo:block>
                    </fo:table-cell>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-row>
            <!-- Second row: Values with units -->
            <fo:table-row>
              <fo:table-cell padding="2pt" border="0.5pt solid #ddd" wrap-option="wrap" hyphenate="true" keep-together.within-line="auto">
                <fo:block text-align="center" font-size="8pt" font-weight="bold">
                  <xsl:choose>
                    <xsl:when test="$result/Unit">
                      <xsl:call-template name="AddWordWrapBreaks">
                        <xsl:with-param name="text" select="concat('[', $result/Unit, ']')" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$result/../Unit">
                      <xsl:call-template name="AddWordWrapBreaks">
                        <xsl:with-param name="text" select="concat('[', $result/../Unit, ']')" />
                      </xsl:call-template>
                    </xsl:when>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <xsl:for-each select="$result/Values">
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                  <fo:block text-align="center" font-size="8pt">
                    <xsl:value-of select="." />
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>
      <xsl:when test="$result/ResultType = 'structuredArray'">
        <fo:table table-layout="fixed" width="100%" margin-top="3pt">
          <xsl:for-each select="$result/Parameters">
            <fo:table-column column-width="proportional-column-width(1)"/>
          </xsl:for-each>
          <fo:table-body>
            <!-- Header row: Parameters -->
            <fo:table-row background-color="#f8f8f8">
              <xsl:for-each select="$result/Parameters">
                <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                  <xsl:choose>
                    <xsl:when test="position() = 1">
                      <xsl:attribute name="wrap-option">wrap</xsl:attribute>
                      <xsl:attribute name="hyphenate">true</xsl:attribute>
                      <xsl:attribute name="keep-together.within-line">auto</xsl:attribute>
                      <fo:block text-align="center" font-size="8pt" font-weight="bold">
                        <xsl:call-template name="AddWordWrapBreaks">
                          <xsl:with-param name="text" select="." />
                        </xsl:call-template>
                      </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:block text-align="center" font-size="8pt" font-weight="bold">
                        <xsl:value-of select="." />
                      </fo:block>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
            <!-- Data rows: DataPoints -->
            <xsl:for-each select="$result/DataPoints">
              <fo:table-row>
                <xsl:for-each select=".">
                  <fo:table-cell padding="2pt" border="0.5pt solid #ddd">
                    <xsl:choose>
                      <xsl:when test="position() = 1">
                        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
                        <xsl:attribute name="hyphenate">true</xsl:attribute>
                        <xsl:attribute name="keep-together.within-line">auto</xsl:attribute>
                        <fo:block text-align="center" font-size="8pt">
                          <xsl:call-template name="AddWordWrapBreaks">
                            <xsl:with-param name="text" select="." />
                          </xsl:call-template>
                        </fo:block>
                      </xsl:when>
                      <xsl:otherwise>
                        <fo:block text-align="center" font-size="8pt">
                          <xsl:value-of select="." />
                        </fo:block>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:table-cell>
                </xsl:for-each>
              </fo:table-row>
            </xsl:for-each>
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

  <!-- Template for country-specific address formatting -->
  <xsl:template name="FormatAddress">
    <xsl:param name="party" />
    
    <!-- Determine country code -->
    <xsl:variable name="countryCode" select="$party/Country" />
    
    <xsl:choose>
      <!-- United States Format -->
      <xsl:when test="$countryCode = 'US'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Canada Format (similar to US) -->
      <xsl:when test="$countryCode = 'CA'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Japan Format -->
      <xsl:when test="$countryCode = 'JP'">
        <!-- Postal code with 〒 symbol -->
        <xsl:if test="$party/ZipCode">
          <fo:block>
            <xsl:text>〒</xsl:text>
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
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/District">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/District" />
          </xsl:if>
        </fo:block>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- China Format -->
      <xsl:when test="$countryCode = 'CN'">
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
        <!-- Postal code -->
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <!-- Province City District -->
        <fo:block>
          <xsl:if test="$party/StateProvince">
            <xsl:value-of select="$party/StateProvince" />
          </xsl:if>
          <xsl:if test="$party/City">
            <xsl:if test="$party/StateProvince">
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="$party/City" />
          </xsl:if>
          <xsl:if test="$party/District">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$party/District" />
          </xsl:if>
        </fo:block>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
      </xsl:when>
      
      <!-- United Kingdom Format -->
      <xsl:when test="$countryCode = 'GB'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block><xsl:value-of select="$party/City" /></fo:block>
        </xsl:if>
        <!-- Postal code -->
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Australia Format -->
      <xsl:when test="$countryCode = 'AU'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Brazil Format -->
      <xsl:when test="$countryCode = 'BR'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block><xsl:value-of select="$party/District" /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- India Format -->
      <xsl:when test="$countryCode = 'IN'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block><xsl:value-of select="$party/District" /></fo:block>
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
          <fo:block><xsl:value-of select="$party/StateProvince" /></fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- South Korea Format -->
      <xsl:when test="$countryCode = 'KR'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Mexico Format -->
      <xsl:when test="$countryCode = 'MX'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Russia Format -->
      <xsl:when test="$countryCode = 'RU'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block><xsl:value-of select="$party/City" /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Netherlands and EU Format -->
      <xsl:when test="$countryCode = 'NL' or $countryCode = 'DE' or $countryCode = 'FR' or $countryCode = 'IT' or $countryCode = 'ES' or $countryCode = 'AT' or $countryCode = 'BE' or $countryCode = 'CH'">
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
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
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:when>
      
      <!-- Default/Fallback Format -->
      <xsl:otherwise>
        <!-- Street lines -->
        <xsl:for-each select="$party/Street">
          <fo:block><xsl:value-of select="." /></fo:block>
        </xsl:for-each>
        <!-- District (if present) -->
        <xsl:if test="$party/District">
          <fo:block><xsl:value-of select="$party/District" /></fo:block>
        </xsl:if>
        <!-- City -->
        <xsl:if test="$party/City">
          <fo:block><xsl:value-of select="$party/City" /></fo:block>
        </xsl:if>
        <!-- State/Province -->
        <xsl:if test="$party/StateProvince">
          <fo:block><xsl:value-of select="$party/StateProvince" /></fo:block>
        </xsl:if>
        <!-- ZIP -->
        <xsl:if test="$party/ZipCode">
          <fo:block><xsl:value-of select="$party/ZipCode" /></fo:block>
        </xsl:if>
        <!-- Country -->
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
