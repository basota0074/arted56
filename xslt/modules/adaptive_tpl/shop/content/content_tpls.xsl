<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<xsl:template name="content_in_complex_main_s1">
		<div class="row-fluid for-umi-slider">
			<div class="span12 pos-rel">
				<div class="container">
					<div class="carousel">
						<!-- Carousel items -->

						<div class="carousel-inner">
							<div class="item from_tan">
								<xsl:call-template name="banner_1">
									<xsl:with-param name="html" select="0"/>
									<xsl:with-param name="width" select="940"/>
									<xsl:with-param name="height" select="'453'"/>
								</xsl:call-template>
							</div>
							<div class="item from_tan">
								<xsl:call-template name="banner_2">
									<xsl:with-param name="html" select="0"/>
									<xsl:with-param name="width" select="940"/>
									<xsl:with-param name="height" select="'453'"/>
								</xsl:call-template>
							</div>
							<div class="item from_tan">
								<xsl:call-template name="banner_3">
									<xsl:with-param name="html" select="0"/>
									<xsl:with-param name="width" select="940"/>
									<xsl:with-param name="height" select="'453'"/>
								</xsl:call-template>
							</div>
						</div>

						<!-- Carousel nav -->
						<a class="left carousel-control" id="big_prev"></a>
						<a class="right carousel-control" id="big_next"></a>
					</div>
				</div>
			</div>
		</div>

		<div class="row-fluid for-content">
			<div class="span12 pos-rel">
				<div class="container mt20 mb20 p10">
					<xsl:apply-templates select="."/>
				</div>
			</div>
		</div>

		<div class="row-fluid for-special-offers">
			<div class="span12 pos-rel">
				<div class="container mb20 umi-special-offers">
					<!-- Special offers - hardCoded from category.xsl -->
					<xsl:variable name="max_special_offers" select="$infoPagePreferences/property[@name = 'index_max_special_offers']"/>
					<xsl:if test="$isAdmin = 1">
						<div class="hidden hidden-text">
							<span>
								<span>&show-special-offers;:</span>&nbsp;
								<span umi:element-id="{$infoPageId}" umi:field-name="index_catalog_show_special_offer" umi:field-type="boolean">
									<xsl:choose>
										<xsl:when test="$infoPagePreferences/property[@name = 'index_catalog_show_special_offer']/value = 1">&yes;</xsl:when>
										<xsl:otherwise>&no;</xsl:otherwise>
									</xsl:choose>
								</span>
							</span>
						</div>
					</xsl:if>

					<xsl:if test="$infoPagePreferences/property[@name = 'index_catalog_show_special_offer']/value = 1">
						<xsl:variable name="special_offers" select="document(concat('usel://getSpecialOffers/?limit=', $max_special_offers/value))/udata"/>
						<xsl:if test="$special_offers/total &gt; 0">

							<h5 class="shop-heading">
								<span class="h2_content" umi:element-id="{$infoPageId}" umi:empty="&empty-special-offers;" umi:field-name="mainpage_special_offers_title">
									<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_special_offers_title']"/>
								</span>
							</h5>

							<ul class="thumbnails section" id="special-offers">
								<xsl:apply-templates select="$special_offers" mode="special_offers_s1"/>
							</ul>
							<a class="prev" id="spec_prev" href="#"></a>
							<a class="next" id="spec_next" href="#"></a>
						</xsl:if>
					</xsl:if>
				</div>
			</div>
		</div>

		<div class="row-fluid for-popular-offers">
			<div class="span12 pos-rel">
				<div class="container">
					<!-- Popular offers - hardCoded from category.xsl -->
					<xsl:variable name="max_popular_offers" select="$infoPagePreferences/property[@name = 'index_max_popular_offers']"/>
					<xsl:if test="$isAdmin = 1">
						<div class="hidden hidden-text">
							<span>
								<span>&show-popular-offers;:</span>&nbsp;
								<span umi:element-id="{$infoPageId}" umi:field-name="index_catalog_show_popular_offer" umi:field-type="boolean">
									<xsl:choose>
										<xsl:when test="$infoPagePreferences/property[@name = 'index_catalog_show_popular_offer']/value = 1">&yes;</xsl:when>
										<xsl:otherwise>&no;</xsl:otherwise>
									</xsl:choose>
								</span>
							</span>
						</div>
					</xsl:if>

					<xsl:if test="$infoPagePreferences/property[@name = 'index_catalog_show_popular_offer']/value = 1">
						<xsl:variable name="popular_offers" select="document(concat('usel://getPopularOffers/?limit=', $max_popular_offers/value))/udata"/>
						<xsl:if test="$popular_offers/total &gt; 0">
							<div class="row-fluid umi-special-offers">
								<div class="span12 pos-rel">

									<h5 class="shop-heading">
										<span class="h2_content" umi:element-id="{$infoPageId}" umi:empty="&empty-popular-offers;" umi:field-name="mainpage_popular_offers_title">
											<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_popular_offers_title']"/>
										</span>
									</h5>

									<ul class="thumbnails section" id="popular-goods">
										<xsl:apply-templates select="$popular_offers" mode="popular_offers_s1"/>
									</ul>
									<a class="prev" id="pop_prev" href="#"></a>
									<a class="next" id="pop_next" href="#"></a>
								</div>
							</div>
						</xsl:if>
					</xsl:if>
				</div>
			</div>
		</div>

		<div class="row-fluid for-news-carousel">
			<div class="span12 pos-rel">
				<div class="container umi-news-carousel mt20">
					<xsl:apply-templates select="document('usel://getData//news/rubric/')/udata" mode="news_index_s1"/>
					<xsl:if test="$infoPagePreferences/property[@name = 'show_index_news']/value = 1">
						<a class="prev" id="news_prev" href="#"></a>
						<a class="next" id="news_next" href="#"></a>
					</xsl:if>
				</div>
			</div>
		</div>

		<div class="row-fluid for-grey-zone">
			<div class="span12 pos-rel">
				<div class="cover-three"></div>
				<div class="container">
					<div class="grey-zone pos-rel">
						<div class="row-fluid" id='footer-carousel'>
							<div class="span3 social_new">
								<div class="foot-h1" umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="professiya_ili_slogan">
									<xsl:apply-templates select="$infoPage/property[@name = 'professiya_ili_slogan']"/>
									<div class="r-line">.</div>
								</div>
								<xsl:call-template name="seo_text"/>
								<xsl:call-template name="social_block">
									<xsl:with-param name="class" select="'social_gray'"/>
								</xsl:call-template>
							</div>
							<div class="span3">
								<div class="foot-h1">
									&header-contact-title;
									<div class="r-line">.</div>
								</div>
								<div class="foot-box-wr">
									<div class="foot-box min">
										<div class="foot-icon adr-ic">.</div>
										<p umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="address">
											<xsl:apply-templates select="$infoPage/property[@name = 'address']"/>
										</p>
									</div>
									<div class="foot-box min">
										<div class="foot-icon tel-ic">.</div>
										<p umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="telefon">
											<xsl:apply-templates select="$infoPage/property[@name = 'telefon']"/>
										</p>
									</div>
									<div class="foot-box min">
										<div class="foot-icon mail-ic">.</div>
										<p umi:element-id="{$infoPageContacts}" umi:empty="&feedback-email;" umi:field-name="email" umi:field-type="string">
											<xsl:apply-templates select="$infoPageCont/property[@name ='email']"/>
										</p>
									</div>
									<div class="foot-box min">
										<div class="foot-icon skype-ic">.</div>
										<p umi:element-id="{$infoPageContacts}" umi:empty="&feedback-skype;" umi:field-name="Skype" umi:field-type="string">
											<xsl:apply-templates select="$infoPageCont/property[@name ='skype']"/>
										</p>
									</div>
								</div>
							</div>
							<div class="span3">
								<xsl:call-template name="custom_block_2"/>
							</div>

							<div class="span3 span-vk">
								<div class="foot-h1">
									&header-vkontakte;
									<div class="r-line"></div>
								</div>
								<div id="vk_groups"></div>
								<div class="vk_id" umi:field-name="id_vkontakte" umi:field-type="string" umi:empty="&social-vk-id;" umi:element-id="{$infoPageId}">
									<xsl:apply-templates select="$infoPage/property[@name = 'id_vkontakte']"/>
								</div>
								<script type="text/javascript" src="//vk.com/js/api/openapi.js?98"></script>
								<script type="text/javascript">
									var vk_id = $('.vk_id').text();
									if (!$('.vk_id').text().length || $('.vk_id').text() == 'ID сообщества vkontakte') {
										$('.span-vk').addClass('hidden');
									}
									else {
										VK.Widgets.Group("vk_groups", {mode: 0, width: "215", height: "260"}, vk_id);
									}
								</script>
							</div>

						</div>
						<a class="prev" id="footer_prev" href="#"></a>
						<a class="next" id="footer_next" href="#"></a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="content_in_complex_s1">
		<div class="row-fluid for-umi-breadcrumb">
			<div class="span12 pos-rel">
				<div class="container">
					<xsl:apply-templates select="." mode="breadcrumb"/>
				</div>
			</div>
		</div>

		<div class="row-fluid for-second-content">
			<div class="span12 pos-rel">
				<div class="container mb20">
					<xsl:if test="not(@module = 'catalog') or not(@method = 'object')">
						<div id="left_column" class="span3 module-{@module} method-{@method}">
							<div class="menu-vertical">
								Ved eto armia armoa
								<xsl:variable name="id" select="document('usel://getData//catalog/category/')/udata/page/@id"/>
								<xsl:apply-templates select="document(concat('udata://content/menu//3/',$id,'/'))/udata/items" mode="multilevel_menu">
									<xsl:with-param name="id" select="$id" />
								</xsl:apply-templates>
							</div>
						</div>
					</xsl:if>

					<div id="center_column" class="">
						<xsl:attribute name="class">
							<xsl:text>span12</xsl:text>
							<xsl:if test="not(@module = 'catalog') or not(@method = 'object')">
								<xsl:text> span9</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:apply-templates select="document('udata://system/listErrorMessages/')/udata"/>
						<xsl:apply-templates select="." mode="main_top_date"/>
						
						<xsl:if test="not(@module = 'catalog') or not(@method = 'object')">
							<xsl:apply-templates select="." mode="h1"/>
						</xsl:if>

						<xsl:choose>
							<xsl:when test="(@module = 'catalog') and (@method = 'category')">
								<xsl:apply-templates select="." mode="content_s1"/>
							</xsl:when>
							<xsl:when test="(@module = 'catalog') and (@method = 'object')">
								<xsl:apply-templates select="." mode="content_s1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:apply-templates select="document('udata://system/listErrorMessages/')/udata"/>
						<div class="cleaner"/>
						<xsl:call-template name="seo_text"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


</xsl:stylesheet>
