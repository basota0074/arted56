<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="udata[@method = 'price']">
        <xsl:apply-templates select="price" />
    </xsl:template>

    <xsl:template match="price|total-price">
        <span class="price_value">
            <xsl:value-of select="actual" disable-output-escaping="yes" />
        </span>
        <span umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
        </span>
    </xsl:template>

</xsl:stylesheet>