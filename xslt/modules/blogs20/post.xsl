<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@module = 'blogs20'][@method = 'post']">
		<div class="blog_post_date main_bottom_date" umi:element-id="{$pageId}">	
			<span umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
				<xsl:apply-templates select="//property[@name = 'publish_time']">
					<xsl:with-param name="date_format" select="$newsDateFormat" />
				</xsl:apply-templates>
			</span>
		</div>
		<div umi:element-id="{$pageId}" class="blog">
			<xsl:if test="(//property[@name = 'tags']) or ($isAdmin = 1)">
				<div class="tags">
					<xsl:if test="//property[@name = 'tags']">
						<xsl:text>( </xsl:text>
					</xsl:if>
					<span umi:field-name="tags" umi:field-type="tags" umi:empty="&empty-tags;">
						<xsl:apply-templates select="//property[@name = 'tags']">
							<xsl:with-param name="tag_link" select="'/blogs20/postsByTag/'" />
						</xsl:apply-templates>
					</span>
					<xsl:if test="//property[@name = 'tags']">
						<xsl:text> )</xsl:text>
					</xsl:if>
				</div>
			</xsl:if>
			<div id="page_content_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="content" umi:field-type="wysiwyg" umi:empty="&empty-blog-anons;">
				<xsl:apply-templates select="//property[@name = 'content']" />
			</div>
			<div id="page_main_content_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="main_content" umi:field-type="wysiwyg" umi:empty="&empty-page-content;">
				<xsl:apply-templates select="//property[@name = 'main_content']" />
			</div>
		</div>
		
		<!--Файлы для скачивания-->
		<xsl:apply-templates select="document(concat('udata://filemanager/list_files/',$pageId,'//1000/1/'))/udata" />
		<!--Конец-->
		
		<!--Социальный блок-->
		<xsl:if test="$infoPageSocial/property[@name = 'show_social_block_blog']/value = 1">
			<xsl:call-template name="like_block"/>
		</xsl:if>
		<!--Конец-->
		
		<!--Комментарии-->
		<xsl:call-template name="comments">
			<xsl:with-param name="url" select="concat('http://',$_http_host,page/@link)" />
		</xsl:call-template>
		<!--Конец-->
    </xsl:template>

</xsl:stylesheet>