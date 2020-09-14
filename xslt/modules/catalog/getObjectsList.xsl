<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsList' or @method = 'getObjectsListFull']" mode="main_list"/>

	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsList' or @method = 'getObjectsListFull'][total]" mode="main_list">
		<xsl:param name="id" />
		<ul class="main_catalog_list" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:element-id="{$id}" umi:button-position="top right" umi:add-text="&add-text-catalog-object;">
			<xsl:apply-templates select="lines/item" mode="main_list"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsList' or @method = 'getObjectsListFull']"/>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsList' or @method = 'getObjectsListFull'][total]">
		<xsl:choose>
			<xsl:when test="$сatalog = 2">
				<xsl:apply-templates select="lines/item" mode="text_catalog_list"/>
			</xsl:when>
			<xsl:when test="$сatalog = 1">
				<xsl:apply-templates select="lines/item"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="lines/item" mode="simple_catalog"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="udata" mode="special_offers">
		<xsl:choose>
			<xsl:when test="$сatalog = 1">
				<xsl:apply-templates select="page" mode="simple_shop_catalog"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="page" mode="simple_catalog"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Кнопка-->
	<xsl:template match="page" mode="buy_button">
		<xsl:param name="class"/>
		<div class="buy_button">
			<xsl:if test="//group[@name = 'catalog_option_props']/property/value/option">
				<xsl:attribute name="class">buy_button buy_button_popup</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="//property[@name='common_quantity']/value &gt; 0">
					<a class="{$class} button_buy" id="{@id}_add_basket" href="/emarket/basket/put/element/{@id}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="buy_title" umi:field-type="string" umi:empty="&empty-buy-title;">
						<xsl:value-of select="$infoPage/property[@name = 'buy_title']/value" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a class="button_buy button_buy_order" id="{@id}_add_basket" href="/emarket/basket/put/element/{@id}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="title_order_link" umi:field-type="string" umi:empty="&empty-order-title;">
						<xsl:value-of select="$infoPage/property[@name = 'title_order_link']/value" />
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<!--Простой список товаров-->
	<xsl:template match="udata[@method = 'getObjectsList' or @method = 'getObjectsListFull']/lines/item|page" mode="simple_catalog">
		<xsl:variable name="page" select="document(concat('upage://',@id))/udata/page" />
		<li class="simple_catalog_item objectlist" umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog-object;">
			<xsl:if test="$сatalogTitle">
				<div class="object_title object_title_top">
					<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
						<xsl:value-of select="$page/name" disable-output-escaping="yes" />
					</a>
				</div>
				<div class="object_prefix object_prefix_top" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" >
					<xsl:value-of select="$page//property[@name = 'prefix']/value" disable-output-escaping="yes"/>
				</div>
			</xsl:if>
			<a href="{@link}" class="object_item_img" umi:url-attribute="href">
				<xsl:call-template name="makeThumbnailSqueeze">
					<xsl:with-param name="element_id" select="@id" />
					<xsl:with-param name="field_name" select="'photo'" />
					<xsl:with-param name="width" select="$photoCatalogW" />
					<xsl:with-param name="height" select="$photoCatalogH" />
					<xsl:with-param name="alt" select="." />
					<xsl:with-param name="no-empty-image" select="0" />
				</xsl:call-template>
			</a>
			<xsl:if test="not($сatalogTitle)">
				<div class="object_title object_title_bottom">
					<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
						<xsl:value-of select="$page/name" disable-output-escaping="yes" />
					</a>
				</div>
				<div class="object_prefix object_prefix_bottom" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" >
					<xsl:value-of select="$page//property[@name = 'prefix']/value" disable-output-escaping="yes"/>
				</div>
			</xsl:if>
			<div id="desc_{@id}_{generate-id()}" class="desc text" umi:field-name="desc" umi:field-type="wysiwyg" umi:empty="&empty-desc;" >
				<xsl:value-of select="$page//property[@name = 'desc']/value" disable-output-escaping="yes"/>
			</div>
		</li>
	</xsl:template>
	
	<!--Списки товаров для интернет магазина-->
	<xsl:template match="udata[@method = 'getObjectsList' or @method = 'getObjectsListFull']/lines/item">
		<xsl:apply-templates select="." mode="simple_shop_catalog"/>
	</xsl:template>
	
	<xsl:template match="item|page" mode="simple_shop_catalog">
		<xsl:variable name="page" select="document(concat('upage://',@id))/udata/page" />
		<li umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog-object;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">objectlist cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">objectlist cat-item-inactive</xsl:if>
			</xsl:attribute>
			<xsl:if test="$isAdmin = 1">
				<div class="catalog-objects-amount">
					<xsl:text>&in-stock;:</xsl:text>
					<span umi:field-name="common_quantity" umi:field-type="int" umi:empty="&empty;"><xsl:apply-templates select="$page//property[@name = 'common_quantity']" /></span>
				</div>
			</xsl:if>
			<xsl:if test="$сatalogTitle">
				<div class="object_title">
					<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;">
						<xsl:value-of select="$page/name" disable-output-escaping="yes" />
					</a>
				</div>
				<div class="prefix" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" >
					<xsl:value-of select="$page//property[@name = 'prefix']/value" />
				</div>
			</xsl:if>
			<a href="{@link}" class="object_item" umi:url-attribute="href">
				<xsl:call-template name="makeThumbnailSqueeze">
					<xsl:with-param name="element_id" select="@id" />
					<xsl:with-param name="field_name" select="'photo'" />
					<xsl:with-param name="width" select="$photoCatalogW" />
					<xsl:with-param name="height" select="$photoCatalogH" />
					<xsl:with-param name="alt" select="." />
					<xsl:with-param name="no-empty-image" select="0" />
				</xsl:call-template>
			</a>
			<xsl:if test="not($сatalogTitle)">
				<div class="object_title">
					<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;">
						<xsl:value-of select="$page/name" disable-output-escaping="yes" />
					</a>
				</div>
				<div class="prefix" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" >
					<xsl:apply-templates select="document(concat('upage://',@id,'.prefix'))/udata/property[value]" />
				</div>
			</xsl:if>
			
			<xsl:variable name="old_price" select="$page//property[@name = 'old_price']/value" />
			<xsl:variable name="price" select="$page//property[@name = 'price']/value" />
			
			<div class="price">
				<span class="price_value" umi:field-name="price" umi:field-type="price" umi:empty="&empty-price;">
					<xsl:apply-templates select="$price" />
				</span>
				<xsl:text>&nbsp;</xsl:text>
				<span class="price_currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
					<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
				</span>
			</div>
            
            <!--Старая цена -->
			<xsl:if test="($isAdmin = 1) or ($price &lt; $old_price)">
				<div>
					<xsl:attribute name="class">
						<xsl:text>price old_price</xsl:text>
						<xsl:if test = "$price &gt;= $old_price">
							<xsl:text> hidden</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<span class="wrapper_for_old_price">
						<hr class="strike"/>
						<span class="price_value" umi:field-name="old_price" umi:field-type="price" umi:empty="&empty-price;">
							<xsl:apply-templates select="$old_price" />
						</span>
						<xsl:text>&nbsp;</xsl:text>
						<span class="price_currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
							<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
						</span>
					</span>
				</div>
			</xsl:if>
			<!--Кнопка-->
			<xsl:apply-templates select="$page" mode="buy_button">
				<xsl:with-param name="class" select="''"/>
			</xsl:apply-templates>
		</li>
	</xsl:template>

	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull']" mode="layout_1" />

	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull'][total]" mode="layout_1">
		<xsl:apply-templates select="lines/item" mode="layout_1" />
	</xsl:template>

	<xsl:template match="udata[@method = 'getObjectsListFull']/lines/item" mode="layout_1" >
		<xsl:variable name="page" select="document(concat('upage://',@id, '?show-empty'))/udata/page" />
		<xsl:variable name="old_price" select="$page//property[@name = 'old_price']/value" />
		<xsl:variable name="price" select="$page//property[@name = 'price']/value" />
		<tr umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog-object;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">cat-item-inactive</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="position() = 1">first</xsl:when>
					<xsl:when test="position() = last()">last</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td>
				<a href="{@link}" class="object_item" umi:url-attribute="href">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="@id" />
						<xsl:with-param name="field_name" select="'photo'" />
						<xsl:with-param name="width" select="$photoTableCatalogW" />
						<xsl:with-param name="height" select="$photoTableCatalogH" />
						<xsl:with-param name="alt" select="." />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</a>
			</td>
			<td class="content_column">
				<a class="title_left" href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty;" umi:url-attribute="href">
					<xsl:value-of select="$page/name" disable-output-escaping="yes" />
				</a>
				<div umi:field-name="prefix" umi:field-type="string" umi:empty="&empty;">
					<xsl:apply-templates select="$page//property[@name='prefix']/value" />
				</div>
				<xsl:variable name="obj_type">
					<xsl:value-of select="document(concat('upage://', @id))/udata/page/@type-id" />
				</xsl:variable>
				<xsl:apply-templates select="document(concat('utype://', $obj_type, '.product'))/udata/group/field[@visible = 'visible' and @name = 'artikul']" mode="artikul_in_list">
					<xsl:with-param name="page_id" select="@id" />
				</xsl:apply-templates>
				<div class="obj_short_desc">
					<xsl:apply-templates select="$page//group[@name='special']/property" mode="special_as_text" />
				</div>
			</td>
			<td class="price_column">
				<div class="price">
					<span class="price" umi:field-name="price" umi:field-type="price" umi:empty="&empty;">
						<xsl:apply-templates select="$price" />
					</span>
					<span umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="currency" umi:field-type="string">
						<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
					</span>
				</div>
				<!--Старая цена -->
				<xsl:if test="($isAdmin = 1) or ($price &lt; $old_price)">
					<div>
						<xsl:attribute name="class">
							<xsl:text>price old_price</xsl:text>
							<xsl:if test = "$price &gt;= $old_price">
								<xsl:text> hidden</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<span class="wrapper_for_old_price">
							<hr class="strike"/>
							<span class="price_value" umi:field-name="old_price" umi:field-type="price" umi:empty="&empty-price;">
								<xsl:apply-templates select="$old_price" />
							</span>
							<xsl:text>&nbsp;</xsl:text>
							<span class="price_currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
							</span>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="$isAdmin = 1">
					<div class="catalog-objects-amount hidden-for-guest">
						<xsl:text>&in-stock;:</xsl:text>
						<xsl:variable name="pageForQuantity" select="document(concat('upage://', @id))/udata" />
						<span umi:field-name="common_quantity" umi:field-type="int" umi:empty="&empty;"><xsl:apply-templates select="$pageForQuantity//property[@name = 'common_quantity']" /></span>
					</div>
				</xsl:if>
			</td>
			<td class="buy_column">
				<!--Кнопка-->
				<xsl:apply-templates select="$page" mode="buy_button">
					<xsl:with-param name="class" select="''"/>
				</xsl:apply-templates>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="property" mode="special_as_text">
		<xsl:variable name="field_value">
			<xsl:apply-templates select="." mode="simple" />
		</xsl:variable>
		<xsl:if test="$field_value != ''">
			<span>
				<xsl:value-of select="title" disable-output-escaping="yes" />
				<xsl:text>: </xsl:text>
				<xsl:value-of select="$field_value" />
				<xsl:if test="position() = last()">.</xsl:if>
				<xsl:if test="not(position() = last())">;</xsl:if>
			</span>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull']" mode="layout_2" />

	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull'][total]" mode="layout_2">
		<xsl:apply-templates select="lines/item" mode="layout_2" />
	</xsl:template>

	<xsl:template match="udata[@method = 'getObjectsListFull']/lines/item" mode="layout_2" >
		<xsl:variable name="page" select="document(concat('upage://',@id,'?show-empty'))/udata/page" />
		<tr umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog-object;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">cat-item-inactive</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="position() = 1">first</xsl:when>
					<xsl:when test="position() = last()">last</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td class="title_column">
				<a class="title_left" href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty;">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</td>
			<td class="prefix_column">
				<span umi:field-name="prefix" umi:field-type="string" umi:empty="&empty;">
					<xsl:apply-templates select="$page//property[@name='prefix']/value" />
				</span>
			</td>
			<td>
				<xsl:variable name="obj_type">
					<xsl:value-of select="$page/@type-id" />
				</xsl:variable>
				<xsl:apply-templates select="document(concat('utype://', $obj_type, '.product'))/udata/group/field[@visible = 'visible' and @name = 'artikul']" mode="artikul_in_list">
					<xsl:with-param name="page_id" select="@id" />
				</xsl:apply-templates>
			</td>
			<td class="price_column">
				<span class="price" umi:field-name="price" umi:field-type="price" umi:empty="&empty;">
					<xsl:apply-templates select="$page//property[@name='price']/value" />
				</span>
				<xsl:text> </xsl:text>
				<span umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="currency" umi:field-type="string">
					<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
				</span>
				<xsl:if test="$isAdmin = 1">
					<div class="catalog-objects-amount hidden-for-guest">
						<xsl:text>&in-stock;:</xsl:text>
						<span umi:field-name="common_quantity" umi:field-type="int" umi:empty="&empty;"><xsl:apply-templates select="$page//property[@name = 'common_quantity']" /></span>
					</div>
				</xsl:if>
			</td>
			<td class="buy_column">
				<!--Кнопка-->
				<div class="buy_button">
					<xsl:if test="$page//group[@name = 'catalog_option_props']/property/value/option">
						<xsl:attribute name="class">buy_button buy_button_popup</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$page//property[@name='common_quantity']/value &gt; 0">
							<a class="button_buy" id="{@id}_add_basket" href="/emarket/basket/put/element/{@id}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="buy_title" umi:field-type="string" umi:empty="&empty-buy-title;">
								<xsl:value-of select="$infoPage/property[@name = 'buy_title']/value" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="button_buy button_buy_order" id="{@id}_add_basket" href="/emarket/basket/put/element/{@id}/?redirect-uri=/emarket/cart/" umi:element-id="{$infoPageId}" umi:field-name="title_order_link" umi:field-type="string" umi:empty="&empty-order-title;">
								<xsl:value-of select="$infoPage/property[@name = 'title_order_link']/value" />
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="field[@name = 'artikul']" mode="artikul_in_list">
		<xsl:param name="page_id" />
		<xsl:variable name="artikul" select="document(concat('upage://',$page_id,'.artikul'))/udata/property[value]" />
		<xsl:apply-templates select="$artikul" mode="simple_artikul" />
		<span umi:field-name="artikul" umi:field-type="string" umi:empty="&articul-title-inlist;">
			<xsl:value-of select="$artikul/value" />
		</span>
	</xsl:template>

	<xsl:template match="property" mode="simple_artikul">
		&articul-title-inlist;:&nbsp;
	</xsl:template>

</xsl:stylesheet>