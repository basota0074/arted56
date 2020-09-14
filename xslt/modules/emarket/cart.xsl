<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template name="header_basket">
		<div class="header_basket" id="header_basket">
			<div id="header_basket_title" class="header_basket_title header_basket_div" >
				<a href="/emarket/cart/" umi:field-name="basket_title" umi:field-type="string" umi:empty="&empty-basket-title;" umi:element-id="{$infoPageId}">
					<span>
						<xsl:value-of select="$infoPage/property[@name = 'basket_title']/value" disable-output-escaping="yes" />
					</span>
				</a>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="result[@module = 'emarket' and @method = 'cart']">
        <xsl:apply-templates select="document('udata://emarket/cart/')/udata" />
    </xsl:template>

    <xsl:template match="udata[@module = 'emarket' and @method = 'cart']">
		<xsl:call-template name="empty_basket"/>
    </xsl:template>
	
	<xsl:template name="empty_basket">
		<div id="empty_basket_text_{$infoPageId}_{generate-id()}" class="text" umi:element-id="{$infoPageId}" umi:empty="&empty-empty-basket;" umi:field-name="empty_basket_text" umi:field-type="wysiwyg">
            <xsl:apply-templates select="$infoPage/property[@name = 'empty_basket_text']" />
        </div>
		<div>
			<a class="all_system_buttons system_basket_go_back" href="{$_http_referer}">&go-back;</a>
		</div>
    </xsl:template>

    <xsl:template match="udata[@module = 'emarket' and @method = 'cart'][count(items/item) &gt; 0]">
		<div class="basket_page" id="system_basket">
			<div class="basket_table_wrapper">
				<div class="basket_table_title">
					<a class="all_system_buttons system_basket_go_back" href="{$_http_referer}">&go-back;</a>
					<div class="middle">
						<span class="basket_table_title_icon middle">&nbsp;</span>
						<span class="basket_table_title_text middle">&basket-title;</span>
					</div>
					<div class="cleaner" />
				</div>
				<table class="basket_table">
					<colgroup>
						<col class="basket_col_1"/>
						<col class="basket_col_2"/>
						<col class="basket_col_3"/>
						<col class="basket_col_4"/>
						<col class="basket_col_5"/>
					</colgroup>
					<thead>
						<tr>
							<th class="basket_col_1_2" colspan="2"><xsl:text>&basket-item;:</xsl:text></th>
							<th class="basket_col_3"><xsl:text>&amount;:</xsl:text></th>
							<th class="basket_col_4"><xsl:text>&sum;:</xsl:text></th>
							<th class="basket_col_5"></th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="items/item" />
					</tbody>
					<xsl:apply-templates select="summary" />
				</table>
			</div>
		</div>
		<div id="system_empty_basket_text">
			<xsl:call-template name="empty_basket"/>
        </div>
    </xsl:template>

	<xsl:template match="udata[@module = 'emarket' and @method = 'cart']//item">
		<tr class="cart_item_{@id}">
			<td class="basket_col_1">
				<xsl:call-template name="makeThumbnailSqueeze">
					<xsl:with-param name="element_id" select="page/@id" />
					<xsl:with-param name="field_name" select="'photo'" />
					<xsl:with-param name="width" select="'80'" />
					<xsl:with-param name="alt" select="@name" />
					<xsl:with-param name="no-empty-image" select="0" />
				</xsl:call-template>
			</td>
			<td class="cart_item_name basket_col_2">
				<a href="{page/@link}">
					<xsl:value-of select="@name" disable-output-escaping="yes" />
				</a>
				<div class="basket_item_price">
					<span class="price_value">
						<xsl:value-of select="price/actual" />
					</span>
					<span umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
						<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
					</span>
				</div>
			</td>
			<td class="basket_col_3">
				<input maxlength="9" class="system_basket_amount" type="text" value="{amount}" name="{@id}" />
				<input type="hidden" value="{amount}" />
			</td>
			<td class="basket_col_4">
				<span id="cart_item_price_{@id}" class="price_value">
					<xsl:value-of select="total-price/actual" />
				</span>
				<span umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
					<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
				</span>
			</td>
			<td class="basket_col_5">
				<a class="system_basket_delete middle" href="/emarket/basket/remove/item/{@id}/" id="{@id}">x</a>
			</td>
		</tr>
	</xsl:template>

    <xsl:template match="udata[@module = 'emarket' and @method = 'cart']/summary">
        <tfoot>
            <tr>
                <td colspan="5">
					<div class="total_price">
						<span class="total_price_title">&summary-price;:</span>
						<span class="total_price_value">
							<span id="basket_summary_price">
								<xsl:value-of select="price/actual" disable-output-escaping="yes" />
							</span>
							<span umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
							</span>
						</span>
						<div class="basket_to_form_wrapper">
							<a href="{$lang-prefix}/emarket/purchase/" class="basket_submit_button">&begin-purchase;</a>
						</div>
					</div>
                </td>
            </tr>
        </tfoot>
    </xsl:template>
	
	<xsl:template match="amount">
		<xsl:value-of select="concat(., ' &amount-prefix;')" />
	</xsl:template>

</xsl:stylesheet>