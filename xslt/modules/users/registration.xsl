<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://i18n/constants.dtd:file">

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:umi="http://www.umi-cms.ru/TR/umi">

	<xsl:template match="result[@module='users'][@method = 'registrate']">
		<xsl:apply-templates select="document('udata://users/registrate')/udata" />
	</xsl:template>
	
	<xsl:template match="udata[@method = 'registrate']">
		<form class="site_form" method="post" action="/users/custom_registrate_do/">
			<fieldset>
				<div class="field field_email required">
					<label>
						<span>&e-mail;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="text" name="email"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
					<div class="email_error_text">
						&email-error-text;
					</div>
				</div>
                <div class="field password required">
					<label>
						<span>&password;:</span>
						<span class="required_star" title="&required-text;" ><span class="required_star_text">*</span></span>
					</label>
					<div class="field_div input">
						<input type="text" name="password"/>
					</div>
					<div class="webforms_error_text">
						&webforms-error-text;
					</div>
				</div>
			</fieldset>
			<xsl:apply-templates select="document(concat('udata://data/getCreateForm/',type_id,'/'))/udata" />
			<xsl:apply-templates select="document('udata://system/captcha')/udata" />
			<xsl:call-template name="personal_data_notice" />
			<fieldset>
                <div class="submit">
                    <input type="submit" class="all_system_buttons" value="&registration-do;" />
                </div>
            </fieldset>
		</form>
	</xsl:template>

	<xsl:template match="result[@method = 'registrate_done']">
		<div class="text">
			<p>&registration-activation-note;</p>
		</div>
	</xsl:template>
	
	<xsl:template match="result[@method = 'activate']">
		<xsl:variable name="activation-errors" select="document('udata://users/activate')/udata/error" />
		<div class="text">
			<xsl:choose>
				<xsl:when test="count($activation-errors)">
					<xsl:apply-templates select="$activation-errors" />
				</xsl:when>
				<xsl:otherwise>
					<p>
						<xsl:text>&account-activated;</xsl:text>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

</xsl:stylesheet>
