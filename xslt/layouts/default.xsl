<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
				xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Количество новстей на главной странице-->
	<xsl:variable name="indexNews" select="20"/>
	<!--Количество товаров и категорий на главной странице-->
	<xsl:variable name="indexСatalog" select="20"/>
	<!--Количество фотографий и фотоальбомов на главной странице-->
	<xsl:variable name="indexPhotoalbum" select="20"/>
	<!--Размер фотографий в фотоальбоме-->
	<xsl:variable name="photoW" select="212"/>
	<xsl:variable name="photoH" select="140"/>
	<!--Размер большой фотографии в фотоальбоме-->
	<xsl:variable name="photoFullW" select="960"/>
	<!--Размер фотографий в каталоге в плите-->
	<xsl:variable name="photoCatalogW" select="210"/>
	<xsl:variable name="photoCatalogH" select="210"/>
	<!--Размер фотографий в галерее у обьекта каталога-->
	<xsl:variable name="photoAlbumCatalogW" select="210"/>
	<xsl:variable name="photoAlbumCatalogH" select="210"/>
	<!--Размер фотографий в каталоге при выводе таблицей-->
	<xsl:variable name="photoTableCatalogW" select="160"/>
	<xsl:variable name="photoTableCatalogH" select="160"/>
	<!--Размер большой фотографии в каталоге-->
	<xsl:variable name="photoCatalogFullW" select="235"/>
	<!--Формат даты для новостей и блогов-->
	<xsl:variable name="newsDateFormat" select="'d.m.Y'"/>
	<!--Формат даты для комментариев-->
	<xsl:variable name="commentDateFormat" select="'d.m.Y%20%D0%B2%20H:i'"/>
	<!--Формат контактов (1-расширенная, 0-простая)-->
	<xsl:variable name="contactsForm" select="1"/>
	<!--Формат вывода каталога (1-расширенный, 0-простой)-->
	<xsl:variable name="сatalog" select="1"/>
	<!--Формат вывода обьектов каталога в плиткой(1-заголовок над картинкой, 0-заголовок под картинкой)-->
	<xsl:variable name="сatalogTitle" select="0"/>

	<xsl:include href="../modules/adaptive_tpl/__common.xsl" />

	<xsl:template match="/">
		<html class="adaptive shop s197" lang="{$lang}">

			<head>
				<xsl:call-template name="header"/>
				<meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, initial-scale=1.0"/>

				<script type="text/javascript">
					$(document).ready(function () {

						// Banner buttons showing
						setTimeout(function () {
							$('.direction_title').addClass('show');
						}, 500);

						// Banner buttons showing
						$('.direction_title').each(function (i) {
							if (!$(this).text().length) {
								$(this).addClass('w-text');
							}
						});

						// Footer carousel
						$('#footer-carousel').carouFredSel({
							circular: false,
							infinite: false,
							auto: {
								play: false,
								pauseOnHover: "immediate"
							},
							align: "left",
							prev: "#footer_prev",
							next: "#footer_next",
							responsive: true,
							items: {width: 280, visible: {min: 1, max: 4}},
							swipe: {
								onTouch: true,
								//onMouse: true,
								items: 1,
								easing: "linear",
								duration: 300
							},
							height: 'variable',
							mousewheel: false
						});
					});
				</script>
			</head>

			<body>
				<xsl:call-template name="application"/>

				<div class="general_wrap">
					<xsl:apply-templates select="." mode="shop_header_simple">
						<xsl:with-param name="tpl" select="'header_s1'"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="." mode="shop_content_complex">
						<xsl:with-param name="tpl" select="'content_s1'"/>
					</xsl:apply-templates>

					<div class="compensator"></div>
				</div>
				<!-- end general_wrap -->

				<xsl:apply-templates select="." mode="shop_footer_simple">
					<xsl:with-param name="tpl" select="'footer_s1'"/>
				</xsl:apply-templates>

				<xsl:call-template name="order_button"/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
