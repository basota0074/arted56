<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

    <xsl:template match="result[@method = 'search_do']">
		<xsl:apply-templates select="document('udata://search/search_do')" mode="search-do"/>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'search_do']" mode="search-do">
        <div class="text">
            <p>
                <strong>
                    <xsl:text>&search-founded-left;:&nbsp;"</xsl:text>
                    <xsl:value-of select="$search_string" />
                    <xsl:text>"&nbsp;-&nbsp;&search-founded-nothing;.</xsl:text>
                </strong>
            </p>
			<xsl:apply-templates select="document('udata://search/insert_form/')/udata">
				<xsl:with-param name="class" select="'page_search_form'"/>
				<xsl:with-param name="button" select="'all_system_buttons'"/>
				<xsl:with-param name="value" select="'&search-button;'"/>
			</xsl:apply-templates>
        </div>
	</xsl:template>
	
	<xsl:template match="udata[@method = 'search_do' and count(items/item)]" mode="search-do">
		<div class="text">
			<p>
				<strong>
					<xsl:text>&search-founded-left;&nbsp;"</xsl:text>
					<xsl:value-of select="$search_string" />
					<xsl:text>"&nbsp;&search-founded-right;:&nbsp;</xsl:text>
					<xsl:value-of select="total" />
					<xsl:text>.</xsl:text>
				</strong>
			</p>
			<xsl:apply-templates select="document('udata://search/insert_form/')/udata">
				<xsl:with-param name="class" select="'page_search_form'"/>
				<xsl:with-param name="button" select="'all_system_buttons'"/>
				<xsl:with-param name="value" select="'&search-button;'"/>
			</xsl:apply-templates>
			<div class="search">
				<xsl:apply-templates select="items/item" mode="search-result">
					<xsl:with-param name="per_page" select="per_page"/>
				</xsl:apply-templates>
			</div>
			<p>
				<strong>
					<xsl:text>&search-founded-total;:&nbsp;</xsl:text>
					<xsl:apply-templates select="total" />
				</strong>
			</p>
		</div>
		<xsl:apply-templates select="document(concat('udata://system/numpages/',total,'/',per_page))/udata"/>
	</xsl:template>
	
	<xsl:template match="item" mode="search-result">
		<xsl:param name="per_page"/>
		<div>
			<p>
				<strong class="serial"><xsl:value-of select="$p * $per_page + position()" />.&nbsp;</strong>
				<a href="{@link}" umi:element-id="{@id}" umi:field-name="name" umi:field-type="string">
					<xsl:value-of select="@name" />
				</a>
			</p>
			<p>
				<xsl:value-of select="." disable-output-escaping="yes" />
			</p>
		</div>
	</xsl:template>
    
</xsl:stylesheet>