<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!-- Данные не предусмотренные шаблоном-->
	<xsl:template match="result">
		<xsl:call-template name="not-found"/>
	</xsl:template>

	<xsl:template match="property|page|content|object"/>

</xsl:stylesheet>