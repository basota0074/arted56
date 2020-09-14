<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="udata[@method = 'countComments']">
        <xsl:param name="link" />
        <a href="{$link}#add-comment" class="comments" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="nocomments_title" umi:field-type="string">
            <xsl:apply-templates select="$infoPage/property[@name = 'nocomments_title']" />
        </a>
    </xsl:template>

    <xsl:template match="udata[@method = 'countComments'][. &gt; 0]">
        <xsl:param name="link" />
        <a href="{$link}#comments" class="comments" >
            <span umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="comments_title" umi:field-type="string">
                <xsl:apply-templates select="$infoPage/property[@name = 'comments_title']" />
            </span>
        </a>
		&nbsp;
        <strong><xsl:value-of select="concat(' (', ., ')')" /></strong>
    </xsl:template>

</xsl:stylesheet>