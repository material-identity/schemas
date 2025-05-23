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
          <xsl:variable name="partyPaddingBottom" select="'4pt'" />
          <xsl:variable name="logoPaddingBottom" select="'10pt'" />
          <xsl:variable name="fontSizeSmall" select="'6pt'" />

          <xsl:variable name="i18n" select="Root/Translations" />
          <xsl:variable name="Parties" select="Root/Certificate/Parties" />
          <xsl:variable name="Standard" select="Root/Certificate/Standard" />
          <xsl:variable name="Order" select="Root/Certificate/BusinessTransaction/Order" />
          <xsl:variable name="Delivery" select="Root/Certificate/BusinessTransaction/Delivery" />
          <xsl:variable name="Product" select="Root/Certificate/Product" />
          <xsl:variable name="Analysis" select="Root/Certificate/Analysis" />
          <xsl:variable name="Disclaimer" select="Root/Certificate/Disclaimer" />
          <xsl:variable name="Contacts" select="Root/Certificate/Contacts" />
          <xsl:variable name="Attachments" select="Root/Certificate/Attachments" />
          <fo:block font-size="8pt">
            <!-- Parties -->
            <fo:table table-layout="fixed" width="100%">
              <xsl:choose>
                <xsl:when test="exists($Parties/GoodsReceiver) and exists($Parties/Receiver)">
                  <fo:table-column column-width="33%" />
                  <fo:table-column column-width="33%" />
                  <fo:table-column column-width="33%" />
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell number-columns-spanned="2" padding-bottom="{$logoPaddingBottom}">
                        <fo:block>
                          <fo:external-graphic fox:alt-text="Company Logo" src="{Root/Certificate/Logo}" content-height="48px" height="48px" />
                        </fo:block>
                      </fo:table-cell>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="$i18n/Certificate/Manufacturer" />
                        <xsl:with-param name="party" select="$Parties/Manufacturer" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="$i18n/Certificate/Customer" />
                        <xsl:with-param name="party" select="$Parties/Customer" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="$i18n/Certificate/Receiver" />
                        <xsl:with-param name="party" select="$Parties/Receiver" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="$i18n/Certificate/GoodsReceiver" />
                        <xsl:with-param name="party" select="$Parties/GoodsReceiver" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </xsl:when>
                <xsl:otherwise>
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell number-columns-spanned="1">
                        <fo:block>
                          <fo:external-graphic fox:alt-text="Company Logo" src="{Root/Certificate/Logo}" content-height="48px" height="48px" />
                        </fo:block>
                      </fo:table-cell>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="party" select="$Parties/Manufacturer" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                    <fo:table-row>
                      <xsl:call-template name="PartyInfo">
                        <xsl:with-param name="title" select="$i18n/Certificate/Customer" />
                        <xsl:with-param name="party" select="$Parties/Customer" />
                        <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                      </xsl:call-template>
                      <xsl:if test="exists($Parties/Receiver)">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="$i18n/Certificate/Receiver" />
                          <xsl:with-param name="party" select="$Parties/Receiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="exists($Parties/GoodsReceiver)">
                        <xsl:call-template name="PartyInfo">
                          <xsl:with-param name="title" select="$i18n/Certificate/GoodsReceiver" />
                          <xsl:with-param name="party" select="$Parties/GoodsReceiver" />
                          <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
                        </xsl:call-template>
                      </xsl:if>
                    </fo:table-row>
                  </fo:table-body>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table>

            <!-- Certificate info -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="concat($i18n/Certificate/Certificate, ' ', $Standard/Norm, ' ', $Standard/Type)" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-column column-width="30%" />
              <fo:table-column column-width="20%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="$i18n/Certificate/Id" />
                    <xsl:with-param name="value" select="Root/Certificate/Id" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                  <xsl:call-template name="KeyValue">
                    <xsl:with-param name="key" select="$i18n/Certificate/Date" />
                    <xsl:with-param name="value" select="Root/Certificate/Date" />
                    <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                  </xsl:call-template>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- Business data -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/BusinessTransaction" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell padding-right="12pt">
                    <xsl:call-template name="SectionTitleSmall">
                      <xsl:with-param name="title" select="$i18n/Certificate/Order" />
                    </xsl:call-template>
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="70%" />
                      <fo:table-column column-width="30%" />
                      <fo:table-body>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/OrderId" />
                            <xsl:with-param name="value" select="$Order/Id" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/OrderPosition" />
                            <xsl:with-param name="value" select="$Order/Position" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/OrderQuantity" />
                            <xsl:with-param name="value" select="concat($Order/Quantity, ' ',$Order/QuantityUnit)" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/OrderDate" />
                            <xsl:with-param name="value" select="$Order/Date" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/CustomerProductId" />
                            <xsl:with-param name="value" select="$Order/CustomerProductId" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/CustomerProductName" />
                            <xsl:with-param name="value" select="$Order/CustomerProductName" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/GoodsReceiptId" />
                            <xsl:with-param name="value" select="$Order/GoodsReceiptId" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                  <fo:table-cell>
                    <xsl:call-template name="SectionTitleSmall">
                      <xsl:with-param name="title" select="$i18n/Certificate/Delivery" />
                    </xsl:call-template>
                    <fo:table table-layout="fixed" width="100%">
                      <fo:table-column column-width="70%" />
                      <fo:table-column column-width="30%" />
                      <fo:table-body>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/DeliveryId" />
                            <xsl:with-param name="value" select="$Delivery/Id" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/DeliveryPosition" />
                            <xsl:with-param name="value" select="$Delivery/Position" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/DeliveryQuantity" />
                            <xsl:with-param name="value" select="concat($Delivery/Quantity, ' ',$Delivery/QuantityUnit)" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/DeliveryDate" />
                            <xsl:with-param name="value" select="$Delivery/Date" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/InternalOrderId" />
                            <xsl:with-param name="value" select="$Delivery/InternalOrderId" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/InternalOrderPosition" />
                            <xsl:with-param name="value" select="$Delivery/InternalOrderPosition" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                        <fo:table-row>
                          <xsl:call-template name="KeyValue">
                            <xsl:with-param name="key" select="$i18n/Certificate/Transport" />
                            <xsl:with-param name="value" select="$Delivery/Transport" />
                            <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                          </xsl:call-template>
                        </fo:table-row>
                      </fo:table-body>
                    </fo:table>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- Product -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/Product" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <xsl:if test="$Product/Id">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/ProductId" />
                      <xsl:with-param name="value" select="$Product/Id" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/Name">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/ProductName" />
                      <xsl:with-param name="value" select="$Product/Name" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/CountryOfOrigin">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/CountryOfOrigin" />
                      <xsl:with-param name="value" select="$Product/CountryOfOrigin" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/PlaceOfOrigin">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/PlaceOfOrigin" />
                      <xsl:with-param name="value" select="$Product/PlaceOfOrigin" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/FillingBatchId">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/FillingBatchId" />
                      <xsl:with-param name="value" select="$Product/FillingBatchId" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/FillingBatchDate">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/FillingBatchDate" />
                      <xsl:with-param name="value" select="$Product/FillingBatchDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/ProductionBatchId">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/ProductionBatchId" />
                      <xsl:with-param name="value" select="$Product/ProductionBatchId" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/ProductionDate">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/ProductionDate" />
                      <xsl:with-param name="value" select="$Product/ProductionDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/ExpirationDate">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/ExpirationDate" />
                      <xsl:with-param name="value" select="$Product/ExpirationDate" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/Standards">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/Standards" />
                      <xsl:with-param name="value" select="string-join($Product/Standards, ', ')" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
                <xsl:if test="$Product/AdditionalInformation">
                  <fo:table-row>
                    <xsl:call-template name="KeyValue">
                      <xsl:with-param name="key" select="$i18n/Certificate/AdditionalInformation" />
                      <xsl:with-param name="value" select="string-join($Product/AdditionalInformation, ', ')" />
                      <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                    </xsl:call-template>
                  </fo:table-row>
                </xsl:if>
              </fo:table-body>
            </fo:table>
            <!-- Inspections -->
            <xsl:if test="$Analysis/Inspections">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/Inspections" />
              </xsl:call-template>
              <xsl:if test="$Analysis/LotId">
                <fo:table table-layout="fixed" width="100%">
                  <fo:table-column column-width="50%" />
                  <fo:table-column column-width="50%" />
                  <fo:table-body>
                    <fo:table-row>
                      <xsl:call-template name="KeyValue">
                        <xsl:with-param name="key" select="$i18n/Certificate/LotId" />
                        <xsl:with-param name="value" select="$Analysis/LotId" />
                        <xsl:with-param name="paddingBottom" select="$cellPaddingBottom" />
                      </xsl:call-template>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="15%" />
                <fo:table-column column-width="15%" />
                <fo:table-column column-width="14%" />
                <fo:table-column column-width="14%" />
                <fo:table-column column-width="14%" />
                <fo:table-column column-width="14%" />
                <fo:table-column column-width="14%" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-right="4pt">
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Property" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Method" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Unit" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Value" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Minimum" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic">
                        <xsl:value-of select="$i18n/Certificate/Maximum" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                      <fo:block font-style="italic" margin-bottom="4pt">
                        <xsl:value-of select="$i18n/Certificate/TestConditions" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:for-each select="$Analysis/Inspections">
                    <fo:table-row>
                      <fo:table-cell>
                        <fo:block font-family="NotoSans, NotoSansSC" font-style="italic">
                          <xsl:value-of select="Property" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Method" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Unit" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Value" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Minimum" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="Maximum" />
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell>
                        <fo:block>
                          <xsl:value-of select="TestConditions" />
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:for-each>
                </fo:table-body>
              </fo:table>
              <!-- Inspections - Additional Information -->
              <xsl:if test="$Analysis/AdditionalInformation">
                <xsl:call-template name="SectionTitleSmall">
                  <xsl:with-param name="title" select="$i18n/Certificate/AdditionalInformation" />
                </xsl:call-template>
                <fo:table table-layout="fixed" margin-top="8pt" width="100%">
                  <fo:table-column column-width="100%" />
                  <fo:table-body>
                    <xsl:for-each select="$Analysis/AdditionalInformation">
                      <fo:table-row>
                        <fo:table-cell>
                          <fo:block>
                            <xsl:value-of select="." />
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:for-each>
                  </fo:table-body>
                </fo:table>
              </xsl:if>
            </xsl:if>
            <!-- Declaration -->
            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="$i18n/Certificate/DeclarationOfConformity" />
            </xsl:call-template>
            <fo:block>
              <xsl:value-of select="Root/Certificate/DeclarationOfConformity/Declaration" />
            </fo:block>

            <!-- Disclaimer -->
            <xsl:if test="exists($Disclaimer)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/Disclaimer" />
              </xsl:call-template>
              <fo:block font-size="{$fontSizeSmall}">
                <xsl:value-of select="Root/Certificate/Disclaimer" />
              </fo:block>
            </xsl:if>

            <!-- Contact persons -->
            <xsl:if test="exists($Contacts)">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="$i18n/Certificate/Contacts" />
              </xsl:call-template>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="20%" />
                <fo:table-column column-width="20%" />
                <fo:table-column column-width="20%" />
                <fo:table-column column-width="20%" />
                <fo:table-column column-width="20%" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-bottom="{$cellPaddingBottom}">
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/Certificate/ContactName" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/Certificate/ContactRole" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/Certificate/ContactDepartment" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/Certificate/ContactEmail" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block font-weight="bold">
                        <xsl:value-of select="$i18n/Certificate/ContactPhone" />
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
      <fo:block>
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
</xsl:stylesheet>