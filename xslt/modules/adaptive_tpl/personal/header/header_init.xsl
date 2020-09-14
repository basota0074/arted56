<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Одинаковый header на страницах -->
	<xsl:template match="result" mode="personal_header_simple"/>

	<!-- Разный header на страницах -->
	<xsl:template match="result" mode="personal_header_complex"/>


	<xsl:template match="result" mode="personal_header_simple">
		<xsl:param name="tpl" select="'header_p1'"/>
		<xsl:call-template name="personal_header_in_simple">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="result" mode="personal_header_complex">
		<xsl:param name="tpl" select="'header_p1'"/>
		<xsl:call-template name="personal_header_in_complex">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="personal_header_in_simple">
		<xsl:param name="tpl" select="'header_p1'"/>
		<xsl:if test="$tpl = 'header_p1'">
			<xsl:call-template name="personal_header_in_simple_p1"/>
		</xsl:if>
	</xsl:template>


	<xsl:template name="personal_header_in_complex">
		<xsl:param name="tpl" select="'header_p1'"/>
		<xsl:if test="$tpl = 'header_p1'">
			<xsl:choose>
				<xsl:when test="page/@is-default">
					<xsl:call-template name="personal_header_in_complex_main_p1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="personal_header_in_complex_p1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>