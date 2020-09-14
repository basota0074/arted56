<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<!--Постраничная навигация-->
	<xsl:template match="udata[@module = 'system'][@method = 'numpages']" />
	
	<xsl:template match="udata[@module = 'system'][@method = 'numpages'][count(items/item) != 0]">
		<div class="numpages">
			<ul>
				<xsl:apply-templates select="toprev_link" />
				<xsl:apply-templates select="tobegin_link[../items/item[1] &gt; 1]" />
				<xsl:apply-templates select="items/item" mode="numpages" />
				<xsl:apply-templates select="toend_link[@page-num &gt; ../items/item[last()]/@page-num]" />
				<xsl:apply-templates select="tonext_link" />
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="toprev_link">
		<li class="numpages_li toprev_link">
			<a href="{.}" title="&previous-page;">
				<span>
					<xsl:text>&previous-page;</xsl:text>
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="tobegin_link">
		<li class="numpages_li tobegin_link">
			<a href="{.}">
				<span>
					<xsl:text>1</xsl:text>
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="tobegin_link[../items/item[1] != 2]">
		<li class="numpages_li tobegin_link">
			<a href="{.}">
				<span>
					<xsl:text>1</xsl:text>
				</span>
			</a>
		</li>
		<li class="numpages_li no_link">
			<span>
				<xsl:text>&#8230;</xsl:text>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="item" mode="numpages">
		<li class="numpages_li">
			<a href="{@link}">
				<span>
					<xsl:value-of select="." />
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="item[@is-active = '1']" mode="numpages">
		<li class="numpages_li active">
			<a href="{@link}">
				<span>
					<xsl:value-of select="." />
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="toend_link">
		<li class="numpages_li toend_link">
			<a href="{.}">
				<span>
					<xsl:value-of select="@page-num + 1" />
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="toend_link[@page-num &gt; ../items/item[last()]]">
		<li class="numpages_li no_link">
			<span>
				<xsl:text>&#8230;</xsl:text>
			</span>
		</li>
		<li class="numpages_li toend_link">
			<a href="{.}">
				<span>
					<xsl:value-of select="@page-num + 1" />
				</span>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="tonext_link">
		<li class="numpages_li tonext_link">
			<a href="{.}">
				<span>
					<xsl:text>&next-page;</xsl:text>
				</span>
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>