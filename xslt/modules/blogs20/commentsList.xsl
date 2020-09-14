<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="udata[@module = 'blogs20' and @method = 'commentsList']" />
    
    <xsl:template match="udata[@module = 'blogs20' and @method = 'commentsList'][total]">
        <div class="comments">
            <a name="comments" />
			<xsl:if test="total != 0">
				<div class="comments_h2 h2">
					<div umi:element-id="{$infoPageId}" umi:empty="&empty-comments-title;" umi:field-name="comments_title" umi:field-type="string">
						<xsl:apply-templates select="$infoPage/property[@name = 'comments_title']" />
					</div>
				</div>
			</xsl:if>
            <xsl:if test="total != 0">
				<div class="comments_list">
					<xsl:apply-templates select="items/item" mode="blogs20_comments_item"/>
				</div>
				<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page,'/'))/udata" />
			</xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="item" mode="blogs20_comments_item">
         <div class="comment" umi:element-id="{@cid}">
            <div class="comment_date comment_date_top" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
				<xsl:apply-templates select="@publish_time">
					<xsl:with-param name="date_format" select="$commentDateFormat" />
				</xsl:apply-templates>
			</div>
            <div class="comment_title h3">
				<span class="comment_author">
                    <xsl:apply-templates select="document(concat('uobject://',author_id,'.user_id'))//item" mode="autorComments" />			
                    <xsl:value-of select="document(concat('uobject://',author_id,'.nickname'))//value" />
                    <xsl:text>:</xsl:text>
                </span>
				<span class="comment_title" umi:field-name="name" umi:field-type="string" umi:delete="delete" umi:empty="&empty;">
					<xsl:value-of select="name" disable-output-escaping="yes" />
				</span>
				<span class="comment_date comment_date_span" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
					<xsl:apply-templates select="@publish_time">
						<xsl:with-param name="date_format" select="$commentDateFormat" />
					</xsl:apply-templates>
				</span>
			</div>
            <div class="comment_date comment_date_bottom" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
				<xsl:apply-templates select="@publish_time">
					<xsl:with-param name="date_format" select="$commentDateFormat" />
				</xsl:apply-templates>
			</div>
            <div id="content_{@cid}_{generate-id()}" class="text" umi:field-name="content" umi:field-type="wysiwyg" umi:element-id="{@cid}" umi:empty="&empty-page-content;">
                <xsl:apply-templates select="content" />
            </div>
            <a href="#comment_add" class="comment_add_link" id="{@cid}" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="comments_do_title" umi:field-type="string">
                <xsl:apply-templates select="$infoPage/property[@name = 'comments_do_title']" />
            </a>
            <xsl:apply-templates select="subcomments" />
        </div>
    </xsl:template>

    <xsl:template match="item" mode="autorComments">
        <xsl:value-of select="document(concat('uobject://',@id,'.lname'))//value" />
        <xsl:text>&nbsp;</xsl:text>
        <xsl:value-of select="document(concat('uobject://',@id,'.fname'))//value" />
    </xsl:template>

</xsl:stylesheet>