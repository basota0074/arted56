<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="udata[@method='insert_form']">
		<xsl:param name="class" select="'header_search_form'"/>
		<xsl:param name="button"/>
		<xsl:param name="value" select="''"/>
		<form action="/search/search_do/" method="get" class="search_form {$class}" >
			<fieldset>
				<input title="&search-title;" class="form_placeholder search_form_string" autocomplete="off" type="text" size="20" value="{$search_string}" name="search_string"/>
				<input class="submit_button {$button}" type="submit" value="{$value}" />
			</fieldset>
		</form>
	</xsl:template>
	
</xsl:stylesheet>