<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi" xmlns:xlink="http://www.w3.org/TR/xlink">

	<!--Комментарии-->
    <xsl:template name="comments">
		<xsl:param name="url" select="concat('http://',$_http_host,$requestUri)" />
		<div class="comments">
			<xsl:choose>
				<xsl:when test="$infoPageSocial/property[@name = 'show_fb_comments']/value = 1">
					<div class="fb_comments_wrapper">
						<a name="comments" />
						<a name="add-comment" />
						<div class="fb-comments" data-href="{$url}" data-num-posts="{$fb_comments_per_page}" data-width="{$fb_comments_width}"></div>
					</div>
				</xsl:when>
				<xsl:when test="$infoPageSocial/property[@name = 'show_vk_comments']/value = 1 and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
					<div class="vk_comments_wrapper">
						<a name="comments" />
						<a name="add-comment" />
						<div id="vk_comments"></div>
						<script type="text/javascript">
							VK.Widgets.Comments("vk_comments", {limit: <xsl:value-of select="$vk_comments_per_page" />, width: "<xsl:value-of select="$vk_comments_width" />", attach: "*"}, <xsl:value-of select="$pageId" />);
						</script>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="document(concat('udata://comments/insert/',$pageId))/udata" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
    </xsl:template>
	
	<!--Стандартные комментарии-->
    <xsl:template match="udata[@module = 'comments' and @method = 'insert']">
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
				<xsl:apply-templates select="items/item" />
			</div>
			<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page,'/'))/udata" />
		</xsl:if>
		<xsl:apply-templates select="add_form" mode="form" />
    </xsl:template>

	<!--Стандартный комментарий-->
    <xsl:template match="udata[@module = 'comments' and @method = 'insert']/items/item">
        <div class="comment" umi:element-id="{@id}" umi:delete="delete">
			<div class="comment_date comment_date_top" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
				<xsl:apply-templates select="@publish_time">
					<xsl:with-param name="date_format" select="$commentDateFormat" />
				</xsl:apply-templates>
			</div>
			<div class="comment_title h3">
				<span class="comment_author">
					<xsl:apply-templates select="document(@xlink:author-href)/udata"/>
					<xsl:text>:</xsl:text>
				</span>
				<span class="comment_title" umi:field-name="name" umi:field-type="string" umi:empty="&empty;">
					<xsl:value-of select="@title" disable-output-escaping="yes" />
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
            <div id="message_{@id}_{generate-id()}" class="text" umi:field-name="message" umi:field-type="text" umi:empty="&empty;">
                <xsl:value-of select="." disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:template>

	<!--Стандартная форма комментариев-->
    <xsl:template match="udata[@method = 'insert']/add_form" mode="form">
		<div class="comments_form_div">
			<a name="add-comment" />
			<div class="comment_add_form_h2 h2" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-title;" umi:field-name="add_comment_title" umi:field-type="string">
				<xsl:apply-templates select="$infoPage/property[@name = 'add_comment_title']" />
			</div>
			<form class="site_form comments_form" method="post" action="{action}">
				<fieldset>
					<div class="field field_title">
						<label>
							<span>&comment-title;:</span>
						</label>
						<div class="field_div input">
							<input type="text" name="title"/>
						</div>
					</div>
					<xsl:if test="$userType = 'guest'">
						<div class="field field_author_nick">
							<label>
								<span>&comment-name;:</span>
							</label>
							<div class="field_div input">
								<input type="text" name="author_nick"/>
							</div>
						</div>
						<div class="field field_author_email">
							<label>
								<span>&comment-email;:</span>
							</label>
							<div class="field_div input">
								<input type="text" name="author_email"/>
							</div>
						</div>
					</xsl:if>
					<div class="field field_comment">
						<label>
							<span>&comment-body;:</span>
						</label>
						<div class="field_div textarea">
							<textarea name="comment" />
						</div>
					</div>
					<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
					<xsl:call-template name="personal_data_notice" />
				</fieldset>
				<fieldset>
					<div class="submit">
						<input type="submit" class="all_system_buttons" value="&comment-submit;" />
					</div>
				</fieldset>
			</form>
		</div>
    </xsl:template>
	
	<!--Отзывы-->
	<xsl:template name="reviews">
		<xsl:param name="url" select="concat('http://',$_http_host,$requestUri)" />
		<div class="reviews">
			<xsl:choose>
				<xsl:when test="$infoPageSocial/property[@name = 'show_fb_reviews']/value = 1">
					<div class="fb_comments_wrapper">
						<div class="fb-comments" data-href="{$url}" data-num-posts="{$fb_comments_per_page}" data-width="{$fb_comments_width}"></div>
					</div>
				</xsl:when>
				<xsl:when test="$infoPageSocial/property[@name = 'show_vk_reviews']/value = 1 and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
					<div class="vk_comments_wrapper">
						<div id="vk_comments"></div>
						<script type="text/javascript">
							VK.Widgets.Comments("vk_comments", {limit: <xsl:value-of select="$vk_comments_per_page" />, width: "<xsl:value-of select="$vk_comments_width" />", attach: "*"}, <xsl:value-of select="$pageId" />);
						</script>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="document(concat('udata://comments/insert/',$pageId))/udata" mode="reviews"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
    </xsl:template>
	 
	<xsl:template match="udata[@module = 'comments' and @method = 'insert']" mode="reviews">
		<xsl:if test="total != 0">
			<div class="reviews_h2 h2">
				<div umi:element-id="{$infoPageId}" umi:empty="&empty-reviews-title;" umi:field-name="reviews_title" umi:field-type="string">
					<xsl:apply-templates select="$infoPage/property[@name = 'reviews_title']" />
				</div>
			</div>
		</xsl:if>
		<xsl:if test="total != 0">
			<div class="reviews_list">
				<xsl:apply-templates select="items/item" mode="reviews-item"/>
			</div>
			<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page,'/'))/udata" />
		</xsl:if>
		<xsl:apply-templates select="add_form" mode="reviews-form" />
    </xsl:template>

    <xsl:template match="udata[@module = 'comments' and @method = 'insert']/items/item" mode="reviews-item">
		<xsl:variable name="comment" select="document(concat('upage://',@id))/udata"/>
        <div class="review" umi:element-id="{@id}" umi:delete="delete">
			<div class="review_title">
				<div class="review_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
					<xsl:apply-templates select="@publish_time">
						<xsl:with-param name="date_format" select="'d.m.Y'" />
					</xsl:apply-templates>
				</div>
				<span class="review_author">
					<xsl:apply-templates select="document(@xlink:author-href)/udata"/>
				</span>
				<div class="grade_stars grade-stars-{$comment//property[@name = 'grade']/value}">
					<span class="star star-1" rel="1">&nbsp;</span>
					<span class="star star-2" rel="2">&nbsp;</span>
					<span class="star star-3" rel="3">&nbsp;</span>
					<span class="star star-4" rel="4">&nbsp;</span>
					<span class="star star-5" rel="5">&nbsp;</span>
				</div>
				<div class="cleaner"/>
			</div>
            <div id="message_{@id}_{generate-id()}" class="text review_text" umi:field-name="message" umi:field-type="text" umi:empty="&empty;">
                <xsl:value-of select="." disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:template>

    <xsl:template match="udata[@method = 'insert']/add_form" mode="reviews-form">
		<div class="comments_form_div">
			<div class="reviews_add_form_h2 h2" umi:element-id="{$infoPageId}" umi:empty="&empty-reviews-title;" umi:field-name="add_reviews_title" umi:field-type="string">
				<xsl:apply-templates select="$infoPage/property[@name = 'add_reviews_title']" />
			</div>
			<form class="site_form reviews_form" method="post" action="{action}">
				<fieldset>
					<div class="field field_grade_stars">
						<label>
							<span>&reviews-grade;:</span>
						</label>
						<div class="big_grade_stars">
							<span class="star star-1" rel="1">&nbsp;</span>
							<span class="star star-2" rel="2">&nbsp;</span>
							<span class="star star-3" rel="3">&nbsp;</span>
							<span class="star star-4" rel="4">&nbsp;</span>
							<span class="star star-5" rel="5">&nbsp;</span>
						</div>
						<input type="hidden" name="grade"/>
					</div>
					<xsl:if test="$userType = 'guest'">
						<div class="field field_author_nick">
							<label>
								<span>&reviews-name;:</span>
							</label>
							<div class="field_div input">
								<input type="text" name="author_nick"/>
							</div>
						</div>
						<div class="field field_author_email">
							<label>
								<span>&reviews-email;:</span>
							</label>
							<div class="field_div input">
								<input type="text" name="author_email"/>
							</div>
						</div>
					</xsl:if>
					<div class="field field_comment required">
						<label>
							<span>&reviews-body;:</span>
							<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
						</label>
						<div class="field_div textarea">
							<textarea name="comment" />
						</div>
						<div class="webforms_error_text">
							&webforms-error-text;
						</div>
					</div>
					<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
					<xsl:call-template name="personal_data_notice" />
				</fieldset>
				<fieldset>
					<div class="submit">
						<input type="submit" class="all_system_buttons" value="&reviews-submit;" />
					</div>
				</fieldset>
			</form>
		</div>
    </xsl:template>

	<xsl:template name="opinions" mode="opinions">
		<xsl:variable name="comments_widget_page" select="$infoPagePreferences/property[@name = 'comments_widget_page']/value/page" />
		<xsl:choose>
			<xsl:when test="$comments_widget_page">
				<xsl:variable name="commentsPageTypeId" select="document('utype://comments~comment')/udata/type/@id" />
				<div class="comments-widget">
					<div class="h2">
						<div umi:element-id="{$infoPageId}" umi:empty="&empty-comments-widget-title;" umi:field-name="comments_widget_title" umi:field-type="string">
							<xsl:value-of select="$infoPage/property[@name = 'comments_widget_title']/value"/>
						</div>
					</div>
					<div class="opinions-list" umi:module="comments" umi:type-id="{$commentsPageTypeId}" umi:region="list" umi:sortable="sortable" umi:add-text="&opinions-add;" umi:button-position="top right" umi:element-id="{$comments_widget_page/@id}">
						<xsl:apply-templates select="document(concat('usel://getContent//comments/comment/',$comments_widget_page/@id,'/1/',$comments_widget_amount,'/'))/udata" mode="opinions"/>
					</div>
					<xsl:if test="count(document(concat('usel://getContent//comments/comment/',$comments_widget_page/@id,'/1/'))/udata/page) &gt; $comments_widget_amount" >
					<div>
						<xsl:variable name="comments_page" select="document(concat('upage://',$comments_widget_page/@id))/udata/page" />
						<a href="{$comments_page/@link}" umi:element-id="{$infoPageId}" umi:empty="&empty-comments-page-link-title;" umi:field-name="comments_page_link_title" umi:field-type="string">
							<xsl:value-of select="$infoPage/property[@name = 'comments_page_link_title']/value"/>
						</a>
					</div>
					</xsl:if>
				</div>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>

	<xsl:template match="udata" mode="opinions" >
		<xsl:apply-templates select="page" mode="opinions" />
	</xsl:template>

	<xsl:template match="udata[count(page)=0]" mode="opinions" >
		<div class="opinions-item blank_item" umi:region="row" umi:element-id="" umi:delete="delete" umi:delete-text="&opinions-delete;" >
			<div class="opinions-author" umi:field-name="author" umi:field-type="string" umi:empty="&opinions-author-fio;" ></div>
			<div class="opinions-position" umi:field-name="position" umi:field-type="string" umi:empty="&opinions-author-position;"></div>
			<div class="opinions-text" umi:field-name="message" umi:field-type="text" umi:empty="&opinions-text;" ></div>
		</div>
	</xsl:template>

	<xsl:template match="udata/page" mode="opinions" >
		<xsl:variable name="page" select="document(concat('upage://',@id))/udata/page" />
		<div class="opinions-item" umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&opinions-delete;" >
			<xsl:call-template name="makeThumbnailSqueeze">
				<xsl:with-param name="element_id" select="@id" />
				<xsl:with-param name="field_name" select="'avatar'" />
				<xsl:with-param name="width" select="$comments_image_width" />
				<xsl:with-param name="height" select="$comments_image_height" />
				<xsl:with-param name="alt" select="$page/@author" />
				<xsl:with-param name="no-empty-image" select="1" />
			</xsl:call-template>
			<div class="opinions-author" umi:field-name="author" umi:field-type="string" umi:empty="&opinions-author-fio;" >
				<xsl:value-of select="$page//property[@name = 'author']/value" />
			</div>
			<div class="opinions-position" umi:field-name="position" umi:field-type="string" umi:empty="&opinions-author-position;">
				<xsl:value-of select="$page//property[@name = 'position']/value" />
			</div>
			<div class="opinions-text" umi:field-name="message" umi:field-type="text" umi:empty="&opinions-text;" >
				<xsl:value-of select="$page//property[@name = 'message']/value" />
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
