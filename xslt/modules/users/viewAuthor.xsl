<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="udata[@method = 'viewAuthor']">
        <xsl:apply-templates select="fname" />
        <xsl:apply-templates select="lname" />
        <xsl:apply-templates select="nickname" />
    </xsl:template>

    <xsl:template match="fname|lname">
        <xsl:value-of select="." />
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="nickname">
        <xsl:value-of select="." />
    </xsl:template>

</xsl:stylesheet>