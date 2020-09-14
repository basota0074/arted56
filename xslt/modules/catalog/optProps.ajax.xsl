<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata" mode="ajax-optioned">
		<xsl:variable name="pageId" select="page/@id" />
		<div class="order_popup">
			<!-- Название товара -->
			<div class="order_popup_title">
				<xsl:value-of select="page/name" />
			</div>
			
			<!-- Опциональные Свойства -->
			<div class="opt_props">
				<xsl:apply-templates select="//group[@name = 'catalog_option_props']/property" mode="catalog_opt_props"/>
			</div>
			
			<!--Цена-->
			<span class="price">
				<span class="price_title">
					<xsl:apply-templates select="$infoPage/property[@name = 'catalog_price_title']/value" />
				</span>
				<span class="price_value">
					<xsl:apply-templates select="//property[@name = 'price']/value" />
				</span>
				<span class="currency">
					<xsl:value-of select="$infoPage/property[@name = 'currency']/value" />
				</span>
			</span>
			<!--Конец-->
			
			<!--Кнопка-->
			<span class="buy_button">
				<xsl:choose>
					<xsl:when test="//property[@name='common_quantity']/value &gt; 0">
						<a class="button_buy" id="add_basket_{$pageId}" href="/emarket/basket/put/element/{$pageId}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="buy_title" umi:field-type="string" umi:empty="&empty-buy-title;">
							<xsl:value-of select="$infoPage/property[@name = 'buy_title']/value" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a class="button_buy button_buy_order" id="add_basket_{$pageId}" href="/emarket/basket/put/element/{$pageId}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="title_order_link" umi:field-type="string" umi:empty="&empty-order-title;">
							<xsl:value-of select="$infoPage/property[@name = 'title_order_link']/value" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			<!--Конец-->
		</div>
	</xsl:template>
	
	<!-- Опциональные свойства -->
	<xsl:template match="property[@type = 'optioned']" mode="catalog_opt_props">
		<div class="opt_prop_block" umi:element-id="{$pageId}" umi:field-type="optioned">
			<span class="opt_props_title">
				<xsl:value-of select="title" />:
			</span>
			<xsl:apply-templates select="value/option" mode="catalog_opt_props" />
		</div>
	</xsl:template>
	
	<xsl:template match="value/option" mode="catalog_opt_props">
		<div class="opt_prop">
			<input type="radio">
				<xsl:attribute name="value"><xsl:value-of select="@float" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="../../@name" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="object/@id" /></xsl:attribute>
			</input>
			<span class="opt_prop_rel">
				<xsl:value-of select="object/@name" />
			</span>
		</div>
	</xsl:template>
</xsl:stylesheet>