<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
<xsl:output encoding="utf-8"
		method="xml"
		indent="no"
		undeclare-namespaces="yes"
		omit-xml-declaration="yes"/>

	<xsl:include href="ajax-templates.xsl" />
	<xsl:variable name="infoPageId" select="document('upage://dlya_vstavki/')//page/@id" />

	<xsl:variable name="infoPageForm" select="document(concat('upage://',$infoPageId))//group[@name = 'order_form']" />
	<xsl:variable name="userType" select="/result/user/@type" />
	
	<xsl:param name="admin" />
	<xsl:param name="ajax" />
	<xsl:param name="domain" />

	<xsl:template match="/">
		<xsl:if test="$ajax = 'ajax-order-form'">
			<xsl:apply-templates select="." mode="ajax-order-form"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>