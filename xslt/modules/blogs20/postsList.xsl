<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@module = 'blogs20' and (@method = 'postsList' or @method = 'postsByTag')]">
	<xsl:param name="nopagination" select="'0'" />
		<xsl:if test="(count(items/item)= 0) and ($isAdmin = 1)">
			<div class="hidden no-style">
				<div class="hidden-text">
					<p>&empty-blog;</p>
				</div>
			</div>
			<div class="blog_item blank_item" umi:region="row" umi:element-id="void" umi:delete="delete">
				<div class="blog_title">
					<div class="top_date blog_item_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" />
					<a class="post_name" href="void" umi:field-name="name" umi:field-type="string" umi:empty="&empty-blog-name;"/>
					<div class="bottom_date blog_item_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" />
				</div>
				<div class="text" umi:field-name="content" umi:field-type="wysiwyg" umi:empty="&empty-blog-anons;"/>
				<div class="tags">
					<xsl:text>( </xsl:text>
						<span umi:field-name="tags" umi:field-type="tags" umi:empty="&empty-tags;"></span>
					<xsl:text> )</xsl:text>
				</div>
				<xsl:choose>
					<xsl:when test="$infoPageSocial/property[@name = 'show_fb_comments']/value = 1">
						
					</xsl:when>
					<xsl:when test="$infoPageSocial/property[@name = 'show_vk_comments']/value = 1 and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
						
					</xsl:when>
					<xsl:otherwise>
						<div class="blog_comment">
							<a href="void" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-title;" umi:field-name="comments_title" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'comments_title']" /><xsl:text> (0)</xsl:text>
							</a>
							<xsl:text> | </xsl:text>
							<a href="void" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-add-title;" umi:field-name="comments_do_title" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'comments_do_title']" />
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
		<xsl:apply-templates select="items/item" />
		<xsl:if test="$nopagination = '0'">
			<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page,'/'))/udata" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="udata[@module = 'blogs20' and (@method = 'postsList' or @method = 'postsByTag')]/items/item">
		<div class="blog_item" umi:region="row" umi:element-id="{@id}" umi:delete-text="&delete-text-post;" umi:delete="delete">
			<xsl:if test="position() = last()">
				<xsl:attribute name="class">last_blog_item blog_item</xsl:attribute>
			</xsl:if>
			<div class="blog_title">
				<div class="top_date blog_item_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" >
					<xsl:apply-templates select="publish_time">
						<xsl:with-param name="date_format" select="$newsDateFormat" />
					</xsl:apply-templates>
				</div>
				<a class="post_name" href="{post_link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-blog-name;">
					<xsl:apply-templates select="name" />
				</a>
				<div class="bottom_date blog_item_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" >
					<xsl:apply-templates select="publish_time">
						<xsl:with-param name="date_format" select="$newsDateFormat" />
					</xsl:apply-templates>
				</div>
			</div>
			<div id="content_{@id}_{generate-id()}" class="text" umi:field-name="content" umi:field-type="wysiwyg" umi:empty="&empty-blog-anons;">
				<xsl:apply-templates select="cut" />
			</div>
			<div class="tags">
				<xsl:if test="tags">
					<xsl:text>( </xsl:text>
				</xsl:if>
				<xsl:if test="tags or not($userType = 'guest')">
					<span umi:field-name="tags" umi:field-type="tags" umi:empty="&empty-tags;">
						<xsl:apply-templates select="tags" />
					</span>
				</xsl:if>
				<xsl:if test="tags">
					<xsl:text> )</xsl:text>
				</xsl:if>
			</div>
			<xsl:choose>
				<xsl:when test="$infoPageSocial/property[@name = 'show_fb_comments']/value = 1">
					
				</xsl:when>
				<xsl:when test="$infoPageSocial/property[@name = 'show_vk_comments']/value = 1 and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
					
				</xsl:when>
				<xsl:otherwise>
					<div class="blog_comment">
						<a href="{post_link}#comments" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-title;" umi:field-name="comments_title" umi:field-type="string">
							<xsl:apply-templates select="$infoPage/property[@name = 'comments_title']" />
							<xsl:text> (</xsl:text><xsl:value-of select="comments_count" /><xsl:text>)</xsl:text>
						</a>
						<xsl:text> | </xsl:text>	
						<a href="{post_link}#comments" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-add-title;" umi:field-name="comments_do_title" umi:field-type="string">
							<xsl:apply-templates select="$infoPage/property[@name = 'comments_do_title']" />
						</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

</xsl:stylesheet>