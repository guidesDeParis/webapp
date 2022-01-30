<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="3.1"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:output indent="yes" method="xml" encoding="UTF-8" />
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="abbr | cb | date | emph | expan | foreign | gap | geo | geogName | hi | item | l | label | lg | list | objectName | orgName |persName | placeName | q | quote | ref | rs | seg | sic | soCalled | supplied | surplus | title | trailer | unclear"></xsl:template>
  <xsl:template match="fw | pb | metamark | space"/>
  <xsl:template match="lb | num"><xsl:text> </xsl:text></xsl:template>
  <xsl:template match="bibl"></xsl:template>
  <xsl:template match="div">
    <div>
      <meta>
        <uuid><xsl:value-of select="@xml:id"/></uuid>
        <pages>
          <xsl:variable name="pageBefore" select="./preceding::fw[@type = 'pageNum'][1]"/>
          <xsl:variable name="fw" select=".//fw[@type = 'pageNum']"/>
          <prefix><xsl:value-of select="if ($fw) then 'pp.' else 'p.'"/></prefix>
          <range><xsl:value-of select="string-join(($pageBefore, $fw[last()]), '–')"/></range>
        </pages>
        <size><xsl:value-of select="count(tokenize(., '\W+')[. != ''])"/></size>
        <indexes>
          <xsl:call-template name="getIndexes">
            <xsl:with-param name="item" select="."/>
          </xsl:call-template>
          </indexes>
      </meta>
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template name="getIndexes">
    <xsl:param name="item"/>
    <xsl:param name="personsRefs" select="$item//persName union $item//orgName"></xsl:param>
    <xsl:param name="persons" select="for $personsRef in $personsRefs return substring-after($personsRef/@ref, '#') => distinct-values()"></xsl:param>
    <xsl:for-each select="$persons">
      <persons>
        <title><xsl:value-of select="$item/persName[1]"/></title>
        <uuid><xsl:value-of select="$item/@xml:id"/></uuid>
        <path><xsl:text>/indexNominum/</xsl:text></path>
        <!-- ajouter chemin racine -->
        <url><xsl:value-of select="'/indexNominum/' || $item/@xml:id"/></url>
      </persons>
    </xsl:for-each>
    <index></index>
  </xsl:template>
  
  <!-- identity copy -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>