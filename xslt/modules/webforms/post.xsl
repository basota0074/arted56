<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'webforms'][@method = 'post']">
        <xsl:apply-templates select="document('udata://webforms/post/')/udata" />
    </xsl:template>

    <xsl:template match="udata[@module = 'webforms'][@method = 'post']">
        <xsl:value-of select="error" disable-output-escaping="yes" />
    </xsl:template>

</xsl:stylesheet>