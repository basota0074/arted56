<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Одинаковый footer на страницах -->
	<xsl:template match="result" mode="personal_footer_simple"/>


	<xsl:template match="result" mode="personal_footer_simple">
		<xsl:param name="tpl" select="'footer_p1'"/>
		<xsl:call-template name="personal_footer_in_simple">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="personal_footer_in_simple">
		<xsl:param name="tpl" select="'footer_p1'"/>
		<xsl:if test="$tpl = 'footer_p1'">
			<xsl:call-template name="personal_footer_in_simple_p1"/>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>