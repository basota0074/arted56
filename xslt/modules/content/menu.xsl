<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Основное меню-->
	<xsl:template match="udata[@module = 'content'][@method = 'menu']" mode="main_menu">
		<xsl:param name="id" select="0" />
		<ul umi:add-method="popup" umi:region="list" umi:sortable="sortable" umi:add-text="&add-text-menu;" umi:button-position="top right" umi:method="menu" umi:module="content" umi:element-id="{$id}" umi:empty="&empty;">
			<xsl:if test="count(items/item) = 0">
				<li class="hidden no-style">
					<div class="hidden-text">
						<p>&empty-menu;</p>
					</div>
				</li>
			</xsl:if>
			<xsl:apply-templates select="items/item" mode="main_menu"/>
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="main_menu">
		<li umi:element-id="{@id}" umi:region="row">
			<xsl:attribute name="class">
				<xsl:call-template name="list_class" />
			</xsl:attribute>
			<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
				<xsl:if test="@link != '/'">
					<xsl:attribute name="umi:delete">delete</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="." disable-output-escaping="yes" />
			</a>
		</li>
	</xsl:template>
	
	<!--Дополнительное меню-->
	<xsl:template match="udata[@module = 'content'][@method = 'menu']" mode="additional_menu">
		<xsl:param name="id" select="0" />
		<ul umi:element-id="{$id}" umi:add-method="popup" umi:region="list" umi:sortable="sortable" umi:add-text="&add-text-menu;" umi:button-position="top right" umi:method="menu" umi:module="content" >
			<xsl:apply-templates select="items/item" mode="additional_menu"/>
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="additional_menu">
		<li umi:element-id="{@id}" umi:region="row">
			<xsl:if test="position() = last()">
				<xsl:attribute name="class">last</xsl:attribute>
			</xsl:if>
			<xsl:if test="@status">
				<xsl:attribute name="class">current</xsl:attribute>
			</xsl:if>
			<xsl:if test="position() = last() and @status">
				<xsl:attribute name="class">current last</xsl:attribute>
			</xsl:if>
			<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
				<xsl:if test="@link != '/'">
					<xsl:attribute name="umi:delete">delete</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="." disable-output-escaping="yes" />
			</a>
		</li>
	</xsl:template>
	
	<!--Меню многоуровневой вложенности-->
	<xsl:template match="udata[@module = 'content'][@method = 'menu']" mode="multilevel_menu">
		<xsl:param name="id" select="0" />
		<xsl:apply-templates select="items" mode="multilevel_menu">
			<xsl:with-param name="id" select="$id" />
			<xsl:with-param name="level" select="0" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="items" mode="multilevel_menu">
		<xsl:param name="id" />
		<xsl:param name="level" />
		<ul class="level-{$level}" umi:element-id="{$id}" umi:add-text="&add-text-menu;" umi:add-method="popup" umi:region="list" umi:sortable="sortable" umi:button-position="top right" umi:method="menu" umi:module="content" >
			<xsl:apply-templates select="item" mode="multilevel_menu">
				<xsl:with-param name="level" select="$level + 1" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>

	<xsl:template match="item" mode="multilevel_menu">
		<xsl:param name="level" />
		<li umi:element-id="{@id}" umi:region="row">
			<xsl:attribute name="class">
				<xsl:call-template name="list_class" />
			</xsl:attribute>
			<a href="{@link}" umi:element-id="{@id}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-name;" umi:url-attribute="href">
				<xsl:if test="@link != '/'">
					<xsl:attribute name="umi:delete">delete</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name" disable-output-escaping="yes" />
			</a>
			<xsl:apply-templates select="items" mode="multilevel_menu">
				<xsl:with-param name="id" select="@id" />
				<xsl:with-param name="level" select="$level" />
			</xsl:apply-templates>
		</li>
	</xsl:template>
	
	<!--Основное меню таблицей-->
	<xsl:template match="udata[@module = 'content'][@method = 'menu']" mode="table_main_menu">
		<xsl:param name="id" select="0" />
		<table class="table_menu">
			<tr class="tr_menu" umi:add-text="&add-text-menu;" umi:button-position="top right" umi:add-method="popup" umi:region="list" umi:sortable="sortable" umi:method="menu" umi:module="content" umi:element-id="{$id}" >
				<xsl:apply-templates select="items/item" mode="table_main_menu"/>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="udata[@module = 'content' and @method = 'menu']/items/item" mode="table_main_menu">
		<td umi:element-id="{@id}" umi:region="row">
			<xsl:attribute name="class">
				<xsl:call-template name="list_class" />
			</xsl:attribute>
			<a href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-section-name;" umi:url-attribute="href">
				<xsl:if test="@link != '/'">
					<xsl:attribute name="umi:delete">delete</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="." disable-output-escaping="yes" />
			</a>
		</td>
	</xsl:template>
	
	<!--Элемент списка для вывода каталога в левом меню-->
	<xsl:template match="item" mode="main_list">
		<li umi:region="row" umi:element-id="{@id}" >
			<xsl:if test="position() = last()">
				<xsl:attribute name="class">last</xsl:attribute>
			</xsl:if>
			<xsl:if test="$pageId = @id">
				<xsl:attribute name="class">current</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$parents/page" mode="main_list_current">
				<xsl:with-param name="id" select="@id" />
				<xsl:with-param name="last" select="position() = last()" />
			</xsl:apply-templates>
			<xsl:if test="position() = last() and $pageId = @id">
				<xsl:attribute name="class">current last</xsl:attribute>
			</xsl:if>
			<a class="main_list_title" href="{@link}" umi:field-name="name" umi:field-type="string" umi:delete="delete" umi:empty="&empty-section-name;"  umi:url-attribute="href">
				<xsl:value-of select="." disable-output-escaping="yes" />
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="page" mode="main_list_current">
		<xsl:param name="id" />
		<xsl:param name="last"/>
		<xsl:if test="$id = @id">
			<xsl:attribute name="class">current<xsl:if test="$last"> last</xsl:if></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!--Элемент списка для вывода каталога ввиде текста-->
	<xsl:template match="item" mode="text_catalog_list">
		<li umi:region="row" umi:element-id="{@id}" >
			<xsl:if test="position() = last()">
				<xsl:attribute name="class">last</xsl:attribute>
			</xsl:if>
			<a class="text_catalog_list_title" href="{@link}" umi:field-name="name" umi:field-type="string" umi:delete="delete" umi:empty="&empty-section-name;" >
				<xsl:value-of select="." disable-output-escaping="yes" />
			</a>
		</li>
	</xsl:template>
	
	<!--Подменю с заголовком-->
	<xsl:template name="multilevel_submenu">
		<xsl:param name="id" select="$rootPageId" />
		<xsl:param name="level" select="2"/>
		<xsl:param name="show_title" select="1" />
		<xsl:variable name="menu" select="document(concat('udata://content/menu//',$level,'/',$rootPageId,'/'))/udata" />
		<xsl:if test="count($menu/items/item) != 0">
			<div class="multilevel_submenu">
				<xsl:if test="$show_title = 1">
					<div class="multilevel_submenu_title h1" umi:field-name="custom_field_title" umi:field-type="string" umi:empty="&empty;" umi:element-id="{$infoPageId}">
						<xsl:apply-templates select="$infoPage/property[@name = 'custom_field_title']" />
					</div>
				</xsl:if>
				<xsl:apply-templates select="$menu" mode="multilevel_menu">
					<xsl:with-param name="id" select="$id" />
				</xsl:apply-templates>					
			</div>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>