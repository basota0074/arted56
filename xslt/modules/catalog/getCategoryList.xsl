<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull']" />

	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull']" mode="layout_1" />

	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull']" mode="layout_2" />
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull']" mode="main_list"/>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull'][total]">
		<xsl:apply-templates select="items/item" />
	</xsl:template>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull'][total]" mode="layout_1">
		<xsl:apply-templates select="items/item" mode="layout_1" />
	</xsl:template>

	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull'][total]" mode="layout_2">
		<xsl:apply-templates select="items/item" mode="layout_2" />
	</xsl:template>
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getCategoryList' or @method = 'getCategoryListFull'][total]" mode="main_list">
		<xsl:param name="id" />
		<ul class="main_catalog_list" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:element-id="{$id}" umi:button-position="top right" umi:add-text="&add-text-catalog;">
			<xsl:apply-templates select="items/item" mode="main_list"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'getCategoryList' or @method = 'getCategoryListFull']/items/item">
		<li class="catalog_item li_category_item" umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">cat-item-inactive</xsl:if>
				<xsl:text> catalog_item li_category_item </xsl:text>
				<xsl:choose>
					<xsl:when test="position() = 1">first</xsl:when>
					<xsl:when test="position() = last()">last</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<div class="category_title category_title_top">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-section-name;" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</div>
			<a class="catalog_item_img" href="{@link}" umi:url-attribute="href">
				<xsl:call-template name="makeThumbnailSqueeze">
					<xsl:with-param name="element_id" select="@id" />
					<xsl:with-param name="field_name" select="'header_pic'" />
					<xsl:with-param name="width" select="$photoCatalogW" />
					<xsl:with-param name="height" select="$photoCatalogH" />
					<xsl:with-param name="alt" select="." />
					<xsl:with-param name="no-empty-image" select="0" />
				</xsl:call-template>
			</a>
			<div class="category_title category_title_bottom">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-section-name;" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</div>
		</li>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList' or @method = 'getCategoryListFull']/items/item" mode="layout_1">
		<tr class="catalog_item layout_1_category_item" umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">cat-item-inactive</xsl:if>
				<xsl:text> catalog_item layout_1_category_item </xsl:text>
				<xsl:choose>
					<xsl:when test="position() = 1">first</xsl:when>
					<xsl:when test="position() = last()">last</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td>
				<a class="catalog_item_img" href="{@link}" umi:url-attribute="href">
					<xsl:call-template name="makeThumbnailSqueeze">
						<xsl:with-param name="element_id" select="@id" />
						<xsl:with-param name="field_name" select="'header_pic'" />
						<xsl:with-param name="width" select="$photoTableCatalogW" />
						<xsl:with-param name="height" select="$photoTableCatalogH" />
						<xsl:with-param name="alt" select="." />
						<xsl:with-param name="no-empty-image" select="0" />
					</xsl:call-template>
				</a>
			</td>
			<td colspan="4">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-section-name;" class="title" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="udata[@method = 'getCategoryList' or @method = 'getCategoryListFull']/items/item" mode="layout_2">
		<tr class="catalog_item layout_2_category_item" umi:region="row" umi:element-id="{@id}" umi:delete="delete" umi:delete-text="&delete-text-catalog;">
			<xsl:attribute name="class">
				<xsl:if test="@is-active">cat-item-active</xsl:if>
				<xsl:if test="not(@is-active)">cat-item-inactive</xsl:if>
				<xsl:text> catalog_item layout_2_category_item </xsl:text>
				<xsl:choose>
					<xsl:when test="position() = 1">first</xsl:when>
					<xsl:when test="position() = last()">last</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td colspan="7">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-section-name;" class="title" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>