<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@method = 'search' or @method = 'customSearch']">
		<form id="catalog_filters" method="get" action="">
			<input type="hidden" id="order" name="order_filter_placeholder" value="1" />
			<input type="hidden" id="order_filter_name" name="order_filter_name" value="{$order_filter_name}" />
			<input type="hidden" id="catalog_layout" name="catalog_layout" value="{$catalog_layout}" />
			<input type="hidden" id="catalog_per_page" name="catalog_per_page" value="{$catalog_per_page}" />
			<xsl:apply-templates select="group" mode="search"/>
		</form>
	</xsl:template>
	
	<xsl:template match="group" mode="search"/>

	<xsl:template match="group[count(field/values/item) &gt; 0]" mode="search">
		<fieldset class="catalog_filters">
			<table class="ct_filter_values">
				<colgroup>
					<col class="ct_filter_col_1"/>
					<col class="ct_filter_col_2"/>
				</colgroup>
				<tbody>
					<xsl:apply-templates select="field" mode="search" />
				</tbody>
			</table>
			<div class="catalog_filters_control">
				<a id="catalog_filters_reset" class="all_system_buttons" href="?">&reset;</a>
			</div>
		</fieldset>
	</xsl:template>

	<xsl:template match="field" mode="search" />

	<xsl:template match="field[@data-type = 'relation']" mode="search">
		<xsl:if test="count(values/item) != 0">
			<tr class="ct_filter_row">
				<td class="ct_filter_row_title"><span><xsl:value-of select="@title" disable-output-escaping="yes" /><xsl:text>:</xsl:text></span></td>
				<td class="ct_filter_row_value">
					<xsl:apply-templates select="values/item" mode="search" />
					<xsl:apply-templates select="values/item[@selected]" mode="search-сontrol" />
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="item" mode="search">
		<a class="filter_anchor" id="set_{../../@name}" href="?fields_filter[{../../@name}]={@id}">
			<xsl:value-of select="." disable-output-escaping="yes" />
		</a>
		<xsl:if test="position() != last()">
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="item[@selected]" mode="search">
		<span class="filter_anchor act">
			<xsl:value-of select="." disable-output-escaping="yes" />
		</span>
		<xsl:if test="position() != last()">
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="item[@selected]" mode="search-сontrol">
		<input type="hidden" id="field_{../../@name}" name="fields_filter[{../../@name}]" value="{@id}" />
	</xsl:template>

</xsl:stylesheet>