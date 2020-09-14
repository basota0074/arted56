<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="field">
		<div class="field field_{@name}">
			<xsl:apply-templates select="." mode="webforms_required" />
			<label>
				<span><xsl:value-of select="@title" /><xsl:text>:</xsl:text></span>
			</label>
			<xsl:apply-templates select="." mode="webforms_input_type" />
		</div>
	</xsl:template>

	<xsl:template match="field" mode="webforms_input_type">
		<div class="field_div input">
			<input type="text" name="{@input_name}" />
		</div>
	</xsl:template>

	<xsl:template match="field[@type = 'text']" mode="webforms_input_type">
		<div class="field_div textarea">
			<textarea name="{@input_name}"></textarea>
		</div>
	</xsl:template>

	<xsl:template match="field[@type = 'relation']" mode="webforms_input_type">
		<div class="field_div select">
			<select name="{@input_name}">
				<xsl:apply-templates select="." mode="webforms_multiple" />
				<option value=""></option>
				<xsl:apply-templates select="values/item" mode="webforms_input_type" />
			</select>
		</div>
	</xsl:template>

	<xsl:template match="item" mode="webforms_input_type">
		<option value="{@id}"><xsl:apply-templates /></option>
	</xsl:template>

	<xsl:template match="field" mode="webforms_required" />
	
	<xsl:template match="field[@required]" mode="webforms_required">
		<xsl:attribute name="class"><xsl:text>required field field_</xsl:text><xsl:value-of select="@name" /></xsl:attribute>
	</xsl:template>

	<xsl:template match="field" mode="webforms_multiple" />
	
	<xsl:template match="field[@multiple]" mode="webforms_multiple">
		<xsl:attribute name="multiple"><xsl:text>multiple</xsl:text></xsl:attribute>
	</xsl:template>

</xsl:stylesheet>