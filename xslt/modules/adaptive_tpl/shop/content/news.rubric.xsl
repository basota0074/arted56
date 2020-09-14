<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@module = 'news'][@method = 'rubric']">
		<xsl:apply-templates select="document(concat('udata://news/lastlist/',page/@id,'/'))/udata">
			<xsl:with-param name="id" select="page/@id" />
		</xsl:apply-templates>
	</xsl:template>



	<!--Новости на ГЛАВНОЙ странице-->
	<xsl:template match="udata" mode="news_index_s1"/>

	<xsl:template match="udata[total != 0]" mode="news_index_s1">
		<xsl:if test="$module != 'emarket'">
			<xsl:if test="$isAdmin = 1">
				<div class="hidden">
					<div class="hidden-text">
						<span>&show-index-news;:</span>&nbsp;
						<span umi:element-id="{$infoPageId}" umi:field-name="show_index_news">
							<xsl:choose>
								<xsl:when test="$infoPagePreferences/property[@name = 'show_index_news']/value = 1">&yes;</xsl:when>
								<xsl:otherwise>&no;</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="$infoPagePreferences/property[@name = 'show_index_news']/value = 1">

				<h5 class="shop-heading">
					<span class="h2_content" umi:element-id="{$infoPageId}" umi:field-name="mainpage_news_title" umi:field-type="string" umi:empty="&empty-news-title;">
						<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_news_title']"/>
					</span>
				</h5>

				<xsl:apply-templates select="document(concat('udata://news/lastlist/',page/@id,'//',$indexNews,'/1/'))/udata">
					<xsl:with-param name="id" select="page/@id"/>
					<xsl:with-param name="noPages" select="1"/>
				</xsl:apply-templates>
				<xsl:choose>
					<xsl:when test="(document(concat('udata://news/lastlist/',page/@id,'//',$indexNews,'/1/'))/udata/total &lt;= $indexNews) or not(document(concat('udata://news/lastlist/',page/@id,'//',$indexNews,'/1/'))/udata/total)">
					</xsl:when>
					<xsl:when test="$userType = 'guest'">
						<xsl:if test="$infoPage/property[@name = 'mainpage_news_show_all']/value">
							<div class="show_all show_all_news">
								<a href="{page/@link}" umi:field-name="mainpage_news_show_all" umi:empty="&empty-show-all;" umi:element-id="{$infoPageId}">
									<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_news_show_all']"/>
								</a>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<div class="show_all show_all_news">
							<xsl:if test="not($infoPage/property[@name = 'mainpage_news_show_all']/value)">
								<xsl:attribute name="class">show_all show_all_news hidden</xsl:attribute>
							</xsl:if>
							<a href="{page/@link}" umi:field-name="mainpage_news_show_all" umi:empty="&empty-show-all;" umi:element-id="{$infoPageId}">
								<xsl:apply-templates select="$infoPage/property[@name = 'mainpage_news_show_all']"/>
							</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:if>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>