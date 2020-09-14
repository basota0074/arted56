<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Обертка списка новостей-->
	<xsl:template match="udata[@module = 'news'][@method = 'lastlist']">
		<xsl:param name="id" select="category_id"/>
		<xsl:param name="noPages" select="0"/>
		<div class="news" umi:element-id="{$id}" umi:add-text="&add-text-news;" umi:module="news" umi:method="lastlist" umi:region="list" umi:type-id="{$newsItemPageTypeId}" umi:button-position="top right">
			<xsl:if test="(count(items/item) = 0) and ($isAdmin = 1)">
				<xsl:attribute name="umi:sortable" select="'none'"/>
				<div class="hidden no-style">
					<div class="hidden-text">
						<p>&empty-news;</p>
					</div>
				</div>
				<div class="news_item blank_item" umi:region="row" umi:element-id="void" umi:delete="delete">
					<div class="news_title" >
						<div class="top_date news_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" />
						<a class="news_headline" href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;"/>
						<div class="bottom_date news_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" />
					</div>
					<div class="news_anons text" umi:field-name="anons" umi:field-type="wysiwyg" umi:empty="&empty-page-anons;"/>
				</div>
			</xsl:if>
			<xsl:apply-templates select="items/item" />
		</div>
		<xsl:if test="not($noPages)">
			<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page,'/'))/udata" />
		</xsl:if>
	</xsl:template>
	
	<!--Эллемент списка новостей-->
	<xsl:template match="udata[@method = 'lastlist']/items/item">
		<xsl:variable name="item" select="document(concat('upage://', @id))/udata" />
		<xsl:variable name="publish_time">
			<xsl:apply-templates select="@publish_time">
				<xsl:with-param name="date_format" select="$newsDateFormat" />
			</xsl:apply-templates>
		</xsl:variable>
		<div class="news_item" umi:region="row" umi:element-id="{@id}" umi:delete-text="&delete-text-news;" umi:delete="delete">
			<div class="news_title" >
				<div class="top_date news_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" >
					<xsl:value-of select="$publish_time" disable-output-escaping="yes" />
				</div>
				<a class="news_headline" href="{@link}" umi:field-name="name" umi:field-type="string" umi:empty="&empty-page-name;" umi:url-attribute="href">
					<xsl:value-of select="." disable-output-escaping="yes" />
				</a>
				<div class="bottom_date news_date" umi:field-name="publish_time" umi:field-type="date" umi:empty="&empty-page-date;" >
					<xsl:value-of select="$publish_time" disable-output-escaping="yes" />
				</div>
			</div>
			<div id="anons_{@id}_{generate-id()}" class="news_anons text" umi:field-name="anons" umi:field-type="wysiwyg" umi:empty="&empty-page-anons;">
				<xsl:value-of select="$item//property[@name = 'anons']/value" disable-output-escaping="yes" />
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>