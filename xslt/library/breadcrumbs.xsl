<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">
		
	<!--Хлебные крошки-->
	<xsl:template match="result" mode="breadcrumb"/>   
		
	<xsl:template match="result[not(page/@is-default)]" mode="breadcrumb">
		<div class="breadcrumbs">
			<ul>
				<li class="breadcrumbs_home">
					<a href="/">
						<div umi:element-id="{$infoPageId}" umi:field-name="breadcrumbs_index" umi:field-type="string" umi:empty="&empty-content;">
							<xsl:apply-templates select="$infoPage/property[@name = 'breadcrumbs_index']" />
						</div>
					</a>
					<span class="breadcrumb_separator"><span class="separator_text">&breadcrumb-separator;</span></span>
				</li>
				<xsl:apply-templates select="parents/page" mode="breadcrumbs"/>
				<li class="breadcrumbs_last">
					<a>
						<div>
							<xsl:choose>
								<xsl:when test="not(page/name)">
									<xsl:value-of select="@header" disable-output-escaping="yes"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="page/name" disable-output-escaping="yes"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</a>
					<span class="breadcrumb_separator"><span class="separator_text">&breadcrumb-separator;</span></span>
				</li>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="page" mode="breadcrumbs">
		<li>
			<a href="{@link}" title="{name}">
				<div><xsl:value-of select="name" disable-output-escaping="yes"/></div>
			</a>
			<span class="breadcrumb_separator"><span class="separator_text">&breadcrumb-separator;</span></span>
		</li>
	</xsl:template>
	
	<xsl:template match="page[@link = '/']" mode="breadcrumbs"/>

</xsl:stylesheet>