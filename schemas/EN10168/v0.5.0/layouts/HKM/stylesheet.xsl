<?xml version="1.0" encoding="UTF-8"?>
<!-- SPDX-License-Identifier: CC-BY-4.0 -->
<!-- HKM custom layout (customers/HKM/CUSTOM_LAYOUT.md): imports the standard EN10168 v0.5.0
     stylesheet and overrides only the parties block and the two chemistry-table border hooks.
     Everything else — including future base fixes and i18n — is inherited unchanged. -->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">
  <!-- Path is classpath-root-relative, not file-relative: LegacyRenderService's baseUri is the
       classpath root (json-doc() calls elsewhere in this codebase rely on that), not this file's
       own directory, so a "../../"-style relative href would resolve incorrectly. -->
  <xsl:import href="schemas/EN10168/v0.5.0/stylesheet.xsl" />

  <!-- Chemistry table: horizontal rule between Symbol/Unit and between Max/Actual. Only drawn
       when the Max row itself renders (Min/Max are individually optional per EN10168) — no rule
       appears above Actual for a table block with no Max values. Known limitation, flagged back
       to HKM rather than guessed at (see CUSTOM_LAYOUT.md open questions). -->
  <xsl:attribute-set name="chem-table-symbol-row">
    <xsl:attribute name="border-bottom">solid 0.5pt black</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="chem-table-max-row">
    <xsl:attribute name="border-bottom">solid 0.5pt black</xsl:attribute>
  </xsl:attribute-set>

  <!-- Parties: manufacturer's mark/logo (A04), sized to match the A01 column beneath it (not
       full page width) — the column width depends on how many of A06/A06.1..A06.4 are present,
       so the logo and party row share the same column-width computation. -->
  <xsl:template name="RenderParties">
    <xsl:param name="i18n" />
    <xsl:param name="CommercialTransaction" />
    <xsl:param name="partyPaddingBottom" />

    <xsl:variable name="secondPartyName" select="if (exists($CommercialTransaction/A06)) then 'A06' else 'A06.1'" />
    <xsl:variable name="extraPartyNames" select="for $index in 2 to 4
                                                  return concat('A06.', $index)[exists($CommercialTransaction/*[name() = concat('A06.', $index)])]" />
    <xsl:variable name="partyNames" select="('A01', $secondPartyName, $extraPartyNames)" />
    <xsl:variable name="partyCount" select="count($partyNames)" />

    <!-- Usable body width (page-width 21cm minus the 1cm page margin and 0.25cm region-body
         margin on each side, per the base stylesheet's fo:simple-page-master/fo:region-body).
         Computed absolutely rather than via a "100%"-percentage graphic width: FOP does not
         reliably resolve fo:external-graphic percentages against a table cell that is the only
         cell in a multi-column row (the graphic rendered far wider than the cell in testing). -->
    <xsl:variable name="logoColumnWidth" select="18.5 div $partyCount" />

    <fo:table table-layout="fixed" width="100%">
      <xsl:for-each select="1 to $partyCount">
        <fo:table-column column-width="{100 div $partyCount}%" />
      </xsl:for-each>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell padding-bottom="{$partyPaddingBottom}">
            <fo:block padding-bottom="{$partyPaddingBottom}" font-style="italic"> A04 <xsl:value-of select="$i18n/Certificate/A04" />
            </fo:block>
            <fo:block>
              <fo:external-graphic fox:alt-text="Company Logo" src="{$CommercialTransaction/A04}" width="{$logoColumnWidth}cm" content-width="{$logoColumnWidth}cm" scaling="uniform" />
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <fo:table table-layout="fixed" width="100%">
      <xsl:for-each select="1 to $partyCount">
        <fo:table-column column-width="{100 div $partyCount}%" />
      </xsl:for-each>
      <fo:table-body>
        <fo:table-row>
          <xsl:for-each select="$partyNames">
            <xsl:variable name="elementName" select="." />
            <xsl:call-template name="PartyInfo">
              <xsl:with-param name="number" select="concat($elementName, ' ')" />
              <xsl:with-param name="title" select="$i18n/Certificate/*[name() = $elementName]" />
              <xsl:with-param name="party" select="$CommercialTransaction/*[name() = $elementName]" />
              <xsl:with-param name="paddingBottom" select="$partyPaddingBottom" />
            </xsl:call-template>
          </xsl:for-each>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
</xsl:stylesheet>
