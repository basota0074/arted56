<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@method = 'getEditForm']">
		<xsl:apply-templates select="group" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getEditForm']/group">
		<fieldset>
			<xsl:apply-templates select="field" />
		</fieldset>
	</xsl:template>

</xsl:stylesheet>