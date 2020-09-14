<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template name="layoutcontrol">
		<div class="layout_control">
			<span>&layout-label;</span>
			<a href="#" id="layout_0">
				<xsl:if test="$catalog_layout = 0">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<xsl:text>&layout_0;</xsl:text>
			</a>
			<a href="#" id="layout_1">
				<xsl:if test="$catalog_layout = 1">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<xsl:text>&layout_1;</xsl:text>
			</a>
			<a href="#" id="layout_2">
				<xsl:if test="$catalog_layout = 2">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<xsl:text>&layout_2;</xsl:text>
			</a>
		</div>
	</xsl:template>

	<xsl:template name="perpage_control">
		<xsl:param name="current_perpage" select="$catalog_per_page" />
		<xsl:param name="perpage_level_1" select="12" />
		<xsl:param name="perpage_level_2" select="24" />
		<xsl:param name="perpage_level_3" select="48" />
		<xsl:param name="perpage_level_4" select="96" />
		<div class="catalog_perpage">
			<span>&perpage_label;</span>
			<select id="catalog_perpage">
				<option value="{$perpage_level_1}">
					<xsl:if test="$current_perpage = $perpage_level_1">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$perpage_level_1"/>
				</option>
				<option value="{$perpage_level_2}">
					<xsl:if test="$current_perpage = $perpage_level_2">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$perpage_level_2"/>
				</option>
				<option value="{$perpage_level_3}">
					<xsl:if test="$current_perpage = $perpage_level_3">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$perpage_level_3"/>
				</option>
				<option value="{$perpage_level_4}">
					<xsl:if test="$current_perpage = $perpage_level_4">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$perpage_level_4"/>
				</option>
			</select>
		</div>
	</xsl:template>

	<xsl:template name="order_control">
		<div class="catalog_order">
			<span>&order-by;</span>
			<a id="order_name" href="?order_filter[name]=1">
				<xsl:if test="$order_filter_name = '1'">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<xsl:text>&order-by-name;</xsl:text>
			</a>
			<a id="order_price" href="?order_filter[price]=1">
				<xsl:if test="$order_filter_name = '2'">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<xsl:text>&order-by-price;</xsl:text>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template name="default_layout_control">
		<div class="hidden">
			<div class="hidden-text default-layout-control">
				<xsl:choose>
					<xsl:when test="$infoPagePreferences/property[@name = 'catalog_default_layout']">
						<xsl:value-of select="$infoPagePreferences/property[@name = 'catalog_default_layout']/title" disable-output-escaping="yes" />
						<xsl:text>: </xsl:text>
						<xsl:apply-templates select="$infoPagePreferences/property[@name = 'catalog_default_layout']" mode="eip_props_table_value">
							<xsl:with-param name="id" select="$infoPageId" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&catalog_default_layout_title;: </xsl:text>
						<ul umi:element-id="{$infoPageId}" umi:field-name="catalog_default_layout" umi:field-type="relation" umi:empty="&empty-choose;">
							<li>&empty-choose;</li>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="cleaner" />
		</div>
	</xsl:template>
	
</xsl:stylesheet>