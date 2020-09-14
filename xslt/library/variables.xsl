<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:variable name="templateVersion" select="102" />

	<xsl:variable name="result" select="/result" />
	<xsl:variable name="lang" select="/result/@lang" />
	<xsl:variable name="lang-prefix" select="/result/@pre-lang" />
	<xsl:variable name="pageId" select="/result/@pageId" />
	<xsl:variable name="module" select="/result/@module" />
	<xsl:variable name="method" select="/result/@method" />
	<xsl:variable name="parents" select="/result/parents" />
	<xsl:variable name="pageAltName" select="/result/page/@alt-name" />
	<xsl:variable name="requestUri" select="/result/@request-uri" />
	<xsl:variable name="errors" select="document('udata://system/listErrorMessages')/udata" />
	<xsl:variable name="userId" select="/result/user/@id" />
	<xsl:variable name="userType" select="/result/user/@type" />
	<xsl:variable name="infoPageId" select="document('upage://dlya_vstavki/')//page/@id" />
	<xsl:variable name="infoPage" select="document(concat('upage://',$infoPageId))//group[@name = 'avtorskaya_informaciya']" />
	<xsl:variable name="infoPageForm" select="document(concat('upage://',$infoPageId))//group[@name = 'order_form']" />
	<xsl:variable name="infoPagePreferences" select="document(concat('upage://',$infoPageId))//group[@name = 'site_preferences']" />
	<xsl:variable name="infoPageSocial" select="document(concat('upage://',$infoPageId))//group[@name = 'social_networks']" />
	<xsl:variable name="contactsPageTypeId" select="document('utype://webforms-page/')/udata/type/@id" />
	<xsl:variable name="infoPageContacts" select="document(concat('usel://getData/',$contactsPageTypeId))/udata/page/@id" />
	<xsl:variable name="infoPageCont" select="document(concat('upage://',$infoPageContacts))//group[@name = 'info']" />
	<xsl:variable name="albumPageTypeId" select="document('utype://photoalbum~album')/udata/type/@id" />
	<xsl:variable name="photoPageTypeId" select="document('utype://photoalbum~photo')/udata/type/@id" />
	<xsl:variable name="newsItemPageTypeId" select="document('utype://news~item')/udata/type/@id" />

	
	<xsl:variable name="fb_comments_width">
		<xsl:choose>
			<xsl:when test="$infoPageSocial/property[@name = 'fb_comments_width']/value"><xsl:value-of select="$infoPageSocial/property[@name = 'fb_comments_width']/value"/></xsl:when>
			<xsl:otherwise>470</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="fb_comments_per_page">
		<xsl:choose>
			<xsl:when test="$infoPageSocial/property[@name = 'fb_comments_per_page']/value"><xsl:value-of select="$infoPageSocial/property[@name = 'fb_comments_per_page']/value"/></xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="vk_comments_width">
		<xsl:choose>
			<xsl:when test="$infoPageSocial/property[@name = 'vk_comments_width']/value"><xsl:value-of select="$infoPageSocial/property[@name = 'vk_comments_width']/value"/></xsl:when>
			<xsl:otherwise>496</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="vk_comments_per_page">
		<xsl:choose>
			<xsl:when test="$infoPageSocial/property[@name = 'vk_comments_per_page']/value"><xsl:value-of select="$infoPageSocial/property[@name = 'vk_comments_per_page']/value"/></xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="comments_widget_amount">
		<xsl:choose>
			<xsl:when test="$infoPagePreferences/property[@name = 'comments_widget_amount']/value">
				<xsl:value-of select="$infoPagePreferences/property[@name = 'comments_widget_amount']/value"/>
			</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="comments_image_width">
		<xsl:choose>
			<xsl:when test="$infoPagePreferences/property[@name = 'comments_image_width']/value">
				<xsl:value-of select="$infoPagePreferences/property[@name = 'comments_image_width']/value"/>
			</xsl:when>
			<xsl:otherwise>100</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="comments_image_height">
		<xsl:choose>
			<xsl:when test="$infoPagePreferences/property[@name = 'comments_image_height']/value">
				<xsl:value-of select="$infoPagePreferences/property[@name = 'comments_image_height']/value"/>
			</xsl:when>
			<xsl:otherwise>100</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="showIndexPhotoalbum" select="$infoPagePreferences/property[@name = 'show_index_photoalbum']/value" />
	<xsl:variable name="showIndexNews" select="$infoPagePreferences/property[@name = 'show_index_news']/value" />
	<xsl:variable name="showIndexCatalog" select="$infoPagePreferences/property[@name = 'show_index_catalog']/value" />
	<xsl:variable name="catalogLayoutId" select="$infoPagePreferences/property[@name = 'catalog_default_layout']/value/item/@id" />

	<xsl:variable name="isAdmin">
		<xsl:choose>
			<xsl:when test="$userType = 'admin' or $userType = 'sv'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="rootPageId">
		<xsl:choose>
			<xsl:when test="count(/result/parents/page) != 0">
				<xsl:value-of select="/result/parents/page[1]/@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/result/@pageId"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:param name="p" select="'0'" />
	<xsl:param name="personal_office" select="'0'"/>
	<xsl:param name="catalog_per_page" select="'12'" />
	<xsl:param name="order_filter_name" select="'0'"/>
	<xsl:param name="search_string" />
	<xsl:param name="catalog_layout" select="number(concat('0',document(concat('uobject://', $catalogLayoutId))/udata/object/properties/group/property/value))" />
	<xsl:param name="_request_time" /> 
	<xsl:param name="_query_string" /> 
	<xsl:param name="_http_accept" /> 
	<xsl:param name="_http_accept_charset" /> 
	<xsl:param name="_http_accept_encoding" /> 
	<xsl:param name="_http_accept_language" /> 
	<xsl:param name="_http_host" /> 
	<xsl:param name="_http_referer" /> 
	<xsl:param name="_http_user_agent" />
	<xsl:param name="_remote_addr" /> 
	<xsl:param name="_remote_host" /> 
	<xsl:param name="_request_uri" />
	<xsl:param name="template-resources" />
</xsl:stylesheet>
