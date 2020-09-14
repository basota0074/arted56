<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Одинаковый content на страницах -->
	<xsl:template match="result" mode="company_content_simple"/>

	<!-- Разный content на страницах -->
	<xsl:template match="result" mode="company_content_complex"/>


	<xsl:template match="result" mode="company_content_simple">
		<xsl:param name="tpl" select="'content_c1'"/>
		<xsl:call-template name="content_in_simple">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="result" mode="company_content_complex">
		<xsl:param name="tpl" select="'content_c1'"/>
		<xsl:call-template name="content_in_complex">
			<xsl:with-param name="tpl" select="$tpl"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="content_in_simple">
		<xsl:param name="tpl" select="'content_c1'"/>
		<xsl:if test="$tpl = 'content_c1'">
			<xsl:call-template name="content_in_simple_c1"/>
		</xsl:if>
	</xsl:template>


	<xsl:template name="content_in_complex">
		<xsl:param name="tpl" select="'content_c1'"/>
		<xsl:if test="$tpl = 'content_c1'">
			<xsl:choose>
				<xsl:when test="page/@is-default">
					<xsl:call-template name="content_in_complex_main_c1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="content_in_complex_c1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>