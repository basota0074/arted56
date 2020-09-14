<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Каталог товаров и услуг-->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="content_s1">
		<div id="descr_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="descr" umi:field-type="wysiwyg" umi:empty="&empty-page-content;">
			<xsl:apply-templates select="//property[@name = 'descr']"/>
		</div>

		<!--Файлы для скачивания у раздела каталога-->
		<xsl:apply-templates select="document(concat('udata://filemanager/list_files/',$pageId,'//1000/1/'))/udata"/>
		<!--Конец-->

		<xsl:choose>
			<xsl:when test="$сatalog = 3">
				<xsl:apply-templates select="." mode="table_catalog"/>
			</xsl:when>
			<xsl:when test="$сatalog = 2">
				<xsl:apply-templates select="." mode="text_catalog"/>
			</xsl:when>
			<xsl:when test="$сatalog = 1">
				<xsl:apply-templates select="." mode="emarket_catalog_s1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="simple_catalog"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>