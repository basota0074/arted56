<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!--Расширенный каталог-->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="emarket_catalog">
		<xsl:apply-templates select="document(concat('udata://catalog/customSearch/', $pageId, '/(special)/'))/udata" />
		<xsl:choose>
			<xsl:when test="document(concat('udata://catalog/isCategory/', $pageId))/udata/iscategory = 1">
				<xsl:variable name="getCategoryListFullTotal" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata/total" />
				<xsl:variable name="getObjectsListFullTotal" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/total" />
				<xsl:if test="($getCategoryListFullTotal != 0) or ($getObjectsListFullTotal != 0)">
					<div class="catalog_controls">
						<xsl:if test="$isAdmin = 1">
							<xsl:call-template name="default_layout_control" />
						</xsl:if>
						<xsl:call-template name="order_control" />
						<xsl:call-template name="perpage_control" />
						<xsl:call-template name="layoutcontrol" />
						<div class="cleaner"/>
					</div>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not($getCategoryListFullTotal) and ($getObjectsListFullTotal = 0) and ($isAdmin = 1)">
						<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:button-position="top right" umi:add-prepend="prepend" umi:add-reboot="true">
							<li class="hidden no-style">
								<div class="hidden-text">
									<p>&empty-catalog;</p>
								</div>
							</li>
						</ul>
					</xsl:when>
					<xsl:when test="$catalog_layout = 0"><xsl:apply-templates select="." mode="layout_0" /></xsl:when>
					<xsl:when test="$catalog_layout = 1"><xsl:apply-templates select="." mode="layout_1" /></xsl:when>
					<xsl:when test="$catalog_layout = 2"><xsl:apply-templates select="." mode="layout_2" /></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdmin = 0">
						<ul class="items_catalog">
							<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" />
							<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata" />
						</ul>
						<div class="catalog_numpages">
							<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12/'))/udata/per_page,'/'))/udata" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
						<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata" />
						<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="prepend">
							<xsl:choose>
								<xsl:when test="($getCategoryListFull/total != 0) and ($getObjectsListFull/total = 0)">
									<xsl:attribute name="umi:add-text">&add-text-catalog;</xsl:attribute>
								</xsl:when>
								<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total != 0)">
									<xsl:attribute name="umi:add-text">&add-text-catalog-object;</xsl:attribute>
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="$getCategoryListFull" />
							<xsl:apply-templates select="$getObjectsListFull" />
						</ul>
						<div class="catalog_numpages">
							<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/per_page,'/'))/udata" />
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Плитка -->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="layout_0">
		<xsl:choose>
			<xsl:when test="$isAdmin = 0">
				<ul class="items_catalog">
					<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" />
					<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata" />
				</ul>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
				<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata" />		
				<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="prepend">
					<xsl:choose>
						<xsl:when test="($getCategoryListFull/total != 0) and ($getObjectsListFull/total = 0)">
							<xsl:attribute name="umi:add-text">&add-text-catalog;</xsl:attribute>
						</xsl:when>
						<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total != 0)">
							<xsl:attribute name="umi:add-text">&add-text-catalog-object;</xsl:attribute>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="$getCategoryListFull" />
					<xsl:apply-templates select="$getObjectsListFull" />
				</ul>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Таблица -->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="layout_1">
		<table class="emarket_table_catalog" >
			<tbody umi:element-id="{$pageId}" umi:module="catalog" umi:region="list" umi:button-position="top right" umi:sortable="sortable" umi:add-prepend="prepend">
				<xsl:choose>
					<xsl:when test="$isAdmin = 0">
						<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" mode="layout_1" />
						<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/', $catalog_per_page, '/'))/udata" mode="layout_1" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
						<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata" />		
						<xsl:choose>
							<xsl:when test="($getCategoryListFull/total != 0) and ($getObjectsListFull/total = 0)">
								<xsl:attribute name="umi:add-text">&add-text-catalog;</xsl:attribute>
							</xsl:when>
							<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total != 0)">
								<xsl:attribute name="umi:add-text">&add-text-catalog-object;</xsl:attribute>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="$getCategoryListFull" mode="layout_1" />
						<xsl:apply-templates select="$getObjectsListFull" mode="layout_1" />
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
		<xsl:choose>
			<xsl:when test="$isAdmin = 0">
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Список -->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="layout_2">
		<table class="list_table_catalog">
			<tbody umi:element-id="{$pageId}" umi:module="catalog" umi:region="list" umi:button-position="top right" umi:sortable="sortable" umi:add-prepend="prepend">
				<xsl:choose>
					<xsl:when test="$isAdmin = 0">
						<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" mode="layout_2" />
						<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/', $catalog_per_page, '/'))/udata" mode="layout_2" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
						<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata" />		
						<xsl:choose>
							<xsl:when test="($getCategoryListFull/total != 0) and ($getObjectsListFull/total = 0)">
								<xsl:attribute name="umi:add-text">&add-text-catalog;</xsl:attribute>
							</xsl:when>
							<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total != 0)">
								<xsl:attribute name="umi:add-text">&add-text-catalog-object;</xsl:attribute>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="$getCategoryListFull" mode="layout_2" />
						<xsl:apply-templates select="$getObjectsListFull" mode="layout_2" />
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
		<xsl:choose>
			<xsl:when test="$isAdmin = 0">
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/',$catalog_per_page,'///1/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>