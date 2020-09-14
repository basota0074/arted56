<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@module = 'catalog'][@method = 'object']">
		<xsl:variable name="old_price" select="//property[@name = 'old_price']/value" />
		<xsl:variable name="price" select="//property[@name = 'price']/value" />
		<xsl:variable name="catalog_option_props" select="//group[@name = 'catalog_option_props']" />
		<!--Краткое описание-->
		<xsl:if test="$сatalog != 3">
			<div class="catalog_object_prefix catalog_object_prefix_bottom" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" umi:element-id="{$pageId}">
				<xsl:apply-templates select="//property[@name = 'prefix']" />
			</div>
		</xsl:if>
		<div class="object" umi:element-id="{$pageId}">
			<!--Изображение-->
			<xsl:if test="$сatalog != 2 and $сatalog != 3">
				<div class="object_image">
					<a class="object_image_a fancybox-group" title="{page/name}" href="{//property[@name = 'photo']/value}" rel="{page/@alt-name}" umi:url-attribute="href">
						<xsl:if test="not(//property[@name = 'photo']/value)">
							<xsl:attribute name="href">&empty-photo;</xsl:attribute>
						</xsl:if>
						<xsl:call-template name="makeThumbnailSqueeze">
							<xsl:with-param name="element_id" select="$pageId" />
							<xsl:with-param name="field_name" select="'photo'" />
							<xsl:with-param name="width" select="$photoCatalogFullW" />
							<xsl:with-param name="alt" select="//property[@name = 'h1']/value" />
						</xsl:call-template>
					</a>
				</div>
			</xsl:if>
			<!--Конец-->
			
			<xsl:if test="$isAdmin = 1">
				<div class="hidden catalog-info">
					<span class="hidden-text middle">
						<span>&catalog-type;: </span>
						<span>
							<xsl:value-of select="document(concat('utype://',page/@type-id))/udata/type/@title" disable-output-escaping="yes"/>
						</span>
					</span>
				</div>
				<xsl:call-template name="special_offer" />
			</xsl:if>

			<!--Цена-->
			<xsl:if test="$сatalog = 1">
				<div class="price price_top">
					<span class="price_title" umi:element-id="{$infoPageId}" umi:empty="&empty-price-title;" umi:field-name="catalog_price_title" umi:field-type="string">
						<xsl:apply-templates select="$infoPage/property[@name = 'catalog_price_title']" />
					</span>
					<span class="price price_value" umi:field-name="price" umi:field-type="price" umi:empty="&empty-price;" umi:element-id="{$pageId}">
						<xsl:apply-templates select="//property[@name = 'price']" />
					</span>
					<span class="currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string" >
						<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
					</span>
				</div>
			</xsl:if>
			<!--Конец-->
            
			<!--Старая цена-->
			<xsl:if test="$сatalog = 1">
				<xsl:if test="($isAdmin = 1) or ($price &lt; $old_price)">
					<div>
						<xsl:attribute name="class">
							<xsl:text>price price_top old_price</xsl:text>
							<xsl:if test = "$price &gt;= $old_price">
								<xsl:text> hidden</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<span class="wrapper_for_old_price">
							<hr class="strike"/>
							<span class="price_title" umi:element-id="{$infoPageId}" umi:empty="&empty-price-title;" umi:field-name="catalog_old_price_title" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'catalog_old_price_title']" />
							</span>
							<xsl:text> </xsl:text>
							<span class="price" umi:field-name="old_price" umi:field-type="price" umi:empty="&empty-price;" umi:element-id="{$pageId}">
								<xsl:apply-templates select="//property[@name = 'old_price']" />
							</span>
							<xsl:text> </xsl:text>
							<span class="currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string" >
								<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
							</span>
						</span>
					</div>
				</xsl:if>
			</xsl:if>
			<!--Конец-->
						
			<!-- Опциональные Свойства -->
			<xsl:choose>
				<xsl:when test="$isAdmin = 1">
					<xsl:apply-templates select="document(concat('upage://', $pageId,'?show-empty'))//group[@name = 'catalog_option_props']" mode="catalog_opt_props" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$catalog_option_props" mode="catalog_opt_props"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<!--Кнопка-->
			<xsl:if test="$сatalog = 1">
				<div class="buy_button">
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
				</div>
			</xsl:if>
			<!--Конец-->
			
			<!--Цена-->
			<xsl:if test="$сatalog = 1 or $сatalog = 3">
				<div class="price price_bottom">
					<span class="price_title" umi:element-id="{$infoPageId}" umi:empty="&empty-price-title;" umi:field-name="catalog_price_title" umi:field-type="string">
						<xsl:apply-templates select="$infoPage/property[@name = 'catalog_price_title']" />
					</span>
					<xsl:text> </xsl:text>
					<span class="price  price_value" umi:field-name="price" umi:field-type="price" umi:empty="&empty-price;" umi:element-id="{$pageId}">
						<xsl:apply-templates select=".//property[@name = 'price']" />
					</span>
					<xsl:text> </xsl:text>
					<span class="currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string" >
						<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
					</span>
				</div>
			</xsl:if>
			<!--Конец-->
            
			<!--Старая цена-->
			<xsl:if test="$сatalog = 1 or $сatalog = 3">
				<xsl:if test="($isAdmin = 1) or ($price &lt; $old_price)">
					<div>
						<xsl:attribute name="class">
							<xsl:text>price price_bottom old_price</xsl:text>
							<xsl:if test = "$price &gt; $old_price">
								<xsl:text> hidden</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<span class="wrapper_for_old_price">
							<hr class="strike" />
							<span class="price_title" umi:element-id="{$infoPageId}" umi:empty="&empty-price-title;" umi:field-name="catalog_old_price_title" umi:field-type="string">
								<xsl:apply-templates select="$infoPage/property[@name = 'catalog_old_price_title']" />
							</span>
							<xsl:text> </xsl:text>
							<span class="price" umi:field-name="old_price" umi:field-type="price" umi:empty="&empty-price;" umi:element-id="{$pageId}">
								<xsl:apply-templates select="//property[@name = 'old_price']" />
							</span>
							<xsl:text> </xsl:text>
							<span class="currency" umi:element-id="{$infoPageId}" umi:empty="&empty-currency;" umi:field-name="currency" umi:field-type="string" >
								<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
							</span>
						</span>
					</div>
				</xsl:if>
			</xsl:if>
			<!--Конец-->

			<!--Таблица-->
			<xsl:if test="$сatalog = 1 or $сatalog = 3">
				<xsl:variable name="pageTypeId" select="page/@type-id" />
				<xsl:variable name="page" select="document(concat('upage://', $pageId,'?show-empty'))/udata" />
				<table class="catalog_propertys">
					<xsl:apply-templates select="document(concat('utype://', $pageTypeId, '.product'))/udata/group/field[@name = 'artikul'][@visible = 'visible']" mode="product_group" />
					<xsl:apply-templates select="document(concat('utype://', $pageTypeId, '.special'))/udata/group/field[@visible = 'visible']" mode="catalog_table_propertys" >
						<xsl:with-param name="page" select="$page" />
					</xsl:apply-templates>
				</table>
				<xsl:if test="(//property[@name = 'description']/value != '&lt;br&gt;') and (//property[@name = 'description']/value) and (//property[@name = 'description']/value != '')">
					<div class="catalog_h2 h2">
						<span umi:element-id="{$infoPageId}" umi:empty="&empty-catalog-description;" umi:field-name="good_descr" umi:field-type="string">
							<xsl:apply-templates select="$infoPage/property[@name = 'good_descr']" />
						</span>
					</div>
				</xsl:if>
			</xsl:if>
			<!--Конец-->
			
			<!--Основное описание-->
			<div class="text" id="description_{$pageId}_{generate-id()}" umi:element-id="{$pageId}" umi:field-name="description" umi:field-type="wysiwyg" umi:empty="&empty-page-content;">
				<xsl:apply-templates select="//property[@name = 'description']" />
			</div>
			<!--Конец-->
			
			<!--Произвольный код на странице-->
			<xsl:choose>
				<xsl:when test="not(//property[@name = 'code']/value) and ($isAdmin = 0)"></xsl:when>
				<xsl:otherwise>
					<div class="content_code code_pre" umi:field-name="code" umi:field-type="text" umi:element-id="{$pageId}" umi:empty="&empty-code;">
						<xsl:apply-templates select="//property[@name = 'code']/value" mode="code"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			<!--Конец-->
			
			<div class="cleaner"/>
			
			<!--Файлы для скачивания у объекта каталога-->
			<xsl:apply-templates select="document(concat('udata://filemanager/list_files/',@id,'//1000/1/'))/udata" />
			<!--Конец-->
			
			<!--Фотографии у объекта каталога-->
			<xsl:variable name="photos" select="document(concat('usel://getContent//photoalbum/photo/',page/@id,'/1/'))/udata" />
			<ul class="photo_list catalog_photo_list" umi:element-id="{$pageId}" umi:type-id="{$photoPageTypeId}"  umi:region="list" umi:sortable="sortable" umi:module="photoalbum" umi:add-method="none">
				<xsl:attribute name="umi:photo-type-id"><xsl:value-of select="$photoPageTypeId" /></xsl:attribute>
				<xsl:if test="not($photos/total) or ($photos/total = 0)"><xsl:call-template name="photo_blank" /></xsl:if>
				<xsl:apply-templates select="$photos/page" mode="photoalbum_photo">
					<xsl:with-param name="photo_album_name" select="page/@alt-name" />
					<xsl:with-param name="width" select="$photoAlbumCatalogW" />
					<xsl:with-param name="height" select="$photoAlbumCatalogH" />
					<xsl:with-param name="no_page" select="1" />
				</xsl:apply-templates>
			</ul>
			<!--Конец-->
			
			<!--Социальный блок-->
			<xsl:if test="$infoPageSocial/property[@name = 'show_social_block_catalog']/value = 1">
				<xsl:call-template name="like_block"/>
			</xsl:if>
			<!--Конец-->
			
			<!--Отзывы-->
			<xsl:if test="$isAdmin = 1">
				<div class="hidden">
					<div class="hidden-text">
						<span>&show-reviews-in-directory;:</span>&nbsp;
						<span umi:element-id="{$infoPageId}" umi:field-name="reviewed_in_directory" umi:field-type="boolean">
							<xsl:choose>
								<xsl:when test="$infoPagePreferences/property[@name = 'reviewed_in_directory']/value = 1">&yes;</xsl:when>
								<xsl:otherwise>&no;</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="$infoPagePreferences/property[@name = 'reviewed_in_directory']/value = 1">
				<xsl:call-template name="reviews">
					<xsl:with-param name="url" select="concat('http://',$_http_host,page/@link)" />
				</xsl:call-template>
			</xsl:if>
			<!--Конец-->
		</div>
	</xsl:template>
	
	<!--Редактируемые поля для каталога-->
	<xsl:template match="field" mode="catalog_table_propertys">
		<xsl:param name="page"/>
		<xsl:variable name="field_name" select="@name" />
		<xsl:apply-templates select="$page//property[@name = $field_name]" mode="eip_props_table" />
	</xsl:template>

	<xsl:template match="field" mode="product_group">
		<xsl:variable name="field_name" select="@name" />
		<xsl:apply-templates select="document(concat('upage://', $pageId,'?show-empty'))//group[@name = 'product']/property[@name = $field_name]" mode="eip_props_table">
			<xsl:with-param name="class" select="'artikul_row'" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="result[@module = 'catalog'][@method = 'object']" mode="prefix">
		<div class="catalog_object_prefix catalog_object_prefix_top" umi:field-name="prefix" umi:field-type="string" umi:empty="&empty-prefix;" umi:element-id="{$pageId}">
			<xsl:apply-templates select=".//property[@name = 'prefix']" />
		</div>
	</xsl:template>
	
	<xsl:template name="special_offer">
		<div class="hidden catalog-info">
			<span class="hidden-text middle">
				<span>&special-offer;: </span>
				<span umi:element-id="{$pageId}" umi:field-name="special_offer" umi:field-type="boolean">
					<xsl:choose>
						<xsl:when test="//property[@name = 'special_offer']/value = 1">&yes;</xsl:when>
						<xsl:otherwise>&no;</xsl:otherwise>
					</xsl:choose>
				</span>
			</span>
		</div>
	</xsl:template>
	
	<!-- Опциональные свойства -->
	<xsl:template match="group" mode="catalog_opt_props">
		<div class="opt_props">
			<xsl:apply-templates select="./property" mode="catalog_opt_props" />
		</div>
	</xsl:template>
	
	<xsl:template match="property[@type = 'optioned']" mode="catalog_opt_props">
		<span class="opt_prop_block" umi:element-id="{$pageId}" umi:field-type="optioned">
			<xsl:attribute name="umi:fieldId"><xsl:value-of select="@id" /></xsl:attribute>
			<xsl:attribute name="umi:fieldName"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:if test="not(value/*)">
				<xsl:attribute name="class">opt_prop_block hidden</xsl:attribute>
			</xsl:if>
			<span class="opt_props_title persist">
				<xsl:value-of select="title" disable-output-escaping="yes"/>:
			</span>
			<xsl:apply-templates select="value/option" mode="catalog_opt_props" />
		</span>
	</xsl:template>
	
	<xsl:template match="value/option" mode="catalog_opt_props">
		<div class="opt_prop">
			<input type="radio">
				<xsl:attribute name="value"><xsl:value-of select="@float" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="../../@name" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="object/@id" /></xsl:attribute>
			</input>
			<span class="opt_prop_rel">
				<xsl:value-of select="object/@name" disable-output-escaping="yes"/>
			</span>
		</div>
	</xsl:template>
	
</xsl:stylesheet>