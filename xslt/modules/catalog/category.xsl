<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Каталог товаров и услуг-->
	<xsl:template match="result[@module = 'catalog'][@method = 'category']">
		<div id="descr_{$pageId}_{generate-id()}" class="text" umi:element-id="{$pageId}" umi:field-name="descr" umi:field-type="wysiwyg" umi:empty="&empty-page-content;">
			<xsl:apply-templates select="//property[@name = 'descr']" />
		</div>
		
		<!--Файлы для скачивания у раздела каталога-->
		<xsl:apply-templates select="document(concat('udata://filemanager/list_files/',$pageId,'//1000/1/'))/udata" />
		<!--Конец-->
		
		<xsl:choose>
			<xsl:when test="$сatalog = 3">
				<xsl:apply-templates select="." mode="table_catalog"/>
			</xsl:when>
			<xsl:when test="$сatalog = 2">
				<xsl:apply-templates select="." mode="text_catalog"/>
			</xsl:when>
			<xsl:when test="$сatalog = 1">
				<xsl:apply-templates select="." mode="emarket_catalog"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="simple_catalog"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Каталог на главной странице-->
	<xsl:template match="udata" mode="catalog_index"/>
	<xsl:template match="udata" mode="only_catalog_index"/>
	<xsl:template match="udata" mode="only_special_offers_index"/>
	
	<xsl:template match="udata[total != 0]" mode="catalog_index">
		<xsl:call-template name="catalog_index" />
		<xsl:call-template name="special_offers_index" />
	</xsl:template>
	
	<xsl:template match="udata[total != 0]" mode="only_catalog_index">
		<xsl:call-template name="catalog_index" />
	</xsl:template>
	
	<xsl:template match="udata[total != 0]" mode="only_special_offers_index">
		<xsl:call-template name="special_offers_index" />
	</xsl:template>
	
	<xsl:template name="catalog_index">
		<xsl:if test="$isAdmin = 1">
			<div class="hidden hidden-text">
				<span>&nbsp;&nbsp;&nbsp;&nbsp;
					<span>&show-index-catalog;:</span>&nbsp;
					<span umi:element-id="{$infoPageId}" umi:field-name="show_index_catalog" umi:field-type="boolean">
						<xsl:choose>
							<xsl:when test="$infoPagePreferences/property[@name = 'show_index_catalog']/value = 1">&yes;</xsl:when>
							<xsl:otherwise>&no;</xsl:otherwise>
						</xsl:choose>
					</span>
				</span>
			</div>
        </xsl:if>
		<xsl:if test="$infoPagePreferences/property[@name = 'show_index_catalog']/value = 1">
			<div class="mainpage_catalog_title h2">
				<span class="h2_content" umi:element-id="{$infoPageId}" umi:field-name="mainpage_catalog_title" umi:field-type="string" umi:empty="&empty-catalog-title;" >
					<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_catalog_title']" />
				</span>
			</div>
			<div class="index_catalog">
				<xsl:choose>
					<xsl:when test="$isAdmin = 0">
						<ul class="items_catalog mainpage_items_catalog">
							<xsl:apply-templates select="document(concat('udata://catalog/getCategoryListFull/null/',page/@id,'/',$indexСatalog,'/1/'))/udata" />
							<xsl:apply-templates select="document(concat('udata://catalog/getObjectsListFull/null/',page/@id,'/',$indexСatalog,'/1/'))/udata" />
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="getCategoryListFull" select="document(concat('udata://catalog/getCategoryListFull/null/',page/@id,'/',$indexСatalog,'/1//1/'))/udata" />
						<xsl:variable name="getObjectsListFull" select="document(concat('udata://catalog/getObjectsListFull/null/',page/@id,'/',$indexСatalog,'/1//1/'))/udata" />
						<xsl:choose>
							<xsl:when test="not($getCategoryListFull/total) and ($getObjectsListFull/total = 0)">
								<ul class="items_catalog mainpage_items_catalog" umi:element-id="{page/@id}" umi:module="catalog" umi:button-position="top right" umi:sortable="sortable" umi:add-prepend="prepend">
									<li class="hidden no-style">
										<div class="hidden-text">
											<p>&empty-catalog;</p>
										</div>
									</li>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<ul class="items_catalog mainpage_items_catalog" umi:element-id="{page/@id}" umi:module="catalog" umi:region="list" umi:button-position="top right" umi:sortable="sortable" umi:add-prepend="prepend">
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
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="getObjectsListFullTotal" select="document(concat('udata://catalog/getObjectsListFull/null/',page/@id,'/',$indexСatalog,'/1/'))/udata/total" />
				<xsl:variable name="getCategoryListFullTotal" select="document(concat('udata://catalog/getCategoryListFull/null/',page/@id,'/',$indexСatalog,'/1/'))/udata/total" />
				<xsl:choose>
					<xsl:when test="(($getObjectsListFullTotal &lt;= $indexСatalog) or not($getObjectsListFullTotal))and(($getCategoryListFullTotal &lt;= $indexСatalog) or not($getCategoryListFullTotal))" />
					<xsl:when test="$isAdmin = 0">
						<xsl:if test="$infoPage/property[@name = 'mainpage_catalog_show_all']/value">
							<div class="show_all show_all_catalog" >
								<a href="{page/@link}" umi:field-name="mainpage_catalog_show_all" umi:field-type="string" umi:empty="&empty-show-all;"  umi:element-id="{$infoPageId}">
									<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_catalog_show_all']" />
								</a>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<div class="show_all show_all_catalog" >
							<xsl:if test="not($infoPage/property[@name = 'mainpage_catalog_show_all']/value)">
								<xsl:attribute name="class">show_all show_all_catalog hidden</xsl:attribute>
							</xsl:if>
							<a href="{page/@link}" umi:field-name="mainpage_catalog_show_all" umi:field-type="string" umi:empty="&empty-show-all;"  umi:element-id="{$infoPageId}">
								<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_catalog_show_all']" />
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="special_offers_index">
		<xsl:variable name="max_special_offers" select="$infoPagePreferences/property[@name = 'index_max_special_offers']" />
		<xsl:if test="$isAdmin = 1">
			<div class="hidden hidden-text">
				<span>
					<span>&show-special-offers;:</span>&nbsp;
					<span umi:element-id="{$infoPageId}" umi:field-name="index_catalog_show_special_offer" umi:field-type="boolean">
						<xsl:choose>
							<xsl:when test="$infoPagePreferences/property[@name = 'index_catalog_show_special_offer']/value = 1">&yes;</xsl:when>
							<xsl:otherwise>&no;</xsl:otherwise>
						</xsl:choose>
					</span>
				</span>
			</div>
        </xsl:if>
		<xsl:if test="$infoPagePreferences/property[@name = 'index_catalog_show_special_offer']/value = 1">
			<xsl:variable name="special_offers" select="document(concat('udata://catalog/getSpecialOffers/?limit=', $max_special_offers/value))/udata" />
			<xsl:if test="$special_offers/total &gt; 0">
				<div class="index_catalog index_special_offers">
					<div class="decoration_1" />
					<div class="mainpage_special_offers_title h2">
						<span class="h2_content" umi:element-id="{$infoPageId}" umi:empty="&empty-special-offers;" umi:field-name="mainpage_special_offers_title" umi:field-type="string">
							<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_special_offers_title']" />
						</span>
					</div>
					<ul class="special_offers_list items_catalog">
						<xsl:apply-templates select="$special_offers" mode="special_offers"/>
					</ul>
					<div class="decoration_2" />
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>