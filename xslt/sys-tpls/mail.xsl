<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	
<xsl:output encoding="utf-8"
		method="xml"
		indent="no"
		undeclare-namespaces="yes"
		omit-xml-declaration="yes"/>

	<xsl:include href="emarket-mail.xsl" />
	
	<xsl:variable name="infoPageId" select="document('usel://getData/819')/udata/page/@id" />
	<xsl:variable name="infoPage" select="document(concat('upage://',$infoPageId))//group[@name = 'avtorskaya_informaciya']" />
	
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

	<xsl:template match="/">
		<xsl:apply-templates select="udata"/>
	</xsl:template>
	
</xsl:stylesheet>