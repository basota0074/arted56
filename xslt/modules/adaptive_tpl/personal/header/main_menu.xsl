<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">


	<!--Основное меню-->
	<xsl:template match="udata[@module = 'content'][@method = 'menu']" mode="main_menu_p1">
		<xsl:param name="id" select="0"/>
		<ul class="level-0" umi:add-method="popup" umi:region="list" umi:sortable="sortable" umi:add-text="&add-text-menu;" umi:button-position="top right" umi:method="menu" umi:module="content" umi:element-id="{$id}" umi:empty="&empty;">
			<xsl:if test="count(items/item) = 0">
				<li class="hidden no-style">
					<div class="hidden-text">
						<p>&empty-menu;</p>
					</div>
				</li>
			</xsl:if>
			<xsl:apply-templates select="items/item" mode="main_menu_inn_p1"/>
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="main_menu_inn_p1">
		<li umi:element-id="{@id}" umi:region="row">
			<xsl:attribute name="class">
				<xsl:call-template name="list_class"/>
			</xsl:attribute>
			<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
				<xsl:if test="@link != '/'">
					<xsl:attribute name="umi:delete">delete</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</a>
		</li>
	</xsl:template>




</xsl:stylesheet>