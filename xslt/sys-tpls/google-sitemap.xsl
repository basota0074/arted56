<?xml version="1.0" encoding="UTF-8"?>
 
<xsl:stylesheet	version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    
    <xsl:output encoding="utf-8" method="xml" indent="yes"/>
	
	<xsl:param name="domain" />
 
	<xsl:template match="/">
		<urlset>
			<xsl:apply-templates select="//page"/>
		</urlset>
	</xsl:template>
 
	<xsl:template match="page">
		<url>
			<loc>
				<xsl:value-of select="concat('http://', $domain, link)" />
			</loc>
			<lastmod>
				<xsl:value-of select="update_time" />
			</lastmod>
		</url>
	</xsl:template>
 
</xsl:stylesheet>