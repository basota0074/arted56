<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@module = 'blogs20' and @method = 'blog']">
		<xsl:variable name="blogPostPageTypeId" select="document('utype://blogs20~post')/udata/type/@id" />
		<div class="blog" umi:element-id="{$pageId}" umi:add-text="&add-text-post;" umi:module="blogs20" umi:method="postsList" umi:region="list" umi:type-id="{$blogPostPageTypeId}" umi:sortable="sortable" umi:button-position="top right">
			<xsl:apply-templates select="document(concat('udata://blogs20/postsList/', $pageId))/udata" />
		</div>
	</xsl:template>

	<xsl:template match="udata" mode="blog_index"/>
	
	<xsl:template match="udata[total != 0]" mode="blog_index">
		<xsl:if test="$isAdmin = 1">
            <div class="hidden">
                <div class="hidden-text">
                    <span>&show-index-blog;:</span>&nbsp;
                    <span umi:element-id="{$infoPageId}" umi:field-name="show_index_blog" umi:field-type="boolean">
                        <xsl:choose>
                            <xsl:when test="$infoPagePreferences/property[@name = 'show_index_blog']/value = 1">&yes;</xsl:when>
                            <xsl:otherwise>&no;</xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
            </div>
        </xsl:if>
		<xsl:if test="$infoPagePreferences/property[@name = 'show_index_blog']/value = 1">
			<xsl:variable name="blogPostPageTypeId" select="document('utype://blogs20~post')/udata/type/@id" />
			<div class="blog index_blog" umi:element-id="{$pageId}" umi:add-text="&add-text-post;" umi:module="blogs20" umi:method="postsList" umi:region="list" umi:type-id="{$blogPostPageTypeId}" umi:sortable="sortable" umi:button-position="top right">
				<div class="mainpage_blog_title h2" umi:element-id="{$infoPageId}" umi:field-name="mainpage_blogs_title" umi:field-type="string" umi:empty="&empty-blog-title;" >
					<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_blogs_title']" />
				</div>
				<xsl:apply-templates select=".">
					<xsl:with-param name="nopagination" value="1" />
				</xsl:apply-templates>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>