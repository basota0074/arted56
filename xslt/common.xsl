<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

<xsl:output encoding="utf-8"
			indent="no"
			method="xml"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
            undeclare-namespaces="yes"
            omit-xml-declaration="yes"/>

	<xsl:include href="library/__common.xsl" />

    <xsl:include href="modules/blogs20/__common.xsl" />
    <xsl:include href="modules/catalog/__common.xsl" />
    <xsl:include href="modules/comments/__common.xsl" />
    <xsl:include href="modules/content/__common.xsl" />
    <xsl:include href="modules/emarket/__common.xsl" />
    <xsl:include href="modules/news/__common.xsl" />
    <xsl:include href="modules/photoalbum/__common.xsl" />
    <xsl:include href="modules/users/__common.xsl" />
    <xsl:include href="modules/search/__common.xsl" />
    <xsl:include href="modules/webforms/__common.xsl" />
    <xsl:include href="modules/filemanager/__common.xsl" />
    <xsl:include href="modules/data/__common.xsl" />
	
	<xsl:include href="layouts/default.xsl" />

</xsl:stylesheet>
