<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template name="header">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<xsl:if test="result/page/properties/group[@name = 'more_params']/property[@name = 'robots_deny']/value">
			<meta name="ROBOTS" CONTENT="NOINDEX, NOFOLLOW" />
		</xsl:if>
		<xsl:choose>
			<xsl:when test="($p &gt; 0) and result/meta/description != ''">
				<meta name="description" content="{result/meta/description} - &page; {number($p)+1}" />
			</xsl:when>
			<xsl:otherwise>
				<meta name="description" content="{result/meta/description}" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="($p &gt; 0) and result/meta/keywords != ''">
				<meta name="keywords" content="{result/meta/keywords}, &page-lower-case; {number($p)+1}" />
			</xsl:when>
			<xsl:otherwise>
				<meta name="keywords" content="{result/meta/keywords}" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="($p &gt; 0) and result/@title != ''">
				<title><xsl:value-of select="concat(result/@title,' - &page; ',(number($p) + 1))" disable-output-escaping="yes" /></title>
			</xsl:when>
			<xsl:otherwise>
				<title><xsl:value-of select="result/@title" disable-output-escaping="yes" /></title>
			</xsl:otherwise>
		</xsl:choose>

		<link type="text/css" rel="stylesheet" href="{$template-resources}css/default/style.css?{$templateVersion}" />
		<link type="text/css" rel="stylesheet" href="{$template-resources}css/decor.css?{$templateVersion}" />
		<link type="text/css" rel="stylesheet" href="{$template-resources}css/user.css?{$templateVersion}" />

		<xsl:value-of select="document('udata://content/includeFrontendResources')/udata" disable-output-escaping="yes" />

		<script charset="utf-8" src="{$template-resources}js/base-template.js?{$templateVersion}" type="text/javascript" />

		<xsl:if test="($infoPageSocial/property[@name = 'show_vk_like']/value = 1 or $infoPageSocial/property[@name = 'show_vk_comments']/value = 1 or $infoPageSocial/property[@name = 'show_vk_reviews']/value = 1) and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
			<script type="text/javascript" src="https://vk.com/js/api/openapi.js"></script>
			<script type="text/javascript">
				VK.init({apiId: <xsl:value-of select="$infoPageSocial/property[@name = 'app_id_vk']/value" disable-output-escaping="yes"/>, onlyWidgets: true});
			</script>
		</xsl:if>

		<xsl:if test="$infoPageSocial/property[@name = 'show_google_like']/value = 1">
			<script type="text/javascript">
			  window.___gcfg = {lang: '&google-lang;'};
			  (function() {
				var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
				po.src = 'https://apis.google.com/js/plusone.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
			  })();
			</script>
		</xsl:if>

		<xsl:apply-templates select="$infoPage/property[@name = 'code_head']/value" mode="code"/>

		<xsl:choose>
			<xsl:when test="$infoPage/property[@name = 'logo']/value">
				<meta property="og:image" content="http://{$_http_host}{$infoPage/property[@name = 'logo']/value}" />
			</xsl:when>
			<xsl:when test="$infoPage/property[@name = 'logotip']/value">
				<meta property="og:image" content="http://{$_http_host}{$infoPage/property[@name = 'logotip']/value}" />
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$infoPageSocial/property[@name = 'fb_users_id']/value != ''">
			<meta property="fb:admins" content="{$infoPageSocial/property[@name = 'fb_users_id']/value}"/>
		</xsl:if>
		<xsl:if test="$infoPageSocial/property[@name = 'app_id_fb']/value != ''">
			<meta property="fb:app_id" content="{$infoPageSocial/property[@name = 'app_id_fb']/value}"/>
		</xsl:if>
	</xsl:template>
	
	<!--Подключение facebook-->
	<xsl:template name="application">
		<div id="applications">
			<xsl:if test="$infoPageSocial/property[@name = 'show_fb_like']/value = 1 or $infoPageSocial/property[@name = 'show_fb_comments']/value = 1 or $infoPageSocial/property[@name = 'show_fb_reviews']/value = 1">
				<div id="fb-root"></div>
				<xsl:choose>
					<xsl:when test="$infoPageSocial/property[@name = 'app_id_fb']/value != ''">
						<script>
							(function(d, s, id) {
								var js, fjs = d.getElementsByTagName(s)[0];
								if (d.getElementById(id)) return;
								js = d.createElement(s); js.id = id;
								js.src = "//connect.facebook.net/&fb-lang;/all.js#xfbml=1&amp;appId=<xsl:value-of select="$infoPageSocial/property[@name = 'app_id_fb']/value" disable-output-escaping="yes"/>";
								fjs.parentNode.insertBefore(js, fjs);
							}(document, 'script', 'facebook-jssdk'));
						</script>
					</xsl:when>
					<xsl:otherwise>
						<script>
							(function(d, s, id) {
								var js, fjs = d.getElementsByTagName(s)[0];
								if (d.getElementById(id)) return;
								js = d.createElement(s); js.id = id;
								js.src = "//connect.facebook.net/&fb-lang;/all.js#xfbml=1";
								fjs.parentNode.insertBefore(js, fjs);
							}(document, 'script', 'facebook-jssdk'));
						</script>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template name="like_block">
		<div class="like_block">
			<xsl:if test="$infoPageSocial/property[@name = 'show_google_like']/value = 1">
				<div class="g_like_item like_item">
					<div class="g-plusone" data-size="medium"></div>
				</div>
			</xsl:if>
			<xsl:if test="$infoPageSocial/property[@name = 'show_vk_like']/value = 1 and $infoPageSocial/property[@name = 'app_id_vk']/value != ''">
				<div class="vk_like_item like_item">
					<div id="vk_like"></div>
					<script type="text/javascript">
						VK.Widgets.Like("vk_like", {type: "button", height: 20}, <xsl:value-of select="$pageId" />);
					</script>
				</div>
			</xsl:if>
			<xsl:if test="$infoPageSocial/property[@name = 'show_fb_like']/value = 1">
				<div class="fb_like_item like_item">
					<div class="fb-like" data-send="false" data-layout="button_count" data-width="150" data-show-faces="false" data-font="trebuchet ms"></div>
				</div>
			</xsl:if>
			<xsl:if test="$infoPageSocial/property[@name = 'show_twitter']/value = 1">
				<div class="twitter_like_item like_item">
					<a href="https://twitter.com/share" class="twitter-share-button" data-lang="&tweet-lang;">&tweet;</a>
					<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	
	<!--Шаблон для даты над заголовком h1 в новостях и блогах-->
	<xsl:template match="result" mode="main_top_date" >
		<xsl:if test="($module = 'news' and $method = 'item') or ($module = 'blogs20' and $method = 'post')">
			<xsl:if test="(//property[@name = 'publish_time']/value) or not($userType = 'guest')">
				<div class="{$module}_date main_top_date" umi:element-id="{$pageId}">	
					<span umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;">
						<xsl:apply-templates select="//property[@name = 'publish_time']">
							<xsl:with-param name="date_format" select="$newsDateFormat" />
						</xsl:apply-templates>
					</span>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!--Шаблон для заголовка h1 - присутствующего на всех страницах-->
	<xsl:template match="result" mode="h1">
		<xsl:choose>
			<xsl:when test="page">
				<h1 id="page_main_header" class="h1 module-{@module} method-{@method}">
					<span class="h1_content"  umi:element-id="{page/@id}" umi:field-name="h1" umi:field-type="string" umi:empty="&empty-page-name;">
						<xsl:value-of select="//property[@name = 'h1']/value" disable-output-escaping="yes"/>
					</span>
				</h1>
			</xsl:when>
			<xsl:when test="@method = 'download'">
				<h1 id="page_main_header" class="h1 module-{@module} method-{@method}">
					&error;
				</h1>
			</xsl:when>
			<xsl:otherwise>
				<h1 id="page_main_header" class="h1 module-{@module} method-{@method}">
					<span class="h1_content">
						<xsl:value-of select="@header" disable-output-escaping="yes"/>
					</span>
				</h1>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--SEO текст-->
    <xsl:template name="seo_text">
		<div id="seo_text_{$pageId}_{generate-id()}" class="seo_text text" umi:element-id="{$pageId}" umi:field-name="seo_text" umi:field-type="wysiwyg" umi:empty="&empty-page-seo;">
			<xsl:apply-templates select="//property[@name = 'seo_text']" />
		</div>
	</xsl:template>
	
	<!--Футер-->
    <xsl:template name="footer">
		<div class="footer">
			<xsl:call-template name="copyright_footer" />
			<div class="text code_pre code_footer" umi:element-id="{$infoPageId}" umi:field-name="code_footer" umi:field-type="text" umi:empty="&empty-code-footer;">
				<xsl:apply-templates select="$infoPage/property[@name = 'code_footer']/value" mode="code"/>
			</div>
			<xsl:call-template name="social_block">
				<xsl:with-param name="title" select="'&share;'" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<!--Блок с социальными сетями-->
	<xsl:template name="social_block">
		<xsl:param name="title" select="''" />
		<xsl:param name="class" select="''" />
		<xsl:param name="showTitleInBlock" select="boolean('true')" />

		<div class="addthis_toolbox" id="social_block">
			<xsl:if test="$class != ''">
				<xsl:attribute name="class">addthis_toolbox <xsl:value-of select="$class" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="$title != ''">
				<xsl:choose>
					<xsl:when test="$showTitleInBlock">
						<div id="addthis_toolbox_share" class="text">
							<p><xsl:value-of select="$title" />:</p>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:value-of select="$title" />:</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<a class="social_button social_vk" rel="nofollow" href="http://vkontakte.ru" title="&label-share-social-network-vk;" onclick="return application.socialButtons.open('vk');" />
			<a class="social_button social_odnoklassniki" rel="nofollow" href="http://odnoklassniki.ru" title="&label-share-social-network-odnoklassniki;" onclick="return application.socialButtons.open('odnoklassniki');" />
			<a class="social_button social_krug" rel="nofollow" href="http://moikrug.ru" title="&label-share-social-network-moikrug;" onclick="return application.socialButtons.open('moikrug');" />
			<a class="social_button social_mir" rel="nofollow" href="http://my.mail.ru" title="&label-share-social-network-mymail;" onclick="return application.socialButtons.open('moimir');" />
			<a class="social_button social_facebook" rel="nofollow" href="http://facebook.com" title="&label-share-social-network-facebook;" onclick="return application.socialButtons.open('facebook');" />
			<a class="social_button social_twitter" rel="nofollow" href="http://twitter.com" title="&label-share-social-network-twitter;" onclick="return application.socialButtons.open('twitter');" />
			<a class="social_button social_livejournal" rel="nofollow" href="http://livejournal.com" title="&label-share-social-network-livejournal;" onclick="return application.socialButtons.open('livejournal');" />
			<a class="social_button social_liveinternet" rel="nofollow" href="http://liveinternet.ru" title="&label-share-social-network-liveinternet;" onclick="return application.socialButtons.open('liveinternet');" />
			<div class="cleaner" />
		</div>
	</xsl:template>
	
	<xsl:template name="footer_1">
		<div class="footer">
			<xsl:call-template name="contacts_footer" />
			<xsl:call-template name="copyright_footer" />
			<div class="cleaner"/>
			<div class="text code_pre code_footer" umi:element-id="{$infoPageId}" umi:field-name="code_footer" umi:field-type="text" umi:empty="&empty-code-footer;">
				<xsl:apply-templates select="$infoPage/property[@name = 'code_footer']/value" mode="code"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="contacts_footer">
		<div class="footer_contacts_right middle">
			<div class="footer_contacts_phone">
				<span class="footer_contacts_small_phone" umi:element-id="{$infoPageId}" umi:field-name="kod_goroda" umi:field-type="string" umi:empty="&empty-phonecode;" >
					<xsl:apply-templates select="$infoPage/property[@name = 'kod_goroda']" />
				</span>
				<span class="footer_contacts_big_phone" umi:element-id="{$infoPageId}" umi:field-name="telefon" umi:field-type="string" umi:empty="&empty-phone;" >
					<xsl:apply-templates select="$infoPage/property[@name = 'telefon']" />
				</span>
			</div>
			<div class="footer_contacts_address" umi:element-id="{$infoPageId}" umi:field-name="address" umi:field-type="string" umi:empty="&empty-address;">
				<xsl:apply-templates select="$infoPage/property[@name = 'address']" />
			</div>
			<div class="footer_contacts_time" umi:element-id="{$infoPageId}" umi:field-name="rezhim_raboty" umi:field-type="string" umi:empty="&empty-worktime;">
				<xsl:apply-templates select="$infoPage/property[@name = 'rezhim_raboty']" />
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="copyright_footer">
		<div id="copyright_{$infoPageId}_{generate-id()}" class="text copyright" umi:element-id="{$infoPageId}" umi:field-name="copyright" umi:field-type="wysiwyg" umi:empty="&empty;">
			<xsl:if test="$infoPage/property[@name = 'copyright']/value">
				<xsl:apply-templates select="$infoPage/property[@name = 'copyright']"/>
			</xsl:if>
		</div>

		<div id="umi-copyright_{$infoPageId}_{generate-id()}" class="text umi-copyright" umi:element-id="{$infoPageId}" umi:field-name="copyright_umicms" umi:field-type="wysiwyg" umi:empty="&empty;">
			<xsl:choose>
				<xsl:when test="not($infoPage/property[@name = 'copyright']/value)">
					<p>
						<xsl:text>&copyright; </xsl:text>
						<a href="https://www.umi-cms.ru" rel="nofollow">
							<xsl:text>UMI.CMS</xsl:text>
						</a>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$infoPage/property[@name = 'copyright_umicms']" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!--Copyright modal window-->
	<xsl:template name="footer_modal">
		<div id="copy_del" class="modal hide fade">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
				<h4 id="myModalLabel">&delete-text-footer-title;</h4>
			</div>
			<div class="modal-body">
				<p>&delete-text-footer-p1; <a href="/adminzone/money/">&delete-text-footer-p2;</a>.</p>
			</div>
		</div>
	</xsl:template>
	
	<!--Произвольный блок 1-->
	<xsl:template name="custom_block_1">
		<div id="custom_block_1_{$infoPageId}_{generate-id()}" class="text custom_block_1" umi:field-name="custom_block_1" umi:field-type="wysiwyg" umi:empty="&empty-html-block;" umi:element-id="{$infoPageId}">
			<xsl:apply-templates select="$infoPage/property[@name = 'custom_block_1']" />
		</div>
	</xsl:template>
	
	<!--Произвольный блок 2-->
	<xsl:template name="custom_block_2">
		<div id="custom_block_2_{$infoPageId}_{generate-id()}" class="text custom_block_2" umi:field-name="custom_block_2" umi:field-type="wysiwyg" umi:empty="&empty-html-block;" umi:element-id="{$infoPageId}">
			<xsl:apply-templates select="$infoPage/property[@name = 'custom_block_2']" />
		</div>
	</xsl:template>
	
	<!--Список подразделов и элементов каталога для меню-->
	<xsl:template name="catalog_main_list">
		<xsl:param name="level" select="0"/>
		<xsl:param name="show_objects" select="1" />
		<xsl:variable name="id" select="document('usel://getData//catalog/category/')/udata/page/@id" />
		<div class="main_catalog_list">
			<xsl:apply-templates select="document(concat('udata://content/menu//',$level,'/',$id,'/'))/udata" mode="multilevel_menu">
				<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="show_objects" select="$show_objects" />
			</xsl:apply-templates>
		</div>
	</xsl:template>
	
	<!--Кнопка заказать-->
	<xsl:template name="order_button">
		<xsl:param name="empty-image">/templates/s202/base-img/feedback_button.jpg</xsl:param>
        <xsl:if test="not($infoPagePreferences/property[@name = 'disabled_feedback']/value = 1)">
            <a id="main_big_order_button" class="callback" href="#ajax#ajax-order-form.{$pageId}.ajax" title="{$infoPageForm/property[@name = 'order_form_title']/value}">
                <xsl:variable name="path">
					<xsl:choose>
						<xsl:when test="$infoPageForm/property[@name = 'order_button_img']/value">
							<xsl:value-of select="$infoPageForm/property[@name = 'order_button_img']/value"/>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$empty-image"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="thumbnail" select="document(concat('udata://content/makeThumbnailSqueeze/(.',$path,')/60/auto/void/0/7/'))/udata"/>
				<div class="thumbnail_holder" umi:element-id="{$infoPageId}" umi:field-name="order_button_img" umi:field-type="img_file" style="max-width:60px;width:{$thumbnail/width}px;height:{$thumbnail/height}px;background-image:url({$thumbnail/src})" rel="{$thumbnail/src}"></div>
            </a>
        </xsl:if>
	</xsl:template>
	
	<!--Кнопка заказа обратного звонка-->
	<xsl:template name="callback_button">
		<a class="callback callback_button" href="#ajax#ajax-order-form.{$pageId}.ajax">
		   &callback;
		</a>
	</xsl:template>
	
	<!--Кнопка личного кабинета-->
	<xsl:template name="users_button">
        <xsl:if test="not($infoPagePreferences/property[@name = 'disabled_registration']/value = 1)">
            <div id="main_big_user_block">
                <a class="ajax_login_toggle ajax_login_toggle_icon" href="/users/login/" title="&authorization;"><span>&nbsp;</span></a>
            </div>
        </xsl:if>
	</xsl:template>
	
	<xsl:template name="base_header_1">
		<xsl:param name="width" select="'150'" />
		<xsl:param name="alt" select="$result/@title" />
        <div class="base_header">
			<div class="base_header_left middle">
				<div class="base_header_logo middle">
					<a href="/">
						<xsl:call-template name="makeThumbnailSqueeze">
							<xsl:with-param name="element_id" select="$infoPageId" />
							<xsl:with-param name="field_name" select="'logo'" />
							<xsl:with-param name="width" select="$width" />
							<xsl:with-param name="alt" select="$infoPage/property[@name = 'imya_i_familiya']/value" />
						</xsl:call-template>
					</a>
				</div>
				<div class="base_header_title middle">
					<div class="base_header_name">
						<a umi:element-id="{$infoPageId}" umi:empty="&empty-fio;" umi:field-name="imya_i_familiya" umi:field-type="string" href="/" >
							<xsl:apply-templates select="$infoPage/property[@name = 'imya_i_familiya']" />
						</a>
					</div>
					<div class="base_header_slogan">
						<a umi:element-id="{$infoPageId}" umi:field-name="professiya_ili_slogan" umi:field-type="string" umi:empty="&empty-content;" href="/">
							<xsl:apply-templates select="$infoPage/property[@name = 'professiya_ili_slogan']" />
						</a>
					</div>
				</div>
			</div>
			<div class="base_header_right middle">
				<div class="base_header_phone">
					<span class="base_header_small_phone" umi:element-id="{$infoPageId}" umi:field-name="kod_goroda" umi:field-type="string" umi:empty="&empty-phonecode;" >
						<xsl:apply-templates select="$infoPage/property[@name = 'kod_goroda']" />
					</span>
					<span class="base_header_big_phone" umi:element-id="{$infoPageId}" umi:field-name="telefon" umi:field-type="string" umi:empty="&empty-phone;" >
						<xsl:apply-templates select="$infoPage/property[@name = 'telefon']" />
					</span>
				</div>
				<div class="base_header_address" umi:element-id="{$infoPageId}" umi:field-name="address" umi:field-type="string" umi:empty="&empty-address;">
					<xsl:apply-templates select="$infoPage/property[@name = 'address']" />
				</div>
				<div class="base_header_time" umi:element-id="{$infoPageId}" umi:field-name="rezhim_raboty" umi:field-type="string" umi:empty="&empty-worktime;">
					<xsl:apply-templates select="$infoPage/property[@name = 'rezhim_raboty']" />
				</div>
				<xsl:apply-templates select="document('udata://search/insert_form/')/udata"/>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template name="all_banners">
		<xsl:param name="width" select="70" />
		<xsl:param name="height" select="70" />
		<xsl:call-template name="banner_1">
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
		</xsl:call-template>
		<xsl:call-template name="banner_2">
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
		</xsl:call-template>
		<xsl:call-template name="banner_3">
			<xsl:with-param name="width" select="$width" />
			<xsl:with-param name="height" select="$height" />
		</xsl:call-template>
	</xsl:template>
	
	<!--Баннер 1-->
	<xsl:template name="banner_1">
		<xsl:param name="img" select="1" />
		<xsl:param name="html" select="1" />
		<xsl:param name="title" select="1" />
		<xsl:param name="width" select="70" />
		<xsl:param name="height" select="70" />
        <div class="direction_block direction_block_1">
			<a class="direction_block_link">
				<xsl:if test="$infoPage/property[@name = 'banner_link_1']">
					<xsl:attribute name="href"><xsl:value-of select="$infoPage/property[@name = 'banner_link_1']/value" disable-output-escaping="yes" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$img = 1">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="$infoPageId" />
						<xsl:with-param name="delete" select="''" />
						<xsl:with-param name="field_name" select="'banner_img_1'" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="alt" select="$infoPage/property[@name = 'banner_title_1']/value" />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$title = 1">
					<div class="direction_title" umi:field-name="banner_title_1" umi:field-type="string" umi:empty="&empty-banner-title;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_title_1']" />
					</div>
				</xsl:if>
				<xsl:if test="$html = 1">
					<div id="direction_html_1_{$infoPageId}_{generate-id()}" class="direction_text text" umi:field-name="banner_html_1" umi:field-type="wysiwyg" umi:empty="&empty-banner-html;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_html_1']" />
					</div>
				</xsl:if>
				<xsl:if test="$isAdmin = 1">
					<div class="hidden">
						<span umi:field-name="banner_link_1" umi:field-type="string" umi:empty="&empty-banner-link;" umi:element-id="{$infoPageId}">
							<xsl:value-of select="$infoPage/property[@name = 'banner_link_1']/value" disable-output-escaping="yes" />
						</span>
					</div>
				</xsl:if>
				<div class="cleaner" />
			</a>
		</div>
	</xsl:template>
	
	<!--Баннер 2-->
	<xsl:template name="banner_2">
		<xsl:param name="img" select="1" />
		<xsl:param name="html" select="1" />
		<xsl:param name="title" select="1" />
		<xsl:param name="width" select="70" />
		<xsl:param name="height" select="70" />
        <div class="direction_block direction_block_2">
			<a class="direction_block_link">
				<xsl:if test="$infoPage/property[@name = 'banner_link_2']">
					<xsl:attribute name="href"><xsl:value-of select="$infoPage/property[@name = 'banner_link_2']/value" disable-output-escaping="yes" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$img = 1">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="$infoPageId" />
						<xsl:with-param name="delete" select="''" />
						<xsl:with-param name="field_name" select="'banner_img_2'" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="alt" select="$infoPage/property[@name = 'banner_title_2']/value" />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$title = 1">
					<div class="direction_title" umi:field-name="banner_title_2" umi:field-type="string" umi:empty="&empty-banner-title;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_title_2']" />
					</div>
				</xsl:if>
				<xsl:if test="$html = 1">
					<div id="direction_html_2_{$infoPageId}_{generate-id()}" class="direction_text text" umi:field-name="banner_html_2" umi:field-type="wysiwyg" umi:empty="&empty-banner-html;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_html_2']" />
					</div>
				</xsl:if>
				<xsl:if test="$isAdmin = 1">
					<div class="hidden">
						<span umi:field-name="banner_link_2" umi:field-type="string" umi:empty="&empty-banner-link;" umi:element-id="{$infoPageId}">
							<xsl:value-of select="$infoPage/property[@name = 'banner_link_2']/value" disable-output-escaping="yes" />
						</span>
					</div>
				</xsl:if>
				<div class="cleaner" />
			</a>
		</div>
	</xsl:template>
	
	<!--Баннер 3-->
	<xsl:template name="banner_3">
		<xsl:param name="img" select="1" />
		<xsl:param name="html" select="1" />
		<xsl:param name="title" select="1" />
		<xsl:param name="width" select="70" />
		<xsl:param name="height" select="70" />
        <div class="direction_block direction_block_3">
			<a class="direction_block_link">
				<xsl:if test="$infoPage/property[@name = 'banner_link_3']">
					<xsl:attribute name="href"><xsl:value-of select="$infoPage/property[@name = 'banner_link_3']/value" disable-output-escaping="yes" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$img = 1">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="$infoPageId" />
						<xsl:with-param name="delete" select="''" />
						<xsl:with-param name="field_name" select="'banner_img_3'" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="alt" select="$infoPage/property[@name = 'banner_title_3']/value" />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$title = 1">
					<div class="direction_title" umi:field-name="banner_title_3" umi:field-type="string" umi:empty="&empty-banner-title;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_title_3']" />
					</div>
				</xsl:if>
				<xsl:if test="$html = 1">
					<div id="direction_html_3_{$infoPageId}_{generate-id()}" class="direction_text text" umi:field-name="banner_html_3" umi:field-type="wysiwyg" umi:empty="&empty-banner-html;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'banner_html_3']" />
					</div>
				</xsl:if>
				<xsl:if test="$isAdmin = 1">
					<div class="hidden">
						<span umi:field-name="banner_link_3" umi:field-type="string" umi:empty="&empty-banner-link;" umi:element-id="{$infoPageId}">
							<xsl:value-of select="$infoPage/property[@name = 'banner_link_3']/value" disable-output-escaping="yes" />
						</span>
					</div>
				</xsl:if>
				<div class="cleaner" />
			</a>
		</div>
	</xsl:template>
	
	<xsl:template name="list_class">
		<xsl:if test="position() = 1">
			<xsl:text>first </xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>last </xsl:text>
		</xsl:if>
		<xsl:if test="@status">
			<xsl:text>current </xsl:text>
		</xsl:if>
		<xsl:if test="position() mod 2 = 0">
			<xsl:text>even </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Согласие на обработку персональных данных -->
	<xsl:template name="personal_data_notice">
		<div class="field personal_data_wrapper">
			<label for="personal_data_notice">
				<input type="checkbox"
					   id="personal_data_notice"
					   name="personal_data_notice"
					   required="required"
					   checked="checked"
				/>
				<xsl:value-of select="$infoPage/property[@name = 'personal_data_text']/value" disable-output-escaping="yes" />
			</label>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
