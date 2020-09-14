<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!--Полная корзина товаров-->
	<xsl:template match="summary[amount != 0]" mode="ajax-cart">
		<div id="header_basket_title" class="header_basket_title header_basket_div">
			<a href="/emarket/cart/" umi:field-name="basket_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
				<span>
					<xsl:value-of select="$infoPage/property[@name = 'basket_title']/value" disable-output-escaping="yes" />
				</span>
			</a>
		</div>
		<div id="header_basket_amount_wrapper" class="header_basket_wrapper header_basket_div">
			<span id="header_basket_goods" class="header_basket_span" umi:element-id="{$infoPageId}" umi:empty="&goods-head;" umi:field-name="header_basket_goods" umi:field-type="string">
				<xsl:value-of select="$infoPage/property[@name = 'header_basket_goods']/value" disable-output-escaping="yes" />
			</span>
			<span id="header_basket_amount" class="header_basket_span" >
				<xsl:value-of select="amount" disable-output-escaping="yes" />
			</span>
			<span id="header_basket_amount_prefix" class="header_basket_span header_basket_div">
				<xsl:text>&amount-prefix;</xsl:text>
			</span>
		</div>
		<div id="header_basket_summ_wrapper" class="header_basket_wrapper header_basket_div">
			<span id="header_basket_summ" class="header_basket_span" umi:element-id="{$infoPageId}" umi:empty="&summ-head;" umi:field-name="header_basket_sum" umi:field-type="string">
				<xsl:value-of select="$infoPage/property[@name = 'header_basket_sum']/value" disable-output-escaping="yes" />
			</span>
			<span id="header_basket_summ_head" class="header_basket_span">
				<xsl:value-of select="document('udata://emarket/cart/')/udata/summary/price/actual" disable-output-escaping="yes" />
			</span>
			<span id="header_basket_currency" class="header_basket_span" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
				<xsl:value-of select="$infoPage/property[@name = 'currency']/value" disable-output-escaping="yes" />
			</span>
		</div>
		<div id="header_basket_order" class="header_basket_div">
			<a href="/emarket/cart/">
				<span>
					<xsl:text>&order-head;</xsl:text>
				</span>
			</a>
		</div>
	</xsl:template>

	<!--Пустая корзина товаров-->
	<xsl:template match="summary" mode="ajax-cart">
		<xsl:call-template name="empty_header_basket"/>
	</xsl:template>
	
	<xsl:template name="empty_header_basket">
		<div id="empty_header_basket_title" class="header_basket_title header_basket_div" >
			<a href="/emarket/cart/" umi:field-name="basket_title" umi:field-type="string" umi:empty="&empty-basket-title;" umi:element-id="{$infoPageId}">
				<span>
					<xsl:value-of select="$infoPage/property[@name = 'basket_title']/value" disable-output-escaping="yes" />
				</span>
			</a>
		</div>
		<span id="emptybasket_title" umi:field-name="emptybasket_title" umi:field-type="string" umi:empty="&empty-empty-basket;" umi:element-id="{$infoPageId}">
			<xsl:value-of select="$infoPage/property[@name = 'emptybasket_title']/value" disable-output-escaping="yes" />
		</span>
    </xsl:template>
	
</xsl:stylesheet>