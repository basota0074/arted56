<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="field">
		<div class="field field_{@name}">
			<xsl:apply-templates select="." mode="webforms_required" />
			<label>
				<span><xsl:value-of select="@title" /><xsl:text>:</xsl:text></span>
				<xsl:apply-templates select="." mode="webforms_required_star" />
			</label>
			<xsl:apply-templates select="." mode="webforms_input_type" />
			<div class="webforms_error_text">
				&webforms-error-text;
			</div>
			<xsl:if test="@name = 'email'">
				<div class="email_error_text">
					&email-error-text;
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="field" mode="webforms_input_type">
		<div class="field_div input">
			<input type="text" name="{@input_name}" value="{.}"/>
		</div>
	</xsl:template>

	<xsl:template match="field[@type = 'text']" mode="webforms_input_type">
		<div class="field_div textarea">
			<textarea name="{@input_name}"><xsl:value-of select="."/></textarea>
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
	
	<xsl:template match="field" mode="webforms_required_star" />
	
	<xsl:template match="field[@required]" mode="webforms_required_star">
		<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
	</xsl:template>

	<xsl:template match="field" mode="webforms_multiple" />
	
	<xsl:template match="field[@multiple]" mode="webforms_multiple">
		<xsl:attribute name="multiple"><xsl:text>multiple</xsl:text></xsl:attribute>
	</xsl:template>
		
	<!--Для формы заказа-->
	<xsl:template match="field" mode="purchase">
		<div class="field field_{@name}">
			<xsl:apply-templates select="." mode="webforms_required" />
			<label>
				<span><xsl:value-of select="@title" /><xsl:text>:</xsl:text></span>
				<xsl:apply-templates select="." mode="webforms_required_star" />
			</label>
			<xsl:choose>
				<xsl:when test="$userType = 'guest'">
					<xsl:apply-templates select="." mode="webforms_input_type" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="purchase_webforms_input_type" >
						<xsl:with-param name="user" select="document(concat('uobject://',$userId))/udata" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			<div class="webforms_error_text">
				&webforms-error-text;
			</div>
			<xsl:if test="@name = 'email'">
				<div class="email_error_text">
					&email-error-text;
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="field[@type = 'text']" mode="purchase_webforms_input_type">
		<xsl:param name="user" />
		<xsl:variable name="field_name" select="substring(@name,6)" />
		<div class="field_div textarea">
			<textarea name="{@input_name}"><xsl:value-of select="$user//property[@name = $field_name]/value"/></textarea>
		</div>
	</xsl:template>
	
	<xsl:template match="field" mode="purchase_webforms_input_type">
		<xsl:param name="user" />
		<xsl:variable name="field_name" select="substring(@name,6)" />
		<div class="field_div input">
			<input type="text" name="{@input_name}" value="{$user//property[@name = $field_name]/value}"/>
		</div>
	</xsl:template>

	<xsl:template match="field[@name = 'cust_email']" mode="purchase_webforms_input_type">
		<xsl:param name="user" />
		<div class="field_div input">
			<input type="text" name="{@input_name}" value="{$user//property[@name = 'e-mail']/value}"/>
		</div>
	</xsl:template>


</xsl:stylesheet>