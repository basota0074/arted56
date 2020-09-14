<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull']" mode="table_catalog_layout" />

	<xsl:template match="udata[@module = 'catalog'][@method = 'getObjectsListFull'][total]" mode="table_catalog_layout">
		<xsl:apply-templates select="lines/item" mode="table_catalog_layout" />
	</xsl:template>

	<xsl:template match="item" mode="table_catalog_layout" >
		<xsl:variable name="page" select="document(concat('upage://',@id,'?show-empty'))/udata/page" />
		<xsl:variable name="pageTypeId" select="$page/@type-id" />
		<tr umi:region="row" umi:element-id="{@id}" umi:delete="delete">
			<td class="content_column">
				<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty;" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
			</td>
			<xsl:apply-templates select="document(concat('utype://',$pageTypeId))//group[@name = 'special']/field[@filterable = 'filterable']" mode="table_catalog_layout">
				<xsl:with-param name="page" select="$page" />
			</xsl:apply-templates>
			<td class="price_column">
				<span class="price" umi:field-name="price" umi:field-type="price" umi:empty="&empty;">
					<xsl:apply-templates select="$page//property[@name = 'price']" />
				</span>
				<xsl:text> </xsl:text>
				<span umi:element-id="{$infoPageId}" umi:empty="&empty;" umi:field-name="currency" umi:field-type="string">
					<xsl:apply-templates select="$infoPage/property[@name = 'currency']" />
				</span>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="field" mode="table_catalog_layout" >
		<xsl:param name="page"/>
		<xsl:variable name="field_name" select="@name" />
		<td>
			<xsl:apply-templates select="$page//property[@name = $field_name]" mode="eip_props_table_value">
				<xsl:with-param name="id" select="$page/@id" />
			</xsl:apply-templates>
		</td>
	</xsl:template>
	
	<xsl:template match="item" mode="table_catalog_layout_header" >
		<tr umi:region="row" umi:element-id="{@id}">
			<th class="title_column">
				&table-item-title;
			</th>
			<xsl:apply-templates select="document(concat('utype://',document(concat('upage://',@id))/udata/page/@type-id))//group[@name = 'special']/field[@filterable = 'filterable']" mode="table_catalog_layout_header"/>
			<th class="price_column">
				&table-price-title;
			</th>
		</tr>
	</xsl:template>
	
	<xsl:template match="field" mode="table_catalog_layout_header" >
		<td>
			<xsl:apply-templates select="@title"/>
		</td>
	</xsl:template>

</xsl:stylesheet>