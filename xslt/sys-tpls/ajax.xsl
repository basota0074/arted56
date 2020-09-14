<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
	
<xsl:output encoding="utf-8"
		method="xml"
		indent="no"
		undeclare-namespaces="yes"
		omit-xml-declaration="yes"/>

	<xsl:include href="../library/variables.xsl" />
	<xsl:include href="../library/system.xsl" />
	<xsl:include href="../modules/users/login.ajax.xsl" />
	<xsl:include href="../modules/emarket/cart.ajax.xsl" />
	<xsl:include href="../modules/catalog/optProps.ajax.xsl" />
	<xsl:include href="ajax-templates.xsl" />
	
	<xsl:variable name="ajaxUserInfo" select="document('udata://users/user_type/')/udata"/>
	<xsl:variable name="ajaxUserType" select="$ajaxUserInfo/type"/>
	<xsl:variable name="ajaxIsAdmin" select="$ajaxUserInfo/admin"/>
	
	<xsl:param name="ajax" />
	<xsl:param name="domain" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$ajax = 'ajax-order-form'">
				<xsl:apply-templates select="." mode="ajax-order-form"/>
			</xsl:when>
			<xsl:when test="$ajax = 'ajax-login'">
				<xsl:call-template name="ajax-login"/>
			</xsl:when>
			<xsl:when test="$ajax = 'ajax-cart'">
				<xsl:apply-templates select="document('udata://emarket/cart/')/udata/summary" mode="ajax-cart"/>
			</xsl:when>
			<xsl:when test="$ajax = 'ajax-optioned'">
				<xsl:apply-templates select="." mode="ajax-optioned"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="ajax"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="/" mode="ajax"/>
	
</xsl:stylesheet>
