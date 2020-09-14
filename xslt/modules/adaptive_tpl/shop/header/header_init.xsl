<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Одинаковый header на страницах -->
	<xsl:template match="result" mode="shop_header_simple"/>

	<!-- Разный header на страницах -->
	<xsl:template match="result" mode="shop_header_complex"/>


	<xsl:template match="result" mode="shop_header_simple">
		<xsl:param name="tpl" select="'header_s1'"/>
		<xsl:call-template name="shop_header_in_simple">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="result" mode="shop_header_complex">
		<xsl:param name="tpl" select="'header_s1'"/>
		<xsl:call-template name="shop_header_in_complex">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="shop_header_in_simple">
		<xsl:param name="tpl" select="'header_s1'"/>
		<xsl:if test="$tpl = 'header_s1'">
			<xsl:call-template name="header_in_simple_s1"/>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>