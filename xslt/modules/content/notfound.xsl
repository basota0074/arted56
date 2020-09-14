<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@module = 'content'][@method = 'notfound']">
		<xsl:call-template name="not-found"/>
		<xsl:call-template name="sitemap" />
	</xsl:template>

	<xsl:template name="not-found">
		<div id="page404_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="page404_text" umi:field-type="string">
			<xsl:apply-templates select="$infoPage/property[@name = 'page404_text']" />
		</div>
	</xsl:template>

	<xsl:template name="sitemap">
		<div class="text sitemap">
			<h2>&sitemap-title;:</h2>
			<xsl:apply-templates select="document('udata://content/menu//4')/udata/items" mode="menu">
				<xsl:with-param name="parent" select="." />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="items" mode="menu">
		<ul>
			<xsl:apply-templates select="item" mode="menu" />
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="menu">
		<li>
			<a href="{@link}">
				<xsl:value-of select="@name" />
			</a>
			<xsl:apply-templates select="items" mode="menu" />
		</li>
	</xsl:template>

</xsl:stylesheet>