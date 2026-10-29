<?xml version="1.0" encoding="UTF-8"?>
<!--
  Generic certificate rendering (platform #2383): one stylesheet for every company specification
  built on the Generic base schema. The header, the parties block, the business transaction, the
  product and the validation block have fixed layouts; every other property under DigitalMaterialPassport is
  rendered as key/value tables, and arrays of records (regular and tuple arrays) as grids, so fields
  a specification adds beyond the base schema still show up. Labels come from Root/Translations (translations.json merged over the certificate's
  Languages); an unknown key falls back to its name split at capital letters. Keys that were
  rewritten to legal XML names (XmlKeySanitizer) carry their original text in Root/Labels. The
  certificate itself is Root/Certificate, so none of its keys can collide with those the renderer
  adds beside it.
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:gen="urn:material-identity:generic-stylesheet"
  exclude-result-prefixes="xs gen">

  <xsl:variable name="i18n" select="/Root/Translations" />
  <xsl:variable name="labels" select="/Root/Labels" />
  <xsl:variable name="fixedSections" select="('Id', 'Title', 'IssueDate', 'Languages', 'TransactionData', 'Product', 'Validation', 'Attachments')" />
  <!-- Grid columns that name a record lead, so each row reads as "what" before its values. -->
  <xsl:variable name="identifyingKeys" select="('Name', 'PropertyName', 'PropertySymbol', 'Symbol', 'Parameter')" />
  <xsl:variable name="maxGridColumns" select="8" />
  <xsl:variable name="indent" select="8" />
  <!-- An array directly inside an array arrives as an element holding its members under this name. -->
  <xsl:variable name="arrayItem" select="string(/Root/ArrayItem)" />

  <xsl:function name="gen:is-row" as="xs:boolean">
    <xsl:param name="node" as="element()" />
    <xsl:sequence select="exists($node/*) and (every $child in $node/* satisfies name($child) = $arrayItem)" />
  </xsl:function>

  <!-- An empty value (null, an empty array or object) shows as a dash rather than nothing. -->
  <xsl:function name="gen:value" as="xs:string">
    <xsl:param name="text" as="xs:string" />
    <xsl:sequence select="if (normalize-space($text) = '') then '–' else $text" />
  </xsl:function>

  <xsl:function name="gen:label" as="xs:string">
    <xsl:param name="key" as="xs:string" />
    <xsl:variable name="original" select="string(($labels/*[name() = $key])[1])" as="xs:string" />
    <xsl:variable name="translated" select="string(($i18n/*[name() = $key])[1])" as="xs:string" />
    <xsl:sequence select="if ($original != '') then $original else if ($translated != '') then $translated else replace($key, '([a-z0-9])([A-Z])', '$1 $2')" />
  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="cert" select="Root/Certificate/DigitalMaterialPassport" />
    <xsl:variable name="headerExtent" select="concat(
      (if ($cert/TransactionData/Parties/Manufacturer/Logo) then 2.3 else 1.0) + (if (count($cert/Languages) gt 1) then 0.5 else 0),
      'cm')" />
    <!-- The document language is the certificate's first language (EN when it names none). -->
    <fo:root xml:lang="{lower-case(string(($cert/Languages[normalize-space()], 'EN')[1]))}">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin="1cm">
          <fo:region-body margin="0.25cm" margin-top="{$headerExtent} + 0.2cm" margin-bottom="1.2cm" />
          <fo:region-before extent="{$headerExtent}" />
          <fo:region-after extent="1cm" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="simple">

        <fo:static-content flow-name="xsl-region-before">
          <fo:block font-family="NotoSans, NotoSansSC" font-size="7.5pt" padding-top="0.25cm">
            <fo:table table-layout="fixed" width="100%" border-bottom="0.8pt solid #2b4a6f">
              <fo:table-column column-width="55%" />
              <fo:table-column column-width="45%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <xsl:if test="$cert/TransactionData/Parties/Manufacturer/Logo">
                      <fo:block padding-bottom="4pt">
                        <fo:external-graphic fox:alt-text="Company Logo" src="{$cert/TransactionData/Parties/Manufacturer/Logo}" content-height="36px" height="36px" />
                      </fo:block>
                    </xsl:if>
                    <fo:block font-size="13pt" font-weight="bold">
                      <xsl:value-of select="if ($cert/Title != '') then $cert/Title else gen:label('Certificate')" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell display-align="after">
                    <fo:block />
                    <xsl:if test="$cert/Id != ''">
                      <fo:block text-align="right">
                        <fo:inline font-style="italic"><xsl:value-of select="gen:label('CertificateId')" /><xsl:text> </xsl:text></fo:inline>
                        <fo:inline font-weight="bold"><xsl:value-of select="$cert/Id" /></fo:inline>
                      </fo:block>
                    </xsl:if>
                    <xsl:if test="$cert/IssueDate != ''">
                      <fo:block text-align="right">
                        <fo:inline font-style="italic"><xsl:value-of select="gen:label('IssueDate')" /><xsl:text> </xsl:text></fo:inline>
                        <fo:inline font-weight="bold"><xsl:value-of select="$cert/IssueDate" /></fo:inline>
                      </fo:block>
                    </xsl:if>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-family="NotoSans, NotoSansSC" font-size="6.5pt" color="#666666">
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="80%" />
              <fo:table-column column-width="20%" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell><fo:block><xsl:value-of select="Root/Certificate/RefSchemaUrl" /></fo:block></fo:table-cell>
                  <fo:table-cell>
                    <fo:block text-align="right">
                      <fo:page-number />
                      <xsl:text> / </xsl:text>
                      <fo:page-number-citation-last ref-id="last-page" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body" font-family="NotoSans, NotoSansSC">
          <fo:block font-size="7.5pt">

            <xsl:call-template name="SectionTitle">
              <xsl:with-param name="title" select="gen:label('Parties')" />
            </xsl:call-template>
            <fo:table table-layout="fixed" width="100%">
              <fo:table-column column-width="50%" />
              <fo:table-column column-width="50%" />
              <fo:table-body>
                <fo:table-row>
                  <xsl:call-template name="PartyCell">
                    <xsl:with-param name="party" select="$cert/TransactionData/Parties/Manufacturer" />
                  </xsl:call-template>
                  <xsl:call-template name="PartyCell">
                    <xsl:with-param name="party" select="$cert/TransactionData/Parties/Customer" />
                  </xsl:call-template>
                </fo:table-row>
                <xsl:for-each-group select="$cert/TransactionData/Parties/*[not(name() = ('Manufacturer', 'Customer'))]"
                                    group-adjacent="(position() - 1) idiv 2">
                  <fo:table-row>
                    <xsl:for-each select="current-group()">
                      <xsl:call-template name="PartyCell">
                        <xsl:with-param name="party" select="." />
                      </xsl:call-template>
                    </xsl:for-each>
                    <xsl:if test="count(current-group()) = 1">
                      <fo:table-cell><fo:block /></fo:table-cell>
                    </xsl:if>
                  </fo:table-row>
                </xsl:for-each-group>
              </fo:table-body>
            </fo:table>

            <xsl:if test="$cert/TransactionData/BusinessTransaction/*">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="gen:label('BusinessTransaction')" />
              </xsl:call-template>
              <xsl:variable name="documents" select="$cert/TransactionData/BusinessTransaction/*" />
              <fo:table table-layout="fixed" width="100%">
                <xsl:for-each select="$documents">
                  <fo:table-column column-width="{100 div count($documents)}%" />
                </xsl:for-each>
                <fo:table-body>
                  <fo:table-row>
                    <xsl:for-each select="$documents">
                      <fo:table-cell padding="2pt" padding-right="8pt">
                        <fo:block font-weight="bold" color="#555555" padding-bottom="2pt">
                          <xsl:value-of select="gen:label(name())" />
                        </fo:block>
                        <xsl:choose>
                          <xsl:when test="*">
                            <xsl:call-template name="ObjectTable">
                              <xsl:with-param name="node" select="." />
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <fo:block><xsl:value-of select="." /></fo:block>
                          </xsl:otherwise>
                        </xsl:choose>
                      </fo:table-cell>
                    </xsl:for-each>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </xsl:if>

            <xsl:call-template name="Sections">
              <xsl:with-param name="nodes" select="$cert/TransactionData/*[not(name() = ('Parties', 'BusinessTransaction'))]" />
            </xsl:call-template>

            <xsl:if test="$cert/Product/*">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="gen:label('Product')" />
              </xsl:call-template>
              <xsl:if test="$cert/Product/Name != ''">
                <fo:block font-weight="bold" font-size="8.5pt" padding-bottom="2pt">
                  <xsl:value-of select="$cert/Product/Name" />
                </fo:block>
              </xsl:if>
              <xsl:if test="$cert/Product/Description != ''">
                <fo:block padding-bottom="3pt">
                  <xsl:value-of select="$cert/Product/Description" />
                </fo:block>
              </xsl:if>
              <xsl:call-template name="ObjectTable">
                <xsl:with-param name="node" select="$cert/Product" />
                <xsl:with-param name="skip" select="('Name', 'Description')" />
              </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="Sections">
              <xsl:with-param name="nodes" select="$cert/*[not(name() = $fixedSections)]" />
            </xsl:call-template>

            <!-- Attachments by the other families' convention carry the file itself in Data (base64);
                 the PDF lists them by everything else. -->
            <xsl:variable name="attachments" as="element()*">
              <xsl:for-each select="$cert/Attachments">
                <xsl:copy><xsl:copy-of select="node()[not(self::Data)]" /></xsl:copy>
              </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="Sections">
              <xsl:with-param name="nodes" select="$attachments" />
            </xsl:call-template>

            <xsl:if test="$cert/Validation/*">
              <xsl:call-template name="SectionTitle">
                <xsl:with-param name="title" select="gen:label('Validation')" />
              </xsl:call-template>
              <xsl:variable name="validation" select="$cert/Validation" />
              <xsl:if test="$validation/ValidationStatement/Statement != ''">
                <fo:block padding-bottom="3pt" font-style="italic">
                  <xsl:value-of select="$validation/ValidationStatement/Statement" />
                </fo:block>
              </xsl:if>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell padding-right="8pt">
                      <fo:block />
                      <xsl:call-template name="ObjectTable">
                        <xsl:with-param name="node" select="$validation/ValidationStatement" />
                        <xsl:with-param name="skip" select="('Statement')" />
                      </xsl:call-template>
                      <xsl:call-template name="ObjectTable">
                        <xsl:with-param name="node" select="$validation" />
                        <xsl:with-param name="skip" select="('ValidationStatement', 'Validators', 'Disclaimer')" />
                      </xsl:call-template>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block />
                      <xsl:if test="$validation/Validators">
                        <fo:block font-style="italic" color="#555555" padding-bottom="1.5pt">
                          <xsl:value-of select="gen:label('Validators')" />
                        </fo:block>
                        <xsl:for-each select="$validation/Validators">
                          <fo:block padding-bottom="1.5pt">
                            <fo:inline font-weight="bold"><xsl:value-of select="Name" /></fo:inline>
                            <xsl:for-each select="Title | Department">
                              <xsl:text>, </xsl:text>
                              <xsl:value-of select="." />
                            </xsl:for-each>
                          </fo:block>
                          <xsl:if test="StampImage != ''">
                            <fo:block padding-bottom="2pt">
                              <fo:external-graphic fox:alt-text="Stamp" src="{StampImage}" content-height="48px" height="48px" />
                            </fo:block>
                          </xsl:if>
                          <fo:block margin-left="6pt">
                            <xsl:call-template name="ObjectTable">
                              <xsl:with-param name="node" select="." />
                              <xsl:with-param name="skip" select="('Name', 'Title', 'Department', 'StampImage')" />
                            </xsl:call-template>
                          </fo:block>
                        </xsl:for-each>
                      </xsl:if>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
              <xsl:if test="$validation/Disclaimer != ''">
                <fo:block padding-top="4pt" font-size="6.5pt" color="#666666">
                  <xsl:value-of select="$validation/Disclaimer" />
                </fo:block>
              </xsl:if>
            </xsl:if>

            <fo:block id="last-page" />
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="SectionTitle">
    <xsl:param name="title" />
    <fo:block font-size="9pt" font-weight="bold" color="#2b4a6f" space-before="8pt" space-after="3pt" border-bottom="solid 0.5pt #bfbfbf" keep-with-next.within-page="always">
      <xsl:value-of select="$title" />
    </fo:block>
  </xsl:template>

  <!-- One party: name, address, contact, identifiers. The role label is the element name. -->
  <xsl:template name="PartyCell">
    <xsl:param name="party" />
    <fo:table-cell padding="2pt" padding-right="8pt">
      <fo:block font-weight="bold" font-size="7pt" color="#555555" padding-bottom="1pt">
        <xsl:value-of select="gen:label(name($party))" />
      </fo:block>
      <fo:block font-weight="bold"><xsl:value-of select="$party/Name" /></fo:block>
      <xsl:for-each select="$party/Street">
        <fo:block><xsl:value-of select="." /></fo:block>
      </xsl:for-each>
      <xsl:if test="$party/District != ''">
        <fo:block><xsl:value-of select="$party/District" /></fo:block>
      </xsl:if>
      <xsl:if test="$party/ZipCode != '' or $party/City != '' or $party/StateProvince != ''">
        <fo:block>
          <xsl:value-of select="string-join(($party/ZipCode[. != ''], $party/City[. != ''], $party/StateProvince[. != '']), ' ')" />
        </fo:block>
      </xsl:if>
      <xsl:if test="$party/Country != ''">
        <fo:block><xsl:value-of select="$party/Country" /></fo:block>
      </xsl:if>
      <xsl:for-each select="$party/Email[. != '']">
        <fo:block>
          <fo:basic-link external-destination="{concat('mailto:', .)}">
            <fo:inline text-decoration="underline"><xsl:value-of select="." /></fo:inline>
          </fo:basic-link>
        </fo:block>
      </xsl:for-each>
      <xsl:if test="$party/Phone != ''">
        <fo:block><xsl:value-of select="$party/Phone" /></fo:block>
      </xsl:if>
      <xsl:for-each select="$party/Identifiers/*">
        <fo:block>
          <fo:inline font-style="italic" color="#555555"><xsl:value-of select="gen:label(name())" /><xsl:text>: </xsl:text></fo:inline>
          <xsl:value-of select="." />
        </fo:block>
      </xsl:for-each>
      <xsl:call-template name="ObjectTable">
        <xsl:with-param name="node" select="$party" />
        <xsl:with-param name="skip" select="('Name', 'Street', 'District', 'ZipCode', 'City', 'StateProvince', 'Country', 'Email', 'Phone', 'Identifiers', 'Logo')" />
      </xsl:call-template>
    </fo:table-cell>
  </xsl:template>

  <!--
    Properties without a fixed layout, one section per name: a scalar as text, an object as a
    key/value table, and the members of a JSON array together under a single title.
  -->
  <xsl:template name="Sections">
    <xsl:param name="nodes" />
    <xsl:for-each-group select="$nodes" group-by="name()">
      <xsl:call-template name="SectionTitle">
        <xsl:with-param name="title" select="gen:label(current-grouping-key())" />
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="not(current-group()/*)">
          <fo:block padding-bottom="3pt"><xsl:value-of select="gen:value(string-join(current-group(), ', '))" /></fo:block>
        </xsl:when>
        <xsl:when test="count(current-group()) = 1 and not(gen:is-row(.))">
          <xsl:call-template name="ObjectTable">
            <xsl:with-param name="node" select="." />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="38%" />
            <fo:table-column column-width="62%" />
            <fo:table-body>
              <xsl:call-template name="MemberRows">
                <xsl:with-param name="members" select="current-group()" />
                <xsl:with-param name="titled" select="true()" />
              </xsl:call-template>
            </fo:table-body>
          </fo:table>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!--
    Key/value table of an object's children. Nested objects add rows to the same table, their
    labels indented by depth, so every value at every depth starts in one column.
  -->
  <xsl:template name="ObjectTable">
    <xsl:param name="node" />
    <xsl:param name="skip" select="()" />
    <xsl:variable name="children" select="$node/*[not(name() = $skip)]" />
    <xsl:if test="$children">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="38%" />
        <fo:table-column column-width="62%" />
        <fo:table-body>
          <xsl:for-each-group select="$children" group-by="name()">
            <xsl:call-template name="MemberRows">
              <xsl:with-param name="members" select="current-group()" />
            </xsl:call-template>
          </xsl:for-each-group>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <!--
    Rows for the elements of one name: a single JSON value, or the members of a JSON array.
    - all scalars: one row, joined with ", "
    - all inner arrays of scalars (an array of arrays): a grid with one row per inner array, as long
      as none is wider than $maxGridColumns (a wider one would squeeze its cells unreadably thin)
    - several objects with flat values (regular and tuple arrays of records alike): a grid with one
      column per key, in first-seen order with the identifying keys first; a key a member lacks
      leaves its cell empty (so at least one key must be common to all), and an object in a cell
      lists its keys (an array of objects in a cell would not fit, so such members are stacked and
      the inner array gets the grid)
    - anything else: each member in order, numbered, an object as a heading over its own rows
    $titled: the section title already names the array, so the grid needs no heading of its own.
    $label: the members' name as printed; an inner array's members take their array's heading.
  -->
  <xsl:template name="MemberRows">
    <xsl:param name="members" />
    <xsl:param name="depth" select="0" />
    <xsl:param name="titled" select="false()" />
    <xsl:param name="label" select="gen:label(name($members[1]))" />
    <xsl:variable name="columns" select="distinct-values($members/*/name())" />
    <xsl:choose>
      <xsl:when test="not($members/*)">
        <xsl:call-template name="KeyValueRow">
          <xsl:with-param name="label" select="$label" />
          <xsl:with-param name="value" select="string-join($members, ', ')" />
          <xsl:with-param name="depth" select="$depth" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="(every $m in $members satisfies gen:is-row($m)) and not($members/*/*)
                      and (every $m in $members satisfies count($m/*) le $maxGridColumns)">
        <xsl:if test="not($titled)">
          <xsl:call-template name="HeadingRow">
            <xsl:with-param name="label" select="$label" />
            <xsl:with-param name="depth" select="$depth" />
          </xsl:call-template>
        </xsl:if>
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" padding-left="{$depth * $indent}pt" padding-top="1pt" padding-bottom="3pt">
            <xsl:call-template name="RowGrid">
              <xsl:with-param name="rows" select="$members" />
            </xsl:call-template>
          </fo:table-cell>
        </fo:table-row>
      </xsl:when>
      <xsl:when test="count($members) gt 1 and (every $m in $members satisfies ($m/* and not(gen:is-row($m))))
                      and not($members/*/*/*) and count($columns) le $maxGridColumns
                      and (some $key in $columns satisfies (every $m in $members satisfies $m/*[name() = $key]))
                      and (every $c in $members/*[*] satisfies count($c/../*[name() = name($c)]) = 1)">
        <xsl:if test="not($titled)">
          <xsl:call-template name="HeadingRow">
            <xsl:with-param name="label" select="$label" />
            <xsl:with-param name="depth" select="$depth" />
          </xsl:call-template>
        </xsl:if>
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" padding-left="{$depth * $indent}pt" padding-top="1pt" padding-bottom="3pt">
            <xsl:call-template name="RecordGrid">
              <xsl:with-param name="members" select="$members" />
              <xsl:with-param name="columns" select="(for $key in $identifyingKeys return $columns[. = $key], $columns[not(. = $identifyingKeys)])" />
            </xsl:call-template>
          </fo:table-cell>
        </fo:table-row>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$members">
          <xsl:variable name="heading" select="concat($label, if (count($members) gt 1) then concat(' ', position()) else '')" />
          <xsl:choose>
            <xsl:when test="gen:is-row(.) and not(*/*)">
              <xsl:call-template name="KeyValueRow">
                <xsl:with-param name="label" select="$heading" />
                <xsl:with-param name="value" select="string-join(* ! gen:value(string(.)), ', ')" />
                <xsl:with-param name="depth" select="$depth" />
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="*">
              <!-- the lone member of an inner array already sits under its array's heading -->
              <xsl:variable name="headed" select="not($titled and count($members) = 1)" />
              <xsl:if test="$headed">
                <xsl:call-template name="HeadingRow">
                  <xsl:with-param name="label" select="$heading" />
                  <xsl:with-param name="depth" select="$depth" />
                </xsl:call-template>
              </xsl:if>
              <xsl:for-each-group select="*" group-by="name()">
                <xsl:variable name="inner" select="current-grouping-key() = $arrayItem" />
                <xsl:call-template name="MemberRows">
                  <xsl:with-param name="members" select="current-group()" />
                  <xsl:with-param name="depth" select="if ($headed) then $depth + 1 else $depth" />
                  <xsl:with-param name="titled" select="$inner" />
                  <xsl:with-param name="label" select="if ($inner) then $heading else gen:label(current-grouping-key())" />
                </xsl:call-template>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="KeyValueRow">
                <xsl:with-param name="label" select="$heading" />
                <xsl:with-param name="value" select="string(.)" />
                <xsl:with-param name="depth" select="$depth" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="KeyValueRow">
    <xsl:param name="label" />
    <xsl:param name="value" />
    <xsl:param name="depth" />
    <fo:table-row>
      <fo:table-cell>
        <fo:block margin-left="{$depth * $indent}pt" padding-bottom="1.5pt" font-style="italic" color="#555555">
          <xsl:value-of select="$label" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block padding-bottom="1.5pt"><xsl:value-of select="gen:value($value)" /></fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template name="HeadingRow">
    <xsl:param name="label" />
    <xsl:param name="depth" />
    <fo:table-row keep-with-next.within-page="always">
      <fo:table-cell number-columns-spanned="2">
        <fo:block margin-left="{$depth * $indent}pt" padding-top="1.5pt" padding-bottom="1pt" font-weight="bold" color="#555555">
          <xsl:value-of select="$label" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <!--
    One row per array member, one column per key. A scalar array in a cell is joined with ", ";
    an object in a cell lists its keys one per line.
  -->
  <xsl:template name="RecordGrid">
    <xsl:param name="members" />
    <xsl:param name="columns" />
    <fo:table table-layout="fixed" width="100%" border="0.5pt solid #d0d7de">
      <xsl:for-each select="$columns">
        <fo:table-column column-width="proportional-column-width(1)" />
      </xsl:for-each>
      <fo:table-header>
        <fo:table-row background-color="#eef2f6">
          <xsl:for-each select="$columns">
            <fo:table-cell padding="1.5pt 3pt" border="0.5pt solid #d0d7de">
              <fo:block font-weight="bold" color="#555555"><xsl:value-of select="gen:label(.)" /></fo:block>
            </fo:table-cell>
          </xsl:for-each>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:for-each select="$members">
          <xsl:variable name="member" select="." />
          <fo:table-row keep-together.within-page="always">
            <xsl:for-each select="$columns">
              <xsl:variable name="cell" select="$member/*[name() = current()]" />
              <fo:table-cell padding="1.5pt 3pt" border="0.5pt solid #d0d7de">
                <xsl:choose>
                  <xsl:when test="$cell and (every $c in $cell satisfies gen:is-row($c))">
                    <xsl:for-each select="$cell">
                      <fo:block><xsl:value-of select="string-join(* ! gen:value(string(.)), ', ')" /></fo:block>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$cell/*">
                    <xsl:for-each-group select="$cell/*" group-by="name()">
                      <fo:block>
                        <fo:inline font-style="italic" color="#555555"><xsl:value-of select="gen:label(current-grouping-key())" /><xsl:text>: </xsl:text></fo:inline>
                        <xsl:value-of select="gen:value(string-join(current-group(), ', '))" />
                      </fo:block>
                    </xsl:for-each-group>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block><xsl:value-of select="if ($cell) then gen:value(string-join($cell, ', ')) else ''" /></fo:block>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- One row per inner array, its members in order; a shorter inner array leaves trailing cells empty. -->
  <xsl:template name="RowGrid">
    <xsl:param name="rows" />
    <xsl:variable name="width" select="max(for $row in $rows return count($row/*))" />
    <fo:table table-layout="fixed" width="100%" border="0.5pt solid #d0d7de">
      <xsl:for-each select="1 to $width">
        <fo:table-column column-width="proportional-column-width(1)" />
      </xsl:for-each>
      <fo:table-body>
        <xsl:for-each select="$rows">
          <xsl:variable name="row" select="." />
          <fo:table-row keep-together.within-page="always">
            <xsl:for-each select="1 to $width">
              <xsl:variable name="i" select="." />
              <fo:table-cell padding="1.5pt 3pt" border="0.5pt solid #d0d7de">
                <fo:block><xsl:value-of select="if ($row/*[$i]) then gen:value(string($row/*[$i])) else ''" /></fo:block>
              </fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

</xsl:stylesheet>
