<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!--Каталог с зависимостью от типа данных, оформленный ввиде таблицы-->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="table_catalog">
		<xsl:variable name="current_perpage">
			<xsl:choose>
				<xsl:when test="$catalog_per_page = 12">20</xsl:when>
				<xsl:otherwise><xsl:value-of select="$catalog_per_page"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="document(concat('udata://catalog/isCategory/', $pageId))/udata/iscategory = 1">
				<xsl:apply-templates select="document(concat('udata://catalog/customSearch/', $pageId, '/(special)/'))/udata" />
				<xsl:variable name="getCategoryListFullTotal" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata/total" />
				<xsl:variable name="getObjectsListFullTotal" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$current_perpage,'///1/'))/udata/total" />
				<xsl:if test="($getCategoryListFullTotal != 0) or ($getObjectsListFullTotal != 0)">
					<div class="catalog_controls">
						<xsl:call-template name="perpage_control">
							<xsl:with-param name="current_perpage" select="$current_perpage" />
							<xsl:with-param name="perpage_level_1" select="20" />
							<xsl:with-param name="perpage_level_2" select="50" />
							<xsl:with-param name="perpage_level_3" select="100" />
							<xsl:with-param name="perpage_level_4" select="200" />
						</xsl:call-template>
						<div class="cleaner"/>
					</div>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not($getCategoryListFullTotal) and ($getObjectsListFullTotal = 0) and ($isAdmin = 1)">
						<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:button-position="top right" umi:add-prepend="prepend">
							<li class="hidden no-style">
								<div class="hidden-text">
									<p>&empty-catalog;</p>
								</div>
							</li>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="table_catalog_layout">
							<xsl:with-param name="current_perpage" select="$current_perpage" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdmin = 0">
						<ul class="items_catalog">
							<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" />
							<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$current_perpage,'/'))/udata" />
						</ul>
						<div class="catalog_numpages">
							<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/20/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/20/'))/udata/per_page,'/'))/udata" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="prepend">
							<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
							<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$current_perpage,'///1/'))/udata" />
						</ul>
						<div class="catalog_numpages">
							<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$current_perpage,'///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$current_perpage,'///1/'))/udata/per_page,'/'))/udata" />
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Таблица -->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="table_catalog_layout">
		<xsl:param name="current_perpage" select="$catalog_per_page" />
		<xsl:choose>
			<xsl:when test="$isAdmin = 0">
				<xsl:variable name="objectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/', $current_perpage, '/'))/udata" />
				<table class="table_catalog" >
					<thead>
						<xsl:apply-templates select="$objectsListFull/lines/item[1]" mode="table_catalog_layout_header" />
					</thead>
					<tbody>
						<xsl:apply-templates select="$objectsListFull" mode="table_catalog_layout" />
					</tbody>
				</table>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',$objectsListFull/total,'/',$objectsListFull/per_page,'/'))/udata" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="objectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/', $current_perpage, '///1/'))/udata" />
				<table class="table_catalog" >
					<thead>
						<xsl:apply-templates select="$objectsListFull/lines/item[1]" mode="table_catalog_layout_header" />
					</thead>
					<tbody umi:element-id="{$pageId}" umi:module="catalog" umi:region="list" umi:button-position="top right" umi:sortable="sortable" umi:add-prepend="prepend">
						<xsl:apply-templates select="$objectsListFull" mode="table_catalog_layout" />
					</tbody>
				</table>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',$objectsListFull/total,'/',$objectsListFull/per_page,'/'))/udata" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>