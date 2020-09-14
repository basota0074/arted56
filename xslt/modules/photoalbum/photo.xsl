<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'photoalbum'][@method = 'photo']">
        <div class="full_photo">
			<img umi:field-name="photo" umi:field-type="img_file" style="max-width:100%;">
				<xsl:attribute name="alt"><xsl:value-of select="//property[@name = 'h1']/value" /></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="//property[@name = 'h1']/value" /></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="//property[@name = 'photo']/value" /></xsl:attribute>
				<xsl:attribute name="umi:empty"><xsl:text>&empty-photo;</xsl:text></xsl:attribute>
				<xsl:attribute name="umi:element-id"><xsl:value-of select="$pageId" /></xsl:attribute>
			</img>
        </div>
        <div id="descr_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="descr" umi:field-type="wysiwyg" umi:empty="'&empty-page-content;'">
            <xsl:apply-templates select="//property[@name = 'descr']" />
        </div>
        
		<!--Социальный блок-->
		<xsl:call-template name="like_block"/>
		<!--Конец-->
        
        <!--Комментарии-->
		<xsl:call-template name="comments">
			<xsl:with-param name="url" select="concat('http://',$_http_host,page/@link)" />
		</xsl:call-template>
		<!--Конец-->
    </xsl:template>
    
</xsl:stylesheet>