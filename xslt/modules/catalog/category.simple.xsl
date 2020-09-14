<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
	<!--Простой каталог-->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']" mode="simple_catalog">
		<xsl:choose>
			<xsl:when test="$isAdmin = 0">
				<ul class="items_catalog">
					<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500/'))/udata" />
					<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12/'))/udata" />
				</ul>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<ul class="items_catalog" umi:element-id="{$pageId}" umi:region="list" umi:module="catalog" umi:sortable="sortable" umi:button-position="top right" umi:add-prepend="prepend">
					<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/', $pageId, '/100500///1/'))/udata" />
					<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12///1/'))/udata" />
					<xsl:choose>
						<xsl:when test="($getCategoryListFull/total != 0) and ($getObjectsListFull/total = 0)">
							<xsl:attribute name="umi:add-text">&add-text-catalog;</xsl:attribute>
						</xsl:when>
						<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total != 0)">
							<xsl:attribute name="umi:add-text">&add-text-catalog-object;</xsl:attribute>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not($getCategoryListFull/total) and ($getObjectsListFull/total = 0) and ($isAdmin = 1)">
						<xsl:attribute name="umi:sortable" select="'none'"/>
						<li class="hidden no-style">
							<div class="hidden-text">
								<p>&empty-catalog;</p>
							</div>
						</li>
					</xsl:if>
					<xsl:apply-templates select="$getCategoryListFull"/>
					<xsl:apply-templates select="$getObjectsListFull"/>
				</ul>
				<div class="catalog_numpages">
					<xsl:apply-templates select="document(concat('udata://system/numpages/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12///1/'))/udata/total,'/',document(concat('udata://catalog/getObjectsListFull/null/', $pageId, '/12///1/'))/udata/per_page,'/'))/udata" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>